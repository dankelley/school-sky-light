library(oce)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="../skyview.db")
observations <- dbGetQuery(con, "select time,light_mean from observations")
## FIXME: check timezone
time <- numberAsPOSIXct(observations$time)
light <- 100 * ((1023 - observations$light_mean) / 1023)
t <- as.POSIXlt(time)
hourLocal <- t$hour
rt <- range(t)
days <- round(as.numeric(difftime(rt[2],rt[1],"days")))
hour <- t$hour + t$min / 60
light.scale <- 1 * max(light)
r <- 1 + light / light.scale
x <- r * sin(2*pi*(hour-12)/24)
y <- r * cos(2*pi*(hour-12)/24)
if (!interactive())
    png("light_clock.png", width=500, height=500, pointsize=14)
par(mar=c(1,1,1,1))
drawPalette(c(1,days), zlab="Day of sampling", col=oceColorsJet, mai=c(1, 0, 1, 1.5))
col <- oceColorsJet(100)[rescale(as.numeric(time), rlow=1, rhigh=100)]
plot(x,y,asp=1,cex=1/3,axes=FALSE, xlab="", ylab="", col=col)
ignore <- hourLocal > 5 & (light > 4.0 * hourLocal)
points(x[ignore], y[ignore], col='white', cex=0.9*1/3)
h <- seq(0, 23, 0.1) - 12
xc <- sin(2*pi*h/24)
yc <- cos(2*pi*h/24)
lines(xc, yc)
h <- seq(0, 23, 1) - 12
xc <- sin(2*pi*(h-12)/24)
yc <- cos(2*pi*(h-12)/24)
xcc <- .9*xc
ycc <- .9*yc
segments(xc, yc, xcc, ycc)
xcc <- .8*sin(2*pi*h/24)
ycc <- .8*cos(2*pi*h/24)
text(xcc, ycc, seq(0,23,1))
text(0, 0, "site: skyview-01\ncolor: time in series\nhour: UTC")
