library(oce)
if (!interactive())
png("solar_navigation_timeseries.png", width=800, height=300, pointsize=12)

mismatch <- function(latlon) 
{
sun.angle(rise, latlon[1], latlon[2])$elevation^2 + sun.angle(set, latlon[1], latlon[2])$elevation^2
}

hfx.sun.angle <- function(t) sun.angle(t, lat=44+39/60, lon=-(63+36/60))$elevation
d <- read.table("http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-01.dat", header=FALSE)
#d <- read.table("../skynet-01.dat", header=FALSE)
time <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + 4 * 3600
light <- (100*(1023-d$V3)/1023)
## FIXME: The nighttime level changed on March 1 (for reasons unknown), so the 
## FIXME: best 'dark' in the beginning is 1/2, but later it needs to be 3 or so.
## FIXME: We need a runmin() function.  Would that be hard to implement in oce?
dark <- 2
light.smoothed <- supsmu(time, light, span=30/length(light))$y
light.smoothed <- predict(smooth.spline(as.numeric(time)-as.numeric(time[1]), light, df=length(light)/10))$y
light.smoothed <- runmed(light, k=5)
sunrise.inferred <- time[which(diff(light.smoothed > dark) == 1)]
print(sunrise.inferred)
sunset.inferred <- time[which(diff(light.smoothed > dark) == -1)]
print(sunset.inferred)
if (sunrise.inferred[1] > sunset.inferred[1])
sunrise <- sunrise[-1]
ndays <- min(length(sunrise.inferred), length(sunset.inferred))
oce.plot.ts(time, light, ylab="Light intensity (percent)", ylim=c(0, 100))

## Distances
lat.hfx <- 44.65
lon.hfx <- (-63.55274)
lats <- NULL
lons <- NULL
for (day in 1:ndays) {
    rise <- sunrise.inferred[day] + 0*4*3600
    set <- sunset.inferred[day] + 0*4*3600
    result <- optim(c(1,1), mismatch)
    dist <- geod.dist(result$par[1], result$par[2], lat.hfx, lon.hfx)
    lats <- c(lats, result$par[1])
    lons <- c(lons, result$par[2])
    print(dist)
}

tr <- range(time)
days <- seq(trunc(tr[1], "days"), trunc(tr[2]+86400), "days")
days <- days[-1]                       # skip first day, which may be partial
days <- days[-length(days)]            # skip last day, which may be partial
ndays <- length(days)
print(days)
sunrise.inferred <- sunset.inferred <- NULL
lats <- lons <- NULL
for (iday in 1:(ndays-1)) {
    look <- days[iday] <= time & time <= days[iday+1]
    dark <- min(light.smoothed[look])
    dark2 <- median(light.smoothed[look])
    if (iday == 2) {
        dan.dark2<<-dark2
        dan.light<<-light[look]
        dan.light.smoothed<<-light.smoothed[look]
        dan.time<<-time[look]
    }
    diff <- diff(light.smoothed[look] > dark2)
    rise <- time[look][which(diff == 1)][1]
    sunrise.inferred <- c(sunrise.inferred, rise)
    set <- time[look][which(diff == -1)][1]
    sunset.inferred <- c(sunset.inferred, set)
    result <- optim(c(1,1), mismatch)
    lats <- c(lats, result$par[1])
    lons <- c(lons, result$par[2])
    points(result$par[1], result$par[2], col='red')
    dist <- geod.dist(result$par[1], result$par[2], lat.hfx, lon.hfx)
    cat("iday=", iday,
        "sunrise at", format(number.as.POSIXct(sunrise.inferred[iday])),
        "sunset at", format(number.as.POSIXct(sunset.inferred[iday])),
        "(dark=", dark, " dark2=", dark2, ") dist=", dist, "\n")
                                        #    result <- optim(c(1,1), mismatch)
                                        #    sunrise <- oce.bisect(hfx.sun.angle, day, day + 12 * 3600)
                                        #    sunset <- oce.bisect(hfx.sun.angle, day + 12*3600, day + 24 * 3600)
}
sunrise.inferred <- number.as.POSIXct(sunrise.inferred)
sunset.inferred <- number.as.POSIXct(sunset.inferred)
abline(v=sunrise.inferred, col='red')
abline(v=sunset.inferred, col='blue')
legend("topleft", lwd=c(1, 1, 1, 1),
       col=c("black", "red", "red", "blue", "blue"),
       lty=c("solid", "dotted", "solid", "dotted", "solid"),
       legend=c("Observed", "Sunrise [inferred]", "Sunrise [theoretical]", "Sunset [inferred]", "Sunset [theoretical]"),
       cex=3/4, bg="white")
dev.off()

## map
if (!interactive())
    png("solar_navigation_map.png", width=800, height=800, pointsize=12)
par(mfrow=c(1,1))
data(coastline.world)
plot(coastline.world, center=c(lat.hfx, lon.hfx), span=8000)
points(lons, lats, pch=21, cex=2, bg='white', lwd=5)

