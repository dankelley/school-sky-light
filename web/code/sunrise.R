library(oce)
use.refraction <- TRUE
tr <- rises[1]
ts <- sets[1]
o <- optim(c(0, 0),
           function(ll) {
               sunAngle(tr, ll[1], ll[2])$altitude^2 + sunAngle(ts, ll[1], ll[2])$altitude^2
           })
names(o)
lonlat <- NULL
if (!o$convergence) {
    lonlat <- rbind(lonlat, o$par)
}
o$par
o$convergence
elevation <- function(x) { # x is latitude
    mean(sunAngle(t0, lon[i], x[1], use.refraction)$altitude^2)^0.5
}
hlat <-   44+38/60                     # http://www.timeanddate.com/worldclock/city.html?n=286
hlon <- -(63+35/60)                    # http://www.timeanddate.com/worldclock/city.html?n=286
d <- read.table("../../sun/sunrise.dat", header=FALSE)[2,]
dd <- read.csv("rises_sets.csv")
head(dd)
tz <- 4 * 3600
sunrise <- as.POSIXct(dd$rise, tz="UTC") + tz
sunset <- as.POSIXct(dd$sets, tz="UTC") + tz
lonlat <- NULL
for (i in seq_along(sunrise)) {
    tr <- rises[i]
    ts <- sets[i]
    o <- optim(c(0, 0),
               function(ll) {
                   sunAngle(tr, ll[1], ll[2])$altitude^2 + sunAngle(ts, ll[1], ll[2])$altitude^2
               })
    if (!o$convergence) {
        lonlat <- rbind(lonlat, o$par)
    }
}
print(lonlat)

data(coastlineWorldFine, package="ocedata")

if (!interactive())
    png("map-with-lines.png", unit="in", width=8, height=10.5, res=200, pointsize=12)
plot(coastlineWorldFine, clon=hlon, clat=hlat, span=3000)
points(hlon, hlat, cex=3, lwd=3, col=2)
points(lonlat[,1], lonlat[,2])
points(mean(lonlat[,1]), mean(lonlat[,2]), pch=20, col=2)

title(format(t0, "%Y-%b-%d"))

if (!interactive())
    dev.off()

