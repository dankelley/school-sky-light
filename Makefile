all: README.html
%.html : %.rst
	rst2html.py $< > $@

