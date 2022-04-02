/*
 * interactive_light.ino - control 4 smart LED strip over over uart commands.
 * 
 * arad@mada.org.il
 * 15/12/2021
 */
#include <FastLED.h>
#include "serial_commands.h"

#define UART_BAUDRATE       (115200)
#define LED_R_PIN           (4)
#define LED_U_PIN           (5)
#define LED_D_PIN           (6)
#define LED_L_PIN           (7)
#define LED_BRIGHTNESS      (255)
#define LED_STRIPS          (4)
#define LED_PER_STRIP       (50)
#define LED_COUNT           (LED_STRIPS * LED_PER_STRIP)

const char LED_STRIPS_CHAR[] = "RUDL";
CRGB leds[LED_COUNT];

void cmd_help()
{
	Serial.println(F(NL
		"Interactive LED - use \\n terminator!" NL
		"  Commands:" NL
		"    H: Print this help message." NL
		"    O: Power off LEDs." NL
		"    L/R/U/D [index=0] [length=1] [color=127]: Set left/right/up/down LEDs." NL
	));
}

void cmd_cb(const char *cmd_line, uint8_t cmd_len)
{
	long a = 0, b = 0, c = 0;
  CRGB *leds_ptr;

	switch (*sc_get_arg_str() & 0xDF) {
	case 'H':
		cmd_help();
		break;
	case 'O':
		fill_solid(leds, LED_COUNT, CRGB::Black);
    FastLED.show();
		break;
	case 'L':
	case 'R':
	case 'U':
	case 'D':
    a = 0;
    b = 1;
    c = 127;
		if (sc_get_arg_int(a, SC_FLAG_ERROR, 0, LED_PER_STRIP - 1))
			return;
		if (sc_get_arg_int(b, SC_FLAG_ERROR, 0, LED_PER_STRIP))
			return;
		if (sc_get_arg_int(c, SC_FLAG_ERROR, 0, 255))
			return;

    for (uint8_t i = 0; i < LED_STRIPS; i++)
      if (*_sc_buff == LED_STRIPS_CHAR[i]) {
        fill_solid(&leds[i * LED_PER_STRIP], LED_PER_STRIP, CRGB::Black);
        leds_ptr = &leds[a + i * LED_PER_STRIP];
      }

    if (c < 128)
      *leds_ptr = CRGB(c * 2, c * 2, c * 2);
    else
      *leds_ptr = CHSV((c - 128) * 2, 0xFF, 0xFF);

    fill_solid(leds_ptr, b, *leds_ptr);
    FastLED.show();
    Serial << _sc_buff << NL;
		break;
	default:
		Serial << "No such command: " << cmd_line << NL;
		break;
	}
}

void setup()
{
  Serial.begin(UART_BAUDRATE);
  FastLED.addLeds<NEOPIXEL, LED_R_PIN>(&leds[0 * LED_PER_STRIP], LED_PER_STRIP);
  FastLED.addLeds<NEOPIXEL, LED_U_PIN>(&leds[1 * LED_PER_STRIP], LED_PER_STRIP);
  FastLED.addLeds<NEOPIXEL, LED_D_PIN>(&leds[2 * LED_PER_STRIP], LED_PER_STRIP);
  FastLED.addLeds<NEOPIXEL, LED_L_PIN>(&leds[3 * LED_PER_STRIP], LED_PER_STRIP);
  FastLED.setBrightness(LED_BRIGHTNESS);
	sc_begin(&cmd_cb);
	cmd_help();
}

void loop()
{
	if (Serial.available())
		sc_update(Serial.read());
}
