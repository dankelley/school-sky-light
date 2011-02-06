library(oce)
source('~/src/R-kelley/oce/R/sun.R')
lat <- 44+38/60
lon <- -(63+35/60)
## http://www.timeanddate.com/worldclock/astronomy.html?n=286
d <- read.table('sunrise.dat', header=FALSE)
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + 4 * 3600
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + 4 * 3600 + 12 * 3600
print(sun.angle(sunrise, lat, lon))
mod <- seq(-10, 10, 0.1)
par(mfrow=c(2,1), mar=c(3,3,1,1), mgp=c(3/2,2/3,0))
elevation <- NULL
s <- 3
for (m in mod) {
    elevation <- c(elevation, sun.angle(sunset[s], lat+m, lon)$elevation)
}
plot(lat+mod, elevation, xlab="Latitude", ylab="Elevation", type='l')
abline(h=0)
abline(v=lat)
mtext(format(sunset[s]), adj=1, line=-1)
mtext("sunset", adj=1, line=-2)
elevation <- NULL
for (m in mod) {
    elevation <- c(elevation, sun.angle(sunset[s], lat, lon+m)$elevation)
}
plot(lon+mod, elevation, xlab="Longitude", ylab="Elevation", type='l')
abline(h=0)
abline(v=lon)
angle.misfit <- function(x) { # lat lon
    elevation <- sun.angle(t0, x[1], x[2])$elevation
    ## the angle has an ~1deg negative offset when below the horizon
    mean(ifelse(elevation > 0, abs(elevation), 1 + abs(elevation)))
}
for (t0 in sunrise) print(optim(c(50,0),angle.misfit)$par)
for (t0 in sunset) print(optim(c(50,0),angle.misfit)$par)
t0 <- sunrise; print(optim(c(0,0),angle.misfit)$par)
t0 <- sunset;  print(optim(c(0,0),angle.misfit)$par)

