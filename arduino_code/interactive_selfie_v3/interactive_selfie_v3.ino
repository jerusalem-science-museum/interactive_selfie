/*
 * interactive_light.ino - control 90x20 smart LEDs over uart commands,
 * and sample rotation gesture using capacitive electrodes.
 * 
 * arad@mada.org.il
 * 01/04/2022
 */
#include <Arduino.h>
#include <FastLED.h>					// https://github.com/FastLED/FastLED
#include <Adafruit_MPR121.h>	// https://github.com/adafruit/Adafruit_MPR121
#include "serial_commands.h"

// #define MPR121_ELEC						// undefine in simulator
#define UART_BAUDRATE					(115200)
#define LED_A_PIN							(12)
#define LED_B_PIN							(11)
#define LED_C_PIN							(10)
#define LED_D_PIN							(9)
#define LED_E_PIN							(8)
#define LED_WIDTH							(90)
#define LED_HEIGHT						(20)
#define LED_COUNT							(LED_WIDTH * LED_HEIGHT)
#define LED_STRIP_PER_GROUP		(4)
#define LED_PER_GROUP					(LED_WIDTH * LED_STRIP_PER_GROUP)
#define LED_GROUP_COUNT				(LED_COUNT / LED_PER_GROUP)
#define SPOT_MAX_BRIGHTNESS		(255)
#define SPOT_MAX_SIZE					(10)
#define SPOT_MAX_POS					(999)
#define SPOT_COLOR						(CRGB::Black)
#define ELEC_COUNT						(8)
#define ELEC_INDEX_NONE				(255)
#define ELEC_DEBOUNCE_ON_MS		(20)
#define ELEC_DEBOUNCE_OFF_MS	(300)

#ifdef MPR121_ELEC
Adafruit_MPR121 mpr121 = Adafruit_MPR121();
#endif

CRGB led_group_buff[LED_PER_GROUP];
CRGB spot_color = SPOT_COLOR;
uint8_t led_group;
int16_t spot_x = SPOT_MAX_POS / 2;
int16_t spot_y = SPOT_MAX_POS / 2;
int8_t spot_size = SPOT_MAX_SIZE / 2;
uint8_t elec_last_index;
uint8_t elec_debounce_index;
uint32_t elec_debounce_ms;

void cmd_help()
{
	Serial.print(F(NL
		"---Interactive Light V2---" NL
		" Commands (use \\n terminator!):" NL
		"  H: Print this help message." NL
		"  C [Hue=0] [Saturation=0] [Brightness=0]: Set spot HSB color- 0 (0%) to 255 (100%)." NL
		"  S [s=0]: Set spot size- negative is square, positive is circle- -10 to 10." NL
		"  X [x=0]: Set spot X position- 0 (left) to 999 (right)." NL
		"  Y [y=0]: Set spot y position- 0 (top) to 999 (bottom)." NL
	));
}

void draw_pixel(int16_t x, int16_t y, CRGB c)
{
	if (x < 0 || x >= LED_WIDTH || y < 0 || y >= LED_HEIGHT)
		return;

	if (~y & 1) // simulator is connected in mirror
		x = LED_WIDTH - 1 - x;

	if ((y / LED_STRIP_PER_GROUP) == led_group)
		led_group_buff[x + (y % LED_STRIP_PER_GROUP) * LED_WIDTH] = c;
}

void draw_line_hh(int16_t x, int16_t y, int16_t x2, CRGB c)
{
	int16_t w = x2 - x;

	if (w < 0) {
		w = -w;
		x = x2;
	}
	w++;
	while (w--)
		draw_pixel(x++, y, c);
}

void draw_filled_rect(int16_t xc, int16_t yc, uint16_t s, CRGB c)
{
	for (int16_t y = 0; y <= s; y++) {
		draw_line_hh(xc + s, yc + y, xc - s, c);
		draw_line_hh(xc + y, yc + s, xc - y, c);
		draw_line_hh(xc - s, yc - y, xc + s, c);
		draw_line_hh(xc - y, yc - s, xc + y, c);
	}
}

