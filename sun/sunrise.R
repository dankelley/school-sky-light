##http://www.timeanddate.com/worldclock/astronomy.html?n=286&month=2&year=2011&obj=sun&afl=-11&day=1
library(oce)
use.refraction <- TRUE
elevation <- function(x) { # given longitude
    mean(sunAngle(t0, x[1], lon[i], use.refraction)$elevation^2)^0.5
}
hlat <-   44+38/60                     # http://www.timeanddate.com/worldclock/city.html?n=286
hlon <- -(63+35/60)                    # http://www.timeanddate.com/worldclock/city.html?n=286
d <- read.table('sunrise.dat', header=FALSE)
tz <- 4 * 3600
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + tz
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + tz + 12 * 3600
print(data.frame(sunrise,sunset))

data(coastline.world)

pdf("map-with-lines.pdf", width=8, height=10.5, pointsize=12)
n <- 100
lon <- seq(-180, 180, length.out=n)
lat <- vector(length=n)
t0 <- sunrise[1]
for (i in 1:n) {
    lat[i] <- optimise(elevation, interval=c(-90,90))$minimum
}
plot(coastline.world, center=c(hlat, hlon), span=1500)
abline(h=hlat, v=hlon, col='gray')
lines(lon, lat, lwd=2)
t0 <- sunset[1]
for (i in 1:n) {
    ##vlat[i] <- optim(0, above.horizon)$par
    lat[i] <- optimise(elevation, interval=c(-90,90))$minimum
}
lines(lon, lat, lwd=2, lty="dashed")
legend("bottomright", lwd=c(2,2), lty=c("solid", "dashed"),legend=c("Sunrise", "Sunset"))
title(format(t0, "%Y-%b-%d"))
dev.off()

