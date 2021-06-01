library(oce)
use.refraction <- TRUE
elevation <- function(x) { # x is latitude
    mean(sunAngle(t0, lon[i], x[1], use.refraction)$altitude^2)^0.5
}
hlat <-   44+38/60                     # http://www.timeanddate.com/worldclock/city.html?n=286
hlon <- -(63+35/60)                    # http://www.timeanddate.com/worldclock/city.html?n=286
d <- read.table('sunrise.dat', header=FALSE)
tz <- 4 * 3600
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + tz
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + tz + 12 * 3600

data(coastlineWorldFine, package="ocedata")

if (!interactive())
    png("map-with-lines.png", unit="in", width=8, height=10.5, res=200, pointsize=12)
n <- 100
lon <- seq(-180, 180, length.out=n)
lat <- vector(length=n)
t0 <- sunrise[1]
for (i in 1:n) {
    lat[i] <- optimise(elevation, interval=c(-90,90))$minimum
}
plot(coastlineWorldFine, clon=hlon, clat=hlat, span=1500)
points(hlon, hlat, cex=3, lwd=3, col=2)
lines(lon, lat, lwd=2)
t0 <- sunset[1]
for (i in 1:n) {
    ##vlat[i] <- optim(0, above.horizon)$par
    lat[i] <- optimise(elevation, interval=c(-90,90))$minimum
}
lines(lon, lat, lwd=2, lty="dashed")
legend("bottomright", lwd=c(2,2), lty=c("solid", "dashed"),legend=c("Sunrise", "Sunset"))
title(format(t0, "%Y-%b-%d"))

if (!interactive())
    dev.off()

