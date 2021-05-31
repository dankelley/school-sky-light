library(oce)
d <- read.table('../skyview-01.dat', header=FALSE)
t <- as.POSIXct(paste(d$V1, d$V2))
light  <- 100 * (1023 - d$V3) / 1023
std <- d$V4
png("weather.png", width=900, height=200, pointsize=13)
oce.plot.ts(t, light, type='l', ylab='Light Intensity (per cent)', ylim=c(0, 100))
load("~/pressure-halifax.rda")
lines(station8539$time, 10 + 5*(station8539$pressure - mean(station8539$pressure,na.rm=TRUE)), col='lightblue', lwd=3)