void draw_filled_circle(int16_t xc, int16_t yc, uint16_t r, CRGB c)
{
	int16_t x = r;
	int16_t y = 0;
	int16_t e = 1 - x;

	while (x >= y) {
		draw_line_hh(xc + x, yc + y, xc - x, c);
		draw_line_hh(xc + y, yc + x, xc - y, c);
		draw_line_hh(xc - x, yc - y, xc + x, c);
		draw_line_hh(xc - y, yc - x, xc + y, c);

		y++;
		if (e >= 0) {
			x--;
			e += 2 * (y + 1 - x);
		}
		else
			e += 2 * y + 1;
	}
}

void update_leds()
{
	int16_t s = abs(spot_size);
	int16_t x = map(spot_x, 0, SPOT_MAX_POS, s, LED_WIDTH - 1 - s);
	int16_t y = map(spot_y, 0, SPOT_MAX_POS, s, LED_HEIGHT - 1 - s);

	for (led_group = 0; led_group < LED_GROUP_COUNT; led_group++) {
		fill_solid(led_group_buff, LED_PER_GROUP, CRGB::Black);
		if (spot_size < 0)
			draw_filled_rect(x, y, -spot_size, spot_color);
		else
			draw_filled_circle(x, y, spot_size, spot_color);
		FastLED[led_group].show(led_group_buff, LED_PER_GROUP, SPOT_MAX_BRIGHTNESS);
	}
}

void cmd_cb(const char *cmd_line, uint8_t cmd_len)
{
	long a = 0, b = 0, c = 0;

	switch (*sc_get_arg_str() & 0xDF) {
	case 'H':
		cmd_help();
		break;
	case 'C':
		if (sc_get_arg_int(a, SC_FLAG_ERROR, 0, 255))
			return;
		if (sc_get_arg_int(b, SC_FLAG_ERROR, 0, 255))
			return;
		if (sc_get_arg_int(c, SC_FLAG_ERROR, 0, 255))
			return;
		spot_color = CHSV(a, b, c);
		break;
	case 'S':
		if (sc_get_arg_int(a, SC_FLAG_ERROR, -SPOT_MAX_SIZE, SPOT_MAX_SIZE))
			return;
		spot_size = a;
		break;
	case 'X':
		if (sc_get_arg_int(a, SC_FLAG_ERROR, 0, SPOT_MAX_POS))
			return;
		spot_x = a;
		break;
	case 'Y':
		if (sc_get_arg_int(a, SC_FLAG_ERROR, 0, SPOT_MAX_POS))
			return;
		spot_y = a;
		break;
	default:
		Serial << "No such command: " << cmd_line << NL;
		return;
	}
	update_leds();
}

void setup()
{
	Serial.begin(UART_BAUDRATE);

	FastLED.addLeds<NEOPIXEL, LED_A_PIN>(led_group_buff, LED_PER_GROUP);
	FastLED.addLeds<NEOPIXEL, LED_B_PIN>(led_group_buff, LED_PER_GROUP);
	FastLED.addLeds<NEOPIXEL, LED_C_PIN>(led_group_buff, LED_PER_GROUP);
	FastLED.addLeds<NEOPIXEL, LED_D_PIN>(led_group_buff, LED_PER_GROUP);
	FastLED.addLeds<NEOPIXEL, LED_E_PIN>(led_group_buff, LED_PER_GROUP);
	update_leds();

#ifdef MPR121_ELEC
	if (!mpr121.begin())
		Serial.println("Faild to find MPR121!");

	mpr121.writeRegister(MPR121_SOFTRESET, 0x63);
	delay(1);
	// goto stand-by in order to write settings
	mpr121.writeRegister(MPR121_ECR, 0x0);
	// set all electrodes threshholds
	mpr121.setThresholds(40, 10);
	// 1 readings for touch and release
	mpr121.writeRegister(MPR121_DEBOUNCE, 1 | (1 << 3));
	// charge electrodes with 63mA in 1us
	mpr121.writeRegister(MPR121_CONFIG1, 63);
	mpr121.writeRegister(MPR121_CONFIG2, (3 << 3) | (2 << 5));
	// auto config baseline and filters
	mpr121.writeRegister(MPR121_AUTOCONFIG0, 0x0F);
	mpr121.writeRegister(MPR121_UPLIMIT, 800 >> 2);		// ((Vdd - 0.7)/Vdd) * 256
	mpr121.writeRegister(MPR121_TARGETLIMIT, 700 >> 2);	// UPLIMIT * 0.9
	mpr121.writeRegister(MPR121_LOWLIMIT, 600 >> 2);	// UPLIMIT * 0.65
	// enable electrodes and goto run mode (must be the last configuration)
	mpr121.writeRegister(MPR121_ECR, 12 | (2 << 6));
#endif

	sc_begin(&cmd_cb);
	cmd_help();
}

