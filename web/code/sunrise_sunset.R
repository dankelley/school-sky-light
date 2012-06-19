library(oce)
png("sunrise_sunset.png", width=800, height=300, pointsize=12)
hfx.sun.angle <- function(t) sun.angle(t, lat=44+39/60, lon=-(63+36/60))$altitude

library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="../skyview.db")
observations <- dbGetQuery(con, "select time,light_mean from observations")
time <- numberAsPOSIXct(observations$time) # timezone?
light <- 100 * ((1023 - observations$light_mean) / 1023)

lights.on <- light > 75
light[lights.on] <- NA
oce.plot.ts(time, light, ylab="Light intensity (percent)", ylim=c(0, 100))
dark <- 3
lines(time, 50*(light>dark), col='gray', lwd=4)
tr <- range(time)
days <- seq(trunc(tr[1], "days"), trunc(tr[2]+86400), "days")
for (day in days) {
    sunrise <- oce.bisect(hfx.sun.angle, day, day + 12 * 3600)
    abline(v=numberAsPOSIXct(sunrise), col='red')
    sunset <- oce.bisect(hfx.sun.angle, day + 12*3600, day + 24 * 3600)
    abline(v=numberAsPOSIXct(sunset), col='blue')
}
legend("topleft", lwd=c(1, 4, 1, 1), col=c("black", "gray", "red", "blue"),
       legend=c("Observed", "Inferred daytime", "Sunrise", "Sunset"),
       cex=3/4, bg="white")
