library(oce)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="../skyview.db")
observations <- dbGetQuery(con, "select time,light_mean from observations")
t <- numberAsPOSIXct(observations$time) # timezone?
light <- 100 * ((1023 - observations$light_mean) / 1023)
now <- as.POSIXct(Sys.time())
look <- (now - 7*86400) < t
png("weather.png", width=900, height=200, pointsize=13)
oce.plot.ts(t[look], light[look], type='l', ylab='Light Intensity (per cent)', ylim=c(0, 100))
load("~/pressure-halifax.rda")
lines(station8539$time, 10 + 5*(station8539$pressure - mean(station8539$pressure,na.rm=TRUE)), col='lightblue', lwd=3)
dev.off()
