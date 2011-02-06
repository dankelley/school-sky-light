library(oce)
D <- 1.0
angle.misfit.1 <- function(x) { # lat
    elevation <- sun.angle(t0, x[1], lon)$elevation
    ## the angle has an ~1deg negative offset when below the horizon
    mean(ifelse(elevation > 0, elevation^2, D + elevation^2))
}
angle.misfit.2 <- function(x) { # lon
    elevation <- sun.angle(t0, lat, x[1])$elevation
    ## the angle has an ~1deg negative offset when below the horizon
    mean(ifelse(elevation > 0, elevation^2, D + elevation^2))
}
angle.misfit <- function(x) { # lat lon
    elevation <- sun.angle(t0, x[1], x[2])$elevation
    ## the angle has an ~1deg negative offset when below the horizon
    mean(ifelse(elevation > 0, elevation^2, D + elevation^2))
}
lat <- 44+38/60
lon <- -(63+35/60)
## http://www.timeanddate.com/worldclock/astronomy.html?n=286
d <- read.table('sunrise.dat', header=FALSE)
sunrise <- as.POSIXct(paste(d$V1, d$V2), tz="UTC") + 4 * 3600
sunset <- as.POSIXct(paste(d$V1, d$V3), tz="UTC") + 4 * 3600 + 12 * 3600
print(sun.angle(sunrise, lat, lon))
mod <- seq(-10, 10, 0.1)
par(mfrow=c(2,1), mar=c(3,3,1,1), mgp=c(3/2,2/3,0))
for (s in 1:length(d$V1)) {
    cat("s=",s,"\n")
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunset[s], lat+m, lon)$elevation)
    plot(lat+mod, elevation, xlab="Latitude", ylab="Elevation", type='l')
    ## optimized fits
    t0 <- sunrise[s]
    latfit <- optim(c(0),angle.misfit.1)$par
    lonfit <- optim(c(0),angle.misfit.2)$par
    grid()
    abline(v=lat, col='blue')
    mtext(format(sunset[s]), adj=1, line=-1)
    mtext("sunset", adj=1, line=-2)
    mtext(paste("actual: ", format(lat, digits=5), "N  ", format(lon,digits=5), "E", sep=""),
          adj=1, line=-3, col='blue')
    mtext(paste("fit:    ", format(latfit, digits=5), "N  ", format(lonfit,digits=5), "E", sep=""),
          adj=1, line=-4, col='red')
    error <- geod.dist(lat, lon, latfit, lonfit)
    mtext(sprintf("Misfit: %.1f km", error), adj=1, line=-5)
    abline(v=latfit, col='red')
    elevation <- NULL
    for (m in mod)
        elevation <- c(elevation, sun.angle(sunset[s], lat, lon+m)$elevation)
    plot(lon+mod, elevation, xlab="Longitude", ylab="Elevation", type='l')
    abline(h=0)
    abline(v=lon, col='blue')
    abline(v=lonfit, col='red')
}

for (t0 in sunrise) print(optim(c(50,0),angle.misfit)$par)
for (t0 in sunset) print(optim(c(50,0),angle.misfit)$par)
t0 <- sunrise[1]; print(optim(c(0,0),angle.misfit)$par)
t0 <- sunset[1];  print(optim(c(0,0),angle.misfit)$par)
warning("performs poorly when trying for both lat and lon\n")

