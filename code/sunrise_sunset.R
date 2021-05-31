look <- 1:10000 # show only start of time series
library(oce)
library(RSQLite)

if (!interactive()) png("sunrise_sunset.png", width=800, height=300, pointsize=12)

m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="~/Dropbox/skyview.db")
observations <- dbGetQuery(con, "select time,light_mean from observations")
time <- numberAsPOSIXct(observations$time) # timezone?
light <- 100 * ((1023 - observations$light_mean) / 1023)
time <- time[look]
light <- light[look]

lights.on <- light > 75
light[lights.on] <- NA
##par(mfrow=c(2,1))
oce.plot.ts(time, light, ylab="Light intensity (percent)", ylim=c(0, 100), type="l")
dark <- 3
##lines(time, 50*(light>dark), col='darkgray')
tr <- range(time)
days <- seq(trunc(tr[1], "days"), trunc(tr[2]+86400), "days")
n <- length(days)
sunrise <- rep(NA, length=n)
sunset <- rep(NA, length=n)
sunAltitude <- function(t) sunAngle(t, lat=44+39/60, lon=-(63+36/60))$altitude
for (i in seq_along(days)) {
    day <- as.numeric(days[i])
    sunrise[i] <- uniroot(sunAltitude, lower=day, upper=day + 12 * 3600)$root
    sunset[i] <- uniroot(sunAltitude, lower=day + 12*3600, upper=day + 24 * 3600)$root
    abline(v=numberAsPOSIXct(sunrise[i]), col='red')
    abline(v=numberAsPOSIXct(sunset[i]), col='blue')
}
legend("topleft", lwd=c(1, 1, 1), col=c("black", "red", "blue"),
       legend=c("Light", "Sunrise", "Sunset"),
       cex=3/4, bg="white")

## oce.plot.ts(days, (sunset-sunrise)/3600, ylab="Day length [h]", type="o")

if (!interactive()) dev.off()
