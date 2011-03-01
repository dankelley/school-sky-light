all: README.md
%.html : %.md
	markdown $< > $@

force:
web: force
	cp skynet-01/msl.c ~/Sites/skynet/code
	cp web/*php ~/Sites/skynet
	cp web/code/sunrise_sunset.R ~/Sites/skynet/code
	cp web/code/calibration.R ~/Sites/skynet/code
	cp web/code/plot.R ~/Sites/skynet/code
