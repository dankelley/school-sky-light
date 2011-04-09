all: README.md
%.html : %.md
	markdown $< > $@

force:
webt: force
	cp skyview-01/msl.c ~/Sites/skyviewt/code
	cp web/*.php web/*.css ~/Sites/skyviewt
	cp web/images/* ~/Sites/skyviewt/images
	cp web/code/*.R ~/Sites/skyviewt/code

web: force
	cp skyview-01/msl.c ~/Sites/skyview/code
	cp web/*.php web/*.css ~/Sites/skyview
	cp web/images/* ~/Sites/skyview/images
	cp web/code/*.R ~/Sites/skyview/code

