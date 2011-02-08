##http://www.timeanddate.com/worldclock/astronomy.html?n=286&month=2&year=2011&obj=sun&afl=-11&day=1
library(oce)
use.refraction <- TRUE
above.horizon <- function(x) { # given longitude
    elevation <- sun.angle(t0, x[1], lon, use.refraction)$elevation
    mean(elevation^2)^0.5
}
hlat <-   44+38/60                     # http://www.timeanddate.com/worldclock/city.html?n=286
hlon <- -(63+35/60)                    # http://www.timeanddate.com/worldclock/city.html?n=286
lat <- hlat
lon <- hlon
d <- read.table('sunrise.dat', header=FALSE)
tz <- 4 * 3600
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + tz
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + tz + 12 * 3600
print(data.frame(sunrise,sunset))

data(coastline.world)

pdf("map-with-lines.pdf", width=8, height=10.5, pointsize=12)
n <- 100
vlon <- seq(-180, 180, length.out=n)
vlat <- vector(length=n)
t0 <- sunrise[1]
for (i in 1:length(vlon)) {
    vlat[i] <- optimise(above.horizon, interval=c(-90,90))$minimum
}
plot(coastline.world, center=c(hlat, hlon), span=1500)
abline(h=hlat, v=hlon, col='gray')
lines(vlon, vlat, lwd=2)
t0 <- sunset[1]
for (i in 1:length(vlon)) {
    ##vlat[i] <- optim(0, above.horizon)$par
    vlat[i] <- optimise(elevation, interval=c(-90,90))$minimum
}
lines(vlon, vlat, lwd=2, lty="dashed")
legend("bottomright", lwd=c(2,2), lty=c("solid", "dashed"),legend=c("Sunrise", "Sunset"))
title(format(t0, "%Y-%b-%d"))
dev.off()

