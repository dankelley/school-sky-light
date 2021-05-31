library(oce)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="../skyview.db")
observations <- dbGetQuery(con, "select time,light_mean from observations")
t <- numberAsPOSIXct(observations$time) # timezone?
light <- 100 * ((1023 - observations$light_mean) / 1023)
now <- as.POSIXct(Sys.time())
days <- 30
look <- (now - days*86400) < t
dt <- diff(as.numeric(t))
gap <- c(FALSE, dt > 10 * mean(dt))
t[gap] <- NA
light[gap] <- NA
if (!interactive())
    png("weather.png", width=900, height=200, pointsize=13)
oce.plot.ts(t[look], light[look], type='l',
            mar=c(2,3.5,2,3.5),
            axes=FALSE,
            xlab="", ylab='Light Intensity (per cent)', ylim=c(0, 100))
box()
oce.axis.POSIXct(1)
axis(2)
load("~/pressure-halifax.rda")
par(new=TRUE, mgp=c(2,0.7,0))
ta <- station6358$time
pa <- station6358$pressure
looka <- (now - days*86400) < ta
##cat("max(ta)=", format(max(ta)), "\n")
plot(ta[looka], pa[looka], ylab="", xlab="", axes=FALSE, type='l', col='blue', xlim=par('usr')[1:2])
##cat("max(ta[looka])=", format(max(ta[looka])), "\n")
axis(4, col.axis='blue', col.lab='blue')
mtext("Pressure [kPa]", line=2, side=4, col='blue')
if (!interactive())
    dev.off()
