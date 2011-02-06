library(oce)
lat <- 44+38/60
lon <- -(63+35/60)
## http://www.timeanddate.com/worldclock/astronomy.html?n=286
d <- read.table('~/sunrise.dat', header=FALSE)
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + 4 * 3600
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + 4 * 3600 + 12 * 3600
print(sun.angle(sunrise, lat, lon))
lat.mod <- seq(-1, 1, 0.1)
lat.error <- NULL
for (mod in lat.mod) {
    lat.error <- c(lat.error, median(sun.angle(sunset, lat+mod, lon)$elevation))
}
plot(lat.mod, lat.error)
abline(h=0)
abline(v=0)

angle.misfit <- function(x) { # lat lon
    median((sun.angle(t0, x[1], x[2])$elevation)^2)
}
for (t0 in sunrise) print(optim(c(50,0),angle.misfit)$par)
for (t0 in sunset) print(optim(c(50,0),angle.misfit)$par)
t0 <- sunrise; print(optim(c(50,0),angle.misfit)$par)
t0 <- sunset;  print(optim(c(50,0),angle.misfit)$par)

