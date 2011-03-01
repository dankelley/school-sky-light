all: README.md
%.html : %.md
	markdown $< > $@

force:
web: force
	cp light_to_serial/light_to_serial.pde ~/Sites/skynet/code
	cp skynet-01/msl.c ~/Sites/skynet/code
	cp skynet-01/slave_logger/slave_logger.pde ~/Sites/skynet/code
	cp web/index.html ~/Sites/skynet
	cp web/code/sunrise_sunset.R ~/Sites/skynet/code
	cp web/code/calibration.R ~/Sites/skynet/code
	cp web/code/plot.R ~/Sites/skynet/code
