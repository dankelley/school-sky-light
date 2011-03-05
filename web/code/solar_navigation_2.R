library(oce)
if (!interactive())
    png("solar_navigation_timeseries.png", width=800, height=300, pointsize=12)
mismatch <- function(latlon) 
{
    sun.angle(rise, latlon[1], latlon[2])$elevation^2 +
    sun.angle(set, latlon[1], latlon[2])$elevation^2
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
## Trim false starts
if (rises[1] > sets[1])
    sets <- sets[-1]
## Only consider 'rises' and 'sets' in pairs
nrises <- length(rises)
if (length(sets) < nrises)
    rises <- rises[1:length(sets)]
if (length(sets) > nrises)
    sets <- sets[1:nrises]
nrises <- length(rises)
rug(rises, col='red', lwd=4)
rug(sets, col='blue', lwd=4)
## Distances
lat.hfx <- 44.65
lon.hfx <- (-63.55274)
lats <- NULL
lons <- NULL
for (i in 1:nrises) {
    rise <- rises[i] + 0*4*3600
    set <- sets[i] + 0*4*3600
    result <- optim(c(1,1), mismatch)
    dist <- geod.dist(result$par[1], result$par[2], lat.hfx, lon.hfx)
    lats <- c(lats, result$par[1])
    lons <- c(lons, result$par[2])
    cat(i, nrises, format(rise), format(set), dist, "\n")
}

legend("topleft", lwd=c(1, 1, 1, 1), 
       col=c("black", "blue", "red", "blue"),
       lty=c("solid", "dashed", "solid", "solid"),
       legend=c("Observed", "Dark level", "Sunrise", "Sunset"),
       cex=3/4, bg="white")
dev.off()

## map
if (!interactive())
    png("solar_navigation_map.png", width=800, height=600, pointsize=12)
par(mfrow=c(1,1))
data(coastline.world)
plot(coastline.world, center=c(lat.hfx, lon.hfx), span=3000)
points(lons, lats, pch=21, cex=2, bg='white', col='blue', lwd=5)
set <- mean(sets)
rise <- mean(rises)
overall <- optim(c(1,1), mismatch)$par
points(overall[2], overall[1], cex=4, bg="white", col='red', lwd=5)

