#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>

#ifndef	CONSUMER
#define	CONSUMER	"FHEM"
#endif

#define MAX_GPIO 40

#define false 0
#define true 1

struct gpiod_chip *chip;
struct gpiod_line *line[MAX_GPIO];
char chipname[16];

void c_closeGPIO(int gpio) {
	if (gpio<0 || gpio>MAX_GPIO || !chip) {
		return;
	}
	if (line[gpio]) {
		gpiod_line_release(line[gpio]);
	}
	line[gpio]=NULL;
}

MODULE = RPi::GPIOD  PACKAGE = RPi::GPIOD

PROTOTYPES: DISABLE

int
c_openChip (chipid)
	int	chipid
	CODE:
		sprintf(chipname,"gpiochip%1d",chipid);
		//chipname[8]=(char)(chipid+0x30);
		chip = gpiod_chip_open_by_name(chipname);
		if (!chip) {
			XSRETURN_UNDEF;
		}
		for (int i;i<MAX_GPIO;i++) {
			line[i]=NULL;
		}
		RETVAL=true;
	OUTPUT:
	 RETVAL

void
c_closeChip ()
	CODE:
		if (!chip) {
			XSRETURN_UNDEF;
		}
		for (int i;i<MAX_GPIO;i++) {
			c_closeGPIO(i); 
		}
		gpiod_chip_close(chip);

int
c_openGPIO (gpio)
	int	gpio
	CODE:
		if (gpio<0 || gpio>MAX_GPIO || !chip) {
			XSRETURN_UNDEF;
		}
		line[gpio] = gpiod_chip_get_line(chip, gpio);
		if (!line[gpio]) {
			XSRETURN_UNDEF;
		}
		RETVAL=true;
	OUTPUT:
		RETVAL
		
int
c_setInput (gpio) 
	int	gpio
	CODE:
		if (gpio<0 || gpio>MAX_GPIO || !chip || !line[gpio]) {
			XSRETURN_UNDEF;
		}
		int ret = gpiod_line_request_input(line[gpio], CONSUMER);
		if (ret < 0) {
			XSRETURN_UNDEF;
		}
		RETVAL=true;
	OUTPUT:
		RETVAL

int
c_setOutput (gpio) 
	int	gpio
	CODE:
		if (gpio<0 || gpio>MAX_GPIO || !chip || !line[gpio]) {
			XSRETURN_UNDEF;
		}
		int ret = gpiod_line_request_output(line[gpio], CONSUMER, 0);
		if (ret < 0) {
			XSRETURN_UNDEF;
		}
		RETVAL=true;
	OUTPUT:
		RETVAL

int
c_setGPIO (gpio,val) 
	int	gpio
	int val
	CODE:
		if (gpio<0 || gpio>MAX_GPIO || !chip || !line[gpio]) {
			XSRETURN_UNDEF;
		}
		int ret = gpiod_line_set_value(line[gpio], val);
		if (ret<0) {
			XSRETURN_UNDEF;
		}
		RETVAL=true;
	OUTPUT:
		RETVAL

int
c_getGPIO (gpio) 
	int	gpio
	CODE:
		if (gpio<0 || gpio>MAX_GPIO || !chip || !line[gpio]) {
			XSRETURN_UNDEF;
		}
		int ret = gpiod_line_get_value(line[gpio]);
		if (ret<0) {
			XSRETURN_UNDEF;
		}
		RETVAL=ret;
	OUTPUT:
		RETVAL

void
c_closeGPIO (gpio) 
	int gpio

