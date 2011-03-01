library(oce)
png("sunrise_sunset.png", width=800, height=300, pointsize=12)
hfx.sun.angle <- function(t) sun.angle(t, lat=44+39/60, lon=-(63+36/60))$elevation
##d <- read.table("http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet.dat", header=FALSE)
d <- read.table("../skynet-01.dat", header=FALSE)
time <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + 4 * 3600
light <- 100*(1023-d$V3)/1023
oce.plot.ts(time, light, ylab="Light intensity (percent)", ylim=c(0, 100))
lines(time, 50*(light>1), col='gray', lwd=4)
tr <- range(time)
days <- seq(trunc(tr[1], "days"), trunc(tr[2]+86400), "days")
for (day in days) {
    sunrise <- oce.bisect(hfx.sun.angle, day, day + 12 * 3600)
    abline(v=number.as.POSIXct(sunrise), col='red')
    sunset <- oce.bisect(hfx.sun.angle, day + 12*3600, day + 24 * 3600)
    abline(v=number.as.POSIXct(sunset), col='blue')
}
legend("topleft", lwd=c(1, 4, 1, 1), col=c("black", "gray", "red", "blue"),
       legend=c("Observed", "Inferred daytime", "Sunrise", "Sunset"),
       cex=3/4, bg="white")
