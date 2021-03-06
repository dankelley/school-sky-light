library(oce)
library(RSQLite)

windowDays <- 20
mismatch <- function(latlon, twilight=5)  # FIXME why does -6 not work?
{
    ##cat(sprintf("%.2f %.2f\n", latlon[1], latlon[2]))
    0.5 * (mean((twilight - sunAngle(rises, latlon[1], latlon[2], useRefraction=TRUE)$altitude)^2) +
           mean((twilight - sunAngle(sets, latlon[1], latlon[2], useRefraction=TRUE)$altitude)^2))
}

hfx.sun.angle <- function(t) sunAngle(t, lat=44+39/60, lon=-(63+36/60), useRefraction=TRUE)$altitude

m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="~/Dropbox/skyview.db")
observations <- dbGetQuery(con, "select time,light_mean from observations")
dbDisconnect(con)
time <- numberAsPOSIXct(observations$time) # timezone?
light <- 100 * ((1023 - observations$light_mean) / 1023)
look <- time > (max(time) - windowDays*86400)
time <- time[look]
light <- light[look]
light.smoothed <- smooth(light)
## kernapply(as.numeric(runmed(light, k=3)), kernel("daniell", 2), circular=TRUE)

if (!interactive())
    png("solar_navigation_1.png", unit="in", width=7, height=5, res=200, pointsize=10)

oce.plot.ts(time, light.smoothed, type='p', cex=1/3, pch=20,
            ylim=c(0, 100), ylab="Smoothed light intensity (percent)")
dim.light <- ifelse(light.smoothed < 5, light, runif(length(light), 0, 5))
light.floor <- runmed(dim.light, k=25*60+1)
dn <- smooth(as.numeric((light.smoothed - light.floor) > 1))
FAC <- 30
N <- 51
abline(h=max(light)/FAC,col=4)
day <- lowpass(light, n=N) > (max(light)/FAC)
rises <- time[diff(as.numeric(day)) > 0]
sets <- time[diff(as.numeric(day)) < 0]
risesOrig <- rises
setsOrig <- sets
if (sets[1] < rises[1])
    sets <- sets[-1]
if (tail(sets,1) < tail(rises,1))
    rises <- rises[-length(rises)]
nrises <- length(rises)
if (length(sets) != length(rises))
    stop("why are rises and sets not of equal length?")

## Indicate on the graph
rug(rises, col='red', ticksize=0.02, lwd=2)
rug(sets, col='blue', ticksize=0.02, lwd=2)
legend("topleft", lwd=c(1, 1, 1),
       col=c("red", "blue"),
       legend=c("Sunrise", "Sunset"),
       cex=3/4, bg="white")

mrise <- mean(rises)
mset <- mean(sets)

write.csv(data.frame(rises=rises,sets=sets), row.names=FALSE, file="rises_sets.csv")

if (!interactive())
    dev.off()

stop()

if (!interactive())
    png("solar_navigation_2.png", unit="in", width=7, height=5, res=200, pointsize=10)
latHfx <- 44.65
lonHfx <- (-63.55274)
par(mfrow=c(1,1))
data(coastlineWorldMedium, package="ocedata")
plot(coastlineWorldMedium, projection="+proj=lcc +lon_0=-63 +lat_0=45 +lat_1=35 +lat_2=55",
     clatitude=latHfx, clongitude=lonHfx, span=3000, col="gray")
## Find lat and lon using all sunrises and sunsets
o <- optim(c(1,1), mismatch, hessian=TRUE)
lon <- o$par[1]
lat <- o$par[2]
## Indicate the spot on a map, and show the uncertainty
latErr <- sqrt(abs(o$value / o$hessian[1,1])) / 2
lonErr <- sqrt(abs(o$value / o$hessian[2,2])) / 2
mapLines(rep(lon, 2), lat + latErr * c(-1, 1), lwd=3, col='red')
mapLines(lon + lonErr*c(-1, 1), rep(lat, 2), lwd=3, col='red')
mapPoints(lonHfx, latHfx, pch=0, cex=2, col='blue', lwd=2)
mapPoints(lon, lat, pch=1, cex=2, col='red', lwd=2)
cat("lon=", lon, "lat=", lat, "distance", geodDist(lonHfx, latHfx, lon, lat), "\n")
legend("bottomright", col=c("blue", "red"), pch=c(0,1), pt.cex=2,
       pt.lwd=3, legend=c("Actual", "Inferred"), bg="white")

if (!interactive())
    dev.off()


## map
if (!interactive())
    png("solar_navigation_3.png", width=700, height=700, pointsize=13)
latHfx <- 44.65
lonHfx <- (-63.55274)
par(mfrow=c(1,1))
data(coastlineWorldMedium, package="ocedata")
plot(coastlineWorldMedium, projection="+proj=lcc +lon_0=-63 +lat_0=45 +lat_1=35 +lat_2=55",
     clatitude=latHfx, clongitude=lonHfx, span=3000, col="gray")
## Find lat and lon using all sunrises and sunsets
o <- optim(c(1,1), mismatch, hessian=TRUE)
lon <- o$par[1]
lat <- o$par[2]
## Indicate the spot on a map, and show the uncertainty
latErr <- sqrt(abs(o$value / o$hessian[1,1])) / 2
lonErr <- sqrt(abs(o$value / o$hessian[2,2])) / 2
mapLines(rep(lon, 2), lat + latErr * c(-1, 1), lwd=3, col='red')
mapLines(lon + lonErr*c(-1, 1), rep(lat, 2), lwd=3, col='red')
mapPoints(lonHfx, latHfx, pch=0, cex=2, col='blue', lwd=2)
mapPoints(lon, lat, pch=1, cex=2, col='red', lwd=2)
cat("lon=", lon, "lat=", lat, "distance", geodDist(lonHfx, latHfx, lon, lat), "\n")
legend("bottomright", col=c("blue", "red"), pch=c(0,1), pt.cex=2,
       pt.lwd=3, legend=c("Actual", "Inferred"), bg="white")
if (!interactive())
    dev.off()