void loop()
{
	if (Serial.available())
		sc_update(Serial.read());

#ifdef MPR121_ELEC
	uint32_t cur_ms = millis();
	uint8_t elec_index = ELEC_INDEX_NONE;
	uint16_t elec_bitmask = mpr121.touched() & ((uint16_t)_BV(ELEC_COUNT + 1) - 1);

	for (uint8_t i = 0; i < ELEC_COUNT; i++)
		if (elec_bitmask == (uint16_t)_BV(i))
			elec_index = i;

	if (elec_debounce_index != elec_index) {
		elec_debounce_index = elec_index;
		elec_debounce_ms = cur_ms + (elec_index == ELEC_INDEX_NONE ?
			ELEC_DEBOUNCE_OFF_MS : ELEC_DEBOUNCE_ON_MS);
	}
	if (elec_debounce_ms) {
		if (cur_ms > elec_debounce_ms)
			elec_debounce_ms = 0;
		else
			elec_index = elec_last_index;
	}

	if (elec_last_index != elec_index) {
		if ((elec_last_index | elec_index) != ELEC_INDEX_NONE) {
			switch ((ELEC_COUNT + elec_index - elec_last_index) % ELEC_COUNT) {
			case 1:
				Serial.print("T 1" NL);
				break;
			case ELEC_COUNT - 1:
				Serial.print("T 0" NL);
				break;
			}
		}
		elec_last_index = elec_index;
	}
#endif
}

/*
	#define POT_X_PIN						(A5)
	#define POT_Y_PIN						(A6)
	#define POT_Z_PIN						(A7)

	// spot_x = map(analogRead(POT_X_PIN), 1023, 0, 0, (LED_WIDTH - 1));
	// spot_y = map(analogRead(POT_Y_PIN), 0, 1023, 0, (LED_HEIGHT - 1));
	// spot_size = map(analogRead(POT_Z_PIN), 0, 1023, 1, (LED_HEIGHT / 2));

	diagram.json pots
    {
      "type": "wokwi-slide-potentiometer",
      "id": "pot1",
      "top": 1200,
      "left": -1400,
      "attrs": { "travelLength": "30", "value": "50" }
    },
    {
      "type": "wokwi-slide-potentiometer",
      "id": "pot2",
      "top": 1300,
      "left": -1400,
      "attrs": { "travelLength": "30", "value": "50" }
    },
    {
      "type": "wokwi-slide-potentiometer",
      "id": "pot3",
      "top": 1400,
      "left": -1400,
      "attrs": { "travelLength": "30", "value": "50" }
    },

    [ "pot3:GND", "nano:GND.1", "black", [ "v0" ] ],
    [ "pot2:GND", "nano:GND.1", "black", [ "v0" ] ],
    [ "pot1:GND", "nano:GND.1", "black", [ "v0" ] ],
    [ "nano:5V", "pot1:VCC", "red", [ "h0" ] ],
    [ "nano:5V", "pot2:VCC", "red", [ "h0" ] ],
    [ "nano:5V", "pot3:VCC", "red", [ "h0" ] ],
    [ "pot1:SIG", "nano:A5", "green", [ "h-10", "v0" ] ],
    [ "pot2:SIG", "nano:A6", "green", [ "h-20", "v0" ] ],
    [ "pot3:SIG", "nano:A7", "green", [ "h-30", "v0" ] ],

*/