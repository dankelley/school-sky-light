all: README.html
%.html : %.rst
	rst2html.py $< > $@

force:
web: force
	cp logger/logger2.c ~/Sites/skynet/code
	cp light_to_serial/light_to_serial.pde ~/Sites/skynet/code
	cp slave_logger/msl.c ~/Sites/skynet/code
	cp slave_logger/slave_logger.pde ~/Sites/skynet/code
	cp web/index.html ~/Sites/skynet


