#include <FastLED.h>

// #define IS_ZIGZAG
#define LED_A_PIN           (23)
#define POT_X_PIN           (25)
#define POT_Y_PIN           (26)
#define POT_Z_PIN           (27)
#define LED_BRIGHTNESS      (255)
#define LED_STRIPS          (20) // 10
#define LED_PER_STRIP       (90) // 60
#define LED_COUNT           (LED_STRIPS * LED_PER_STRIP)

CRGB leds[LED_COUNT];

void draw_pixel(int16_t x, int16_t y, CRGB c)
{
  if (x < 0 || x >= LED_PER_STRIP || y < 0 || y >= LED_STRIPS)
    return;
  
#ifdef IS_ZIGZAG
  if (y & 1)
    x = LED_PER_STRIP - 1 - x;
#endif

  leds[x + y * LED_PER_STRIP] = c;
}

void draw_line_h(int16_t x, int16_t y, int16_t w, CRGB c)
{
  while (w--)
    draw_pixel(x++, y, c);
}

void draw_line_hh(int16_t x, int16_t y, int16_t x2, CRGB c)
{
  int16_t w = x2 - x;
  if (w < 0) {
    w = -w;
    x = x2;
  }
  while (w--)
    draw_pixel(x++, y, c);
}

void draw_line_v(int16_t x, int16_t y, int16_t h, CRGB c)
{
  while (h--)
    draw_pixel(x, y++, c);
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

void setup()
{
  FastLED.addLeds<NEOPIXEL, LED_A_PIN>(leds, LED_COUNT);
}

void loop()
{
  uint16_t x = map(analogRead(POT_X_PIN), 0, 4095, 0, (LED_PER_STRIP - 1));
  uint16_t y = map(analogRead(POT_Y_PIN), 0, 4095, 0, (LED_STRIPS - 1));
  uint16_t z = map(analogRead(POT_Z_PIN), 0, 4095, 1, (LED_STRIPS / 2));

  fill_solid(leds, LED_COUNT, CRGB::Black);
  draw_filled_circle(x, y, z, CRGB::Crimson);
  FastLED.show();
  delay(20);
}
