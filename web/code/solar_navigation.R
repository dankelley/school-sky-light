library(oce)
png("solar_navigation_timeseries.png", width=700, height=250, pointsize=13)
mismatch <- function(latlon) 
{
    ##cat(sprintf("%.2f %.2f\n", latlon[1], latlon[2]))
    0.5 * (mean(sun.angle(rises, latlon[1], latlon[2])$elevation^2) +
           mean(sun.angle(sets, latlon[1], latlon[2])$elevation^2))
}

hfx.sun.angle <- function(t) sun.angle(t, lat=44+39/60, lon=-(63+36/60))$elevation
##d <- read.table("http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-01.dat", header=FALSE)
d <- read.table("../skynet-01.dat", header=FALSE)
time <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + 4 * 3600
light <- (100*(1023-d$V3)/1023)
light.smoothed <- smooth(light)        #kernapply(as.numeric(runmed(light, k=3)), kernel("daniell", 2), circular=TRUE)
oce.plot.ts(time, light.smoothed, ylab="Smoothed light intensity (percent)", ylim=c(0, 100))
dim.light <- ifelse(light.smoothed < 5, light, runif(length(light), 0, 5))
light.floor <- runmed(dim.light, k=25*60+1)
dn <- smooth(as.numeric((light.smoothed - light.floor) > 1))
##lines(time, light.floor, col='blue', lty='dashed')
rises <- time[which(diff(dn) > 0)]
sets <- time[which(diff(dn) < 0)]
## Trim false starts, and then pair up rises and sets
if (rises[1] > sets[1])
    sets <- sets[-1]
nrises <- length(rises)
if (length(sets) < nrises)
    rises <- rises[1:length(sets)]
if (length(sets) > nrises)
    sets <- sets[1:nrises]
nrises <- length(rises)
## Indicate on the graph
rug(rises, col='red', lwd=4)
rug(sets, col='blue', lwd=4)
legend("topleft", lwd=c(1, 1, 1), 
       col=c("black", "red", "blue"),
       legend=c("Observed", "Sunrise", "Sunset"),
       cex=3/4, bg="white")
dev.off()

## map
png("solar_navigation_map.png", width=700, height=300, pointsize=13)
lat.hfx <- 44.65
lon.hfx <- (-63.55274)
par(mfrow=c(1,1))
data(coastline.world)
plot(coastline.world, center=c(lat.hfx, lon.hfx), span=700)
## Find lat and lon using all sunrises and sunsets
o <- optim(c(1,1), mismatch, hessian=TRUE)
lat <- o$par[1]
lon <- o$par[2]
## Indicate the spot on a map, and show the uncertainty
lat.err <- sqrt(o$value / o$hessian[1,1]) / 2
lon.err <- sqrt(o$value / o$hessian[2,2]) / 2
lines(rep(lon, 2), lat + lat.err * c(-1, 1), lwd=3, col='red')
lines(lon + lon.err*c(-1, 1), rep(lat, 2), lwd=3, col='red')
points(lon.hfx, lat.hfx, pch=0, cex=2, col='blue', lwd=2)
points(lon, lat, pch=1, cex=2, col='red', lwd=2)
legend("topright", col=c("blue", "red"), pch=c(0,1), pt.cex=2,
       legend=c("Actual", "Inferred"))
