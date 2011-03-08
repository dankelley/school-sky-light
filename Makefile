all: README.md
%.html : %.md
	markdown $< > $@

force:
webt: force
	cp skynet-01/msl.c ~/Sites/skynett/code
	cp web/*.php web/*.css ~/Sites/skynett
	cp web/images/* ~/Sites/skynett/images
	cp web/code/*.R ~/Sites/skynett/code

web: force
	cp skynet-01/msl.c ~/Sites/skynet/code
	cp web/*.php web/*.css ~/Sites/skynet
	cp web/images/* ~/Sites/skynet/images
	cp web/code/*.R ~/Sites/skynet/code

