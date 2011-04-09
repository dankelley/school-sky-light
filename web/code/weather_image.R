library(oce)
deltat <- 60 # seconds between sample (nominal)
d <- read.table('../skynet-01.dat', header=FALSE)
time <- as.POSIXct(paste(d$V1, d$V2))
light  <- 100 * (1023 - d$V3) / 1023
time.g <- seq(trunc(time[1], "day"), 86400 + trunc(time[length(time)], "day"), by=deltat)
light.g <- approx(time, light, time.g, rule=1)$y
time.range <- range(time.g)
days <- floor(0.5 + as.numeric(difftime(time.range[2], time.range[1], "days"))) # round for e.g. daylight-time
data.per.day <- 86400 / deltat
light.m <- matrix(light.g[1:(days*data.per.day)], ncol=data.per.day, byrow=TRUE)
png("weather_image.png", width=900, height=400, pointsize=13)
time.axis <- as.POSIXct(seq.POSIXt(min(time.g), min(time.g)+(days-1)*86400, by="day"))
imagep(time.axis, (1:data.per.day)/60, light.m, xlab="", ylab="Hour",
       zlab="Light Intensity (per cent)", draw.contour=FALSE, col=oce.colors.jet, draw.time.range=FALSE)
dev.off()

