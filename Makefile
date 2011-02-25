all: README.html
%.html : %.rst
	rst2html.py $< > $@

web:
	cp logger/logger2.c ~/Sites/skynet/code
	cp light_to_serial/light_to_serial.pde ~/Sites/skynet/code


