all: README.md
%.html : %.md
	markdown $< > $@

force:
web: force
	cp skynet-01/msl.c ~/Sites/skynet/code
	cp web/*.php web/*.css ~/Sites/skynet
	cp web/images/* ~/Sites/skynet/images
	cp web/code/*.R ~/Sites/skynet/code
