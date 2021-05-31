library(oce)
deltat <- 60 # seconds between sample (nominal)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="../skyview.db")
observations <- dbGetQuery(con, "select time,light_mean from observations")
time <- numberAsPOSIXct(observations$time) # timezone?
light <- 100 * ((1023 - observations$light_mean) / 1023)

time.g <- seq(trunc(time[1], "day"), 86400 + trunc(time[length(time)], "day"), by=deltat)
light.g <- approx(time, light, time.g, rule=1)$y
## Blank out times when the device was off
light.g[ISOdatetime(2011,7,21,12,15,14,tz="UTC") <= time.g & 
        time.g <= ISOdatetime(2011,8,18,10,00,00,tz="UTC")] <- NA

light.g[as.POSIXct("2012-06-27 18:15:32", tz="UTC") <= time.g &
        time.g <= as.POSIXct("2012-07-03 17:12:28", tz="UTC")] <- NA

time.range <- range(time.g)
days <- floor(0.5 + as.numeric(difftime(time.range[2], time.range[1], "days"))) # round for e.g. daylight-time
data.per.day <- 86400 / deltat
light.m <- matrix(light.g[1:(days*data.per.day)], ncol=data.per.day, byrow=TRUE)
png("weather_image.png", width=900, height=400, pointsize=13)
time.axis <- as.POSIXct(seq.POSIXt(min(time.g), min(time.g)+(days-1)*86400, by="day"))
imagep(time.axis, (1:data.per.day)/60, light.m, xlab="", ylab="Hour",
       zlab="Light Intensity (per cent)", drawContour=FALSE, col=oceColorsJet, drawTimeRange=FALSE)
dev.off()

