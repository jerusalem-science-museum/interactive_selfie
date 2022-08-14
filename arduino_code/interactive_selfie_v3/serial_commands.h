/*
 * serial_commands - API for implementing simple serial commands protocol over serial stream.
 * 
 * arad@mada.org.il
 * 21/08/2021
 */
#ifndef _SERIAL_COMMANDS_H_
#define _SERIAL_COMMANDS_H_

#include <Arduino.h>
#include <limits.h>

// Print with stream operator
template<class T> inline Print& operator <<(Print &obj,     T arg) { obj.print(arg);    return obj; }
template<>        inline Print& operator <<(Print &obj, float arg) { obj.print(arg, 4); return obj; }

#define NL								"\n"
#define SC_ARG_SEP						(" ")
#define SC_BUFF_SIZE					(SERIAL_RX_BUFFER_SIZE)

typedef enum {
	SC_ARG_OK = 0,
	SC_ARG_EMPTY,
	SC_ARG_INVALID,
	SC_ARG_OUT_OF_RANGE,
} sc_arg_t;

typedef enum {
	SC_FLAG_DEC = 0,
	SC_FLAG_BIN = 1,
	SC_FLAG_OCT = 2,
	SC_FLAG_HEX = 3,
	SC_FLAG_ERROR = 4,
	SC_FLAG_EMPTY = 8,
	// SC_FLAG_DEFAULT = 16,
} sc_arg_flag_t;

const uint8_t _SC_INT_BASE[] = {10, 2, 8, 16};

typedef void (*sc_cmd_cb_t)(const char *cmd_line, uint8_t cmd_len);

char _sc_buff[SC_BUFF_SIZE];
char _sc_arg_buff[SC_BUFF_SIZE];
char *_sc_arg;
uint8_t _sc_arg_index;
uint8_t _sc_buff_index;
sc_cmd_cb_t _sc_cmd_cb = NULL;

char *sc_get_arg_str(sc_arg_flag_t flags=SC_FLAG_ERROR);
sc_arg_t sc_get_arg_int(long &value, sc_arg_flag_t flags=SC_FLAG_ERROR, long min_v=LONG_MIN, long max_v=LONG_MAX);

void sc_begin(sc_cmd_cb_t cmd_cb)
{
	_sc_buff_index = 0;
	_sc_cmd_cb = cmd_cb;
}

void sc_update(char c)
{
	if (c == '\r' || c == '\n') {
		_sc_buff[_sc_buff_index] = '\0';
		strcpy(_sc_arg_buff, _sc_buff);
		_sc_arg = strtok(_sc_arg_buff, SC_ARG_SEP);
		_sc_arg_index = 0;
		if (_sc_cmd_cb && _sc_buff_index)
			_sc_cmd_cb(_sc_buff, _sc_buff_index);
		_sc_buff_index = 0;
	}
	else if (c >= ' ' && c <= '~') {
		_sc_buff[_sc_buff_index] = c;
		if (++_sc_buff_index >= SC_BUFF_SIZE) {
			Serial.println(F("Serial cmd overflow!"));
			_sc_buff_index = 0;
		}
	}
}

bool sc_available()
{
	return _sc_arg;
}

char *sc_get_arg_str(sc_arg_flag_t flags)
{
	char *arg = _sc_arg;
	if (_sc_arg != _sc_arg_buff)
		_sc_arg_index++;
	_sc_arg = strtok(0, SC_ARG_SEP);
	if (!arg && (flags & SC_FLAG_EMPTY)) {
		Serial.print(F("Argument["));
		Serial.print(_sc_arg_index);
		Serial.println(F("] is missing"));
	}
	return arg;
}

sc_arg_t sc_get_arg_int(long &value, sc_arg_flag_t flags, long min_v, long max_v)
{
	char *arg = sc_get_arg_str(flags);
	if (!arg)
		return (flags & SC_FLAG_EMPTY ? SC_ARG_EMPTY : SC_ARG_OK);
	char *end_ptr = arg;
	long ret = strtol(arg, &end_ptr, _SC_INT_BASE[flags & 3]);
	if (*end_ptr) {
		if (flags & SC_FLAG_ERROR) {
			Serial.print(F("Argument["));
			Serial.print(_sc_arg_index);
			Serial.print(F("] invalid int: "));
			Serial.println(arg);
		}
		return SC_ARG_INVALID;
	}
	if (ret < min_v || ret > max_v) {
		if (flags & SC_FLAG_ERROR) {
			Serial.print(F("Argument["));
			Serial.print(_sc_arg_index);
			Serial.print(F("] out of range("));
			Serial.print(min_v);
			Serial.print(F(", "));
			Serial.print(max_v);
			Serial.print(F("): "));
			Serial.println(ret);
		}
		return SC_ARG_OUT_OF_RANGE;
	}
	value = ret;
	return SC_ARG_OK;
}

#endif
