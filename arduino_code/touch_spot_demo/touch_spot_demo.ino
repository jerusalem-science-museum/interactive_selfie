#include <Arduino.h>			// uses timer 0
#include <TM1638plus.h>			// https://github.com/gavinlyonsrepo/TM1638plus.git
#include <FastLED.h>			// https://github.com/FastLED/FastLED

#define TOUCH_LEFT_PIN				(2)
#define TOUCH_RIGHT_PIN				(3)
#define TM_STROBE_PIN				(8)
#define TM_CLOCK_PIN				(9)
#define TM_DIO_PIN					(10)
#define LED_DATA_PIN				(12)
#define SPOT_COLD_LED_PIN			(5) // OCR0B
#define SPOT_WARM_LED_PIN			(6) // OCR0A
#define MIC_PIN						(A0)

#define TOUCH_COUNT					(2)
#define TOUCH_MS					(3)
#define SPOT_COUNT					(2)
#define SPOT_MAX_BRIGHTNESS			(100)
#define LED_COUNT					(8)
#define LED_BRIGHTNESS				(255)
#define LED_TYPE					SK6812
#define LED_COLOR_ORDER				GRB
#define LED_CORRECTION				UncorrectedColor
#define LED_TEMPERATURE				UncorrectedTemperature

CRGB leds[LED_COUNT];
TM1638plus tm(TM_STROBE_PIN, TM_CLOCK_PIN , TM_DIO_PIN);

enum {
	TOUCH_STATE_INC = 1,
	TOUCH_STATE_PRESS,
};

enum {
	BTN_ADD_WW = _BV(7),
	BTN_ADD_CW = _BV(6),
};

struct {
	uint8_t mode;

	struct {
		CRGB color;
		uint8_t state;
		uint32_t last_ms;
	} leds[TOUCH_COUNT];

	struct {
		uint8_t pin;
		uint8_t state;
		uint32_t last_ms;
	} touch[TOUCH_COUNT];

	struct {
		uint8_t pin;
		uint8_t value;
		CRGB color;
		uint8_t state;
		uint32_t last_ms;
	} spot[SPOT_COUNT];
} self;


// Read and debounce the buttons form TM1638
// uint8_t buttonsRead(void)
// {
// 	uint8_t buttons = 0;
// 	unsigned long currentMillis = millis();
// 	if (currentMillis - previousMillis >= interval) {
// 		previousMillis = currentMillis;
// 		buttons = tm.readButtons();
// 	}
// 	return buttons;
// }

void set_leds(uint8_t index, uint8_t cw, uint8_t ww, uint8_t aw)
{
	leds->setColorCode(0);
	leds[index] = CRGB(cw, ww, aw);
	FastLED.show();
}

void set_leds_a(uint8_t warm_brightness, uint8_t cold_brightness)
{
	OCR0A = 255 - warm_brightness / 2;
	OCR0B = cold_brightness / 2;
}

// true 100% light when brightness is 255.
void set_leds_b(uint8_t warmness, uint8_t brightness)
{
	uint16_t a = (uint16_t)(warmness) * brightness;
	uint16_t b = (uint16_t)(255 - warmness) * brightness;

	OCR0A = a / 255;
	OCR0B = 255 - b / 255;
}

void setup()
{
	Serial.begin(UART_BAUDRATE);
	Serial.setTimeout(UART_TIMEOUT);

	tm.displayBegin();
	tm.brightness(0);
	tm.displayText("PrESS S1");
	// tm.setLED(0, 1);
	// tm.setLEDs(0x0000);
	// uint8_t buttons = tm.readButtons();

	FastLED.addLeds<LED_TYPE, LED_DATA_PIN, LED_COLOR_ORDER>(leds, LED_COUNT);
	FastLED.setCorrection(LED_CORRECTION);
	FastLED.setTemperature(LED_TEMPERATURE);
	FastLED.setBrightness(LED_BRIGHTNESS);

	pinMode(SPOT_COLD_LED_PIN, OUTPUT);
	pinMode(SPOT_WARM_LED_PIN, OUTPUT);

	// use timer0: arduino already config it to FastPWM with 64 prescalar,
	// FastPWM have a bug resulting in PD5 pulsing even on OCR0B=0,
	// So we set the mode to PhaseCorrectPWM (page 108) and enable OCRs (page 106):
	// OC0A - inverting, OC0B - normal, mode - PhaseCorrectPWM.
	TCCR0A = _BV(COM0A1) | _BV(COM0A0) | _BV(COM0B1) | _BV(WGM00);

	set_leds_b(0, 0);

	self.spot[0].pin = SPOT_WARM_LED_PIN;
	self.spot[1].pin = SPOT_COLD_LED_PIN;

	self.touch[0].pin = TOUCH_LEFT_PIN;
	self.touch[1].pin = TOUCH_RIGHT_PIN;
}

void loop()
{
	uint32_t cur_ms = millis();

	uint8_t buttons = tm.readButtons();
	if (buttons & BTN_ADD_WW) {
		// leds += CRGB(1, 0, 0);
		// self.leds.color += CRGB(1, 0, 0);
	}

	for (uint8_t i = 0; i < TOUCH_COUNT; i++) {
		if (digitalRead(self.touch[i].pin)) {
			if (self.touch[i].state & TOUCH_STATE_PRESS) {
				if (cur_ms - self.touch[i].last_ms > TOUCH_MS) {
					self.touch[i].last_ms = cur_ms;
					if (self.touch[i].state & TOUCH_STATE_INC)
						self.spot[i].color -= CRGB(1, 1, 1);
					else
						self.spot[i].color += CRGB(1, 1, 1);
					self.spot[i].value = self.spot[i].color.red;
					// Serial.println(self.spot[i].value);
				}
			}
			else {
				self.touch[i].state |= TOUCH_STATE_PRESS;
				self.touch[i].state ^= TOUCH_STATE_INC;
				Serial.print("Touch "); Serial.print(i); Serial.println(" pressed");
			}
		}
		else
			self.touch[i].state &= ~TOUCH_STATE_PRESS;
	}


	set_leds_a((self.spot[0].value * SPOT_MAX_BRIGHTNESS) / 255, (self.spot[1].value * SPOT_MAX_BRIGHTNESS) / 255);
	// for (uint8_t i = 0; i < SPOT_COUNT; i++)
	// 	analogWrite(self.spot[i].pin, (self.spot[i].value * SPOT_MAX_BRIGHTNESS) / 255);
}
