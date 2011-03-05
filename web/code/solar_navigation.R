library(oce)
png("solar_navigation_timeseries.png", width=800, height=300, pointsize=12)
mismatch <- function(latlon) 
{
    ##cat(sprintf("%.2f %.2f\n", latlon[1], latlon[2]))
    sum(sun.angle(rises, latlon[1], latlon[2])$elevation^2) +
    sum(sun.angle(sets, latlon[1], latlon[2])$elevation^2)
}

hfx.sun.angle <- function(t) sun.angle(t, lat=44+39/60, lon=-(63+36/60))$elevation
d <- read.table("http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-01.dat", header=FALSE)
##d <- read.table("../skynet-01.dat", header=FALSE)
time <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + 4 * 3600
light <- (100*(1023-d$V3)/1023)
oce.plot.ts(time, light, ylab="Light intensity (percent)", ylim=c(0, 100))
light.smoothed <- kernapply(light, kernel("daniell", 3), circular=TRUE)
dim.light <- ifelse(light.smoothed < 5, light, runif(length(light), 0, 5))
light.floor <- runmed(dim.light, k=25*60+1)
dn <- smooth(as.numeric((light.smoothed - light.floor) > 1))
lines(time, light.floor, col='blue', lty='dashed')
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
legend("topleft", lwd=c(1, 1, 1, 1), 
       col=c("black", "blue", "red", "blue"),
       lty=c("solid", "dashed", "solid", "solid"),
       legend=c("Observed", "Dark level", "Sunrise", "Sunset"),
       cex=3/4, bg="white")
dev.off()

## map
png("solar_navigation_map.png", width=500, height=300, pointsize=12)
lat.hfx <- 44.65
lon.hfx <- (-63.55274)
par(mfrow=c(1,1))
data(coastline.world)
plot(coastline.world, center=c(lat.hfx, lon.hfx), span=1000)
## Find lat and lon using all sunrises and sunsets
o <- optim(c(1,1), mismatch, hessian=TRUE)
lat <- o$par[1]
lon <- o$par[2]
## Indicate the spot on a map, and show the uncertainty
lat.err <- sqrt(o$value / o$hessian[1,1]) / 2
lon.err <- sqrt(o$value / o$hessian[2,2]) / 2
lines(rep(lon, 2), lat + lat.err * c(-1, 1), lwd=3, col='red', lty='dotted')
lines(lon + lon.err*c(-1, 1), rep(lat, 2), lwd=3, col='red', lty='dotted')
points(lon.hfx, lat.hfx, pch=20, cex=3, col='blue')
points(lon, lat, pch=19, cex=3, col='red')
legend("topright", col=c("blue", "red"), pch=20, pt.cex=3, legend=c("Actual", "Inferred"))
