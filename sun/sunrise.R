library(oce)
use.refraction <- TRUE
D <- 2.0
elevation.misfit <- function(e) {
    mean(ifelse(e > 0, abs(e), D + abs(e)))
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
lat <- 44+39/60
lon <- -(63+36/60)

## http://www.timeanddate.com/worldclock/astronomy.html?n=286
d <- read.table('sunrise.dat', header=FALSE)
tz <- 4 * 3600
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + tz
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + tz + 12 * 3600
# http://en.wikipedia.org/wiki/Angular_diameter
if (FALSE) {
    sun.time <- 31/60 / 360 * 24 * 3600
    sunrise <- sunrise + sun.time
    sunset <- sunset - sun.time
}
mod <- seq(-10, 10, 0.1)
par(mfrow=c(2,1), mar=c(3,3,1,1), mgp=c(3/2,2/3,0))
for (s in 1:length(d$V1)) {
    cat("s=",s,"\n")
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunset[s], lat+m, lon, use.refraction)$elevation)
    plot(lat+mod, elevation, xlab="Latitude", ylab="Elevation", type='l')
    ## optimized fits
    t0 <- sunrise[s]
    latfit <- optim(c(0),angle.misfit.1)$par
    lonfit <- optim(c(0),angle.misfit.2)$par
    abline(h=0)
    abline(v=lat, col='blue')
    mtext(format(sunset[s]), adj=1, line=-1)
    mtext("sunset", adj=1, line=-2)
    mtext(paste("actual: ", format(lat, digits=5), "N  ", format(lon,digits=5), "E", sep=""),
          adj=1, line=-3, col='blue')
    mtext(paste("fit:    ", format(latfit, digits=5), "N  ", format(lonfit,digits=5), "E", sep=""),
          adj=1, line=-4, col='red')
    error <- geod.dist(lat, lon, latfit, lonfit)
    mtext(sprintf("Misfit: %.1f km", error), adj=1, line=-5)
    abline(v=latfit, col='red')
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunset[s], lat, lon+m, use.refraction)$elevation)
    plot(lon+mod, elevation, xlab="Longitude", ylab="Elevation", type='l')
    abline(h=0)
    abline(v=lon, col='blue')
    abline(v=lonfit, col='red')
}

for (t0 in sunrise) print(optim(c(50,0),angle.misfit)$par)
for (t0 in sunset) print(optim(c(50,0),angle.misfit)$par)
t0 <- sunrise[1]; print(optim(c(0,0),angle.misfit)$par)
t0 <- sunset[1];  print(optim(c(0,0),angle.misfit)$par)
warning("performs poorly when trying for both lat and lon\n")
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
plot(coastline.world, xlim=c(-70, -50), ylim=c(40,55),axes=TRUE)
points(fitlon, fitlat, col='red', pch='+', cex=1.5)
title("can the data be wrong?")


