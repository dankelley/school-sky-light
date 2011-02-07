##http://www.timeanddate.com/worldclock/astronomy.html?n=286&month=2&year=2011&obj=sun&afl=-11&day=1
library(oce)
use.refraction <- TRUE
D <- 2.0
elevation.misfit <- function(e) {
    mean(ifelse(e > 0, abs(e), 10*abs(e)))
}
angle.misfit.1 <- function(x) { # lat
    elevation <- sun.angle(t0, x[1], lon, use.refraction)$elevation
    elevation.misfit(elevation)
}
angle.misfit.2 <- function(x) { # lon
    elevation <- sun.angle(t0, lat, x[1], use.refraction)$elevation
    elevation.misfit(elevation)
}
angle.misfit <- function(x) { # lat lon
    cat(sprintf("%10.2f %10.2f\n", x[1], x[2]))
    elevation <- sun.angle(t0, x[1], x[2], use.refraction)$elevation
    elevation.misfit(elevation)
}
angle.misfit.day <- function(x) { # lat lon (given trise, tset)
    ##cat(sprintf("%10.2f %10.2f\n", x[1], x[2]))
    elevation.rise <- sun.angle(trise, x[1], x[2], use.refraction)$elevation
    elevation.set  <- sun.angle(tset,  x[1], x[2], use.refraction)$elevation
    ## the angle has an ~1deg negative offset when below the horizon
    elevation.misfit(elevation.rise) + elevation.misfit(elevation.rise)
}
lat <- 44+38/60                        #http://www.timeanddate.com/worldclock/city.html?n=286
lon <- -(63+35/60)                     #http://www.timeanddate.com/worldclock/city.html?n=286

## http://www.timeanddate.com/worldclock/astronomy.html?n=286
d <- read.table('sunrise.dat', header=FALSE)
tz <- 4 * 3600
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + tz
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + tz + 12 * 3600
# http://en.wikipedia.org/wiki/Angular_diameter
tex <- 0.75 
mod <- seq(-10, 10, 0.1)
pdf("fit-1.pdf", width=8.5, height=11)
par(mfrow=c(4,1), mar=c(3,3,1,1), mgp=c(3/2,2/3,0))
for (s in 1:length(d$V1)) {
    cat("s=",s,"\n")
    ## Sunrise
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunrise[s], lat+m, lon, use.refraction)$elevation)
    plot(lat+mod, elevation, xlab="Latitude", ylab="Elevation", type='l')
    ## optimized fits
    t0 <- sunrise[s]
    latfit <- optim(c(0),angle.misfit.1)$par
    lonfit <- optim(c(0),angle.misfit.2)$par
    abline(h=0)
    abline(v=lat, col='blue')
    mtext(paste("Sunrise:", format(sunrise[s])), adj=1, line=-1, cex=tex)
    mtext(sprintf("Actual: %6.2fN %6.2fE  fit: %6.2fN %6.2fE ", lat, lon, latfit, lonfit), adj=1, line=-2, cex=tex)
    error <- geod.dist(lat, lon, latfit, lonfit)
    mtext(sprintf("Misfit: %.1f km ", error), adj=1, line=-3, cex=tex)
    abline(v=latfit, col='red')
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunrise[s], lat, lon+m, use.refraction)$elevation)
    plot(lon+mod, elevation, xlab="Longitude", ylab="Elevation", type='l')
    abline(h=0)
    abline(v=lon, col='blue')
    abline(v=lonfit, col='red')

    ## Sunset
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunset[s], lat+m, lon, use.refraction)$elevation)
    plot(lat+mod, elevation, xlab="Latitude", ylab="Elevation", type='l')
    ## optimized fits
    t0 <- sunset[s]
    latfit <- optim(c(0),angle.misfit.1)$par
    lonfit <- optim(c(0),angle.misfit.2)$par
    abline(h=0)
    abline(v=lat, col='blue')
    mtext(paste("Sunset:", format(sunset[s])), adj=1, line=-1, cex=tex)
    mtext(sprintf("Actual: %6.2fN %6.2fE  fit: %6.2fN %6.2fE ", lat, lon, latfit, lonfit), adj=1, line=-2, cex=tex)
    error <- geod.dist(lat, lon, latfit, lonfit)
    mtext(sprintf("Misfit: %.1f km ", error), adj=1, line=-3, cex=tex)
    abline(v=latfit, col='red')
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunset[s], lat, lon+m, use.refraction)$elevation)
    plot(lon+mod, elevation, xlab="Longitude", ylab="Elevation", type='l')
    abline(h=0)
    abline(v=lon, col='blue')
    abline(v=lonfit, col='red')
}
dev.off()

pdf("map.pdf", width=8.5, height=11)
fitlon <- fitlat <- NULL
for (s in 1:length(sunrise)) {
    trise <- sunrise[s]
    tset <- sunset[s]
    fit <- optim(c(0,0),angle.misfit.day)$par
    fitlat <- c(fitlat, fit[1])
    fitlon <- c(fitlon, fit[2])
    error <- geod.dist(lat, lon, fit[1], fit[2])
    cat(sprintf("actual: %8.2fN %8.2fE  fit: %8.2fN %8.2fE (error %.1fkm)\n",
                lat, lon, fit[1], fit[2], error))
}
par(mfrow=c(1,1))
data(coastline.world)
plot(coastline.world, center=c(lat, lon), span=1500)
abline(v=lon, h=lat)
points(fitlon, fitlat, col='red', pch='+', cex=1.5)
title("can the data be wrong?")
dev.off()

##
pdf("rise-set-timing.pdf",width=8.5,height=11)
n <- min(5, length(sunrise))
par(mfrow=c(n, 2))
dt <- seq(-120,120,1)
for (s in seq(1, length(sunrise), length.out=n)) {   # only sample
    ylim <- c(-1.5, 0.3)
    oce.plot.ts(sunrise[s]+dt, sun.angle(sunrise[s]+dt, lat, lon)$elevation,
                ylab="Elevation", ylim=ylim,lwd=2)
    abline(h=0)
    abline(v=sunrise[s])
    oce.plot.ts(sunset[s]+dt, sun.angle(sunset[s]+dt, lat, lon)$elevation,ylim=ylim,lwd=2)
    abline(h=0)
    abline(v=sunset[s])
}
dev.off()

