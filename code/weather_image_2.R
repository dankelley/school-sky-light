library(oce)
d <- read.table('../skyview-01.dat', header=FALSE)
time <- as.POSIXct(paste(d$V1, d$V2))
light  <- 100 * (1023 - d$V3) / 1023
time.g <- seq(trunc(time[1], "day"), 86400 + trunc(time[length(time)], "day"), by=60)
light.g <- approx(time, light, time.g, rule=1)$y
days <- floor(length(light.g)/24/60)
data.per.day <- 24 * 60
light.m <- matrix(light.g[1:(days*data.per.day)], ncol=86400/60, byrow=TRUE)
png("weather_image_2.png", width=1000, height=1000, pointsize=24)
time.axis <- as.POSIXct(seq.POSIXt(min(time.g), min(time.g)+(days-1)*86400, by="day"))
imagep(time.axis, (1:data.per.day)/60, light.m, xlab="", ylab="Hour",
       zlab="Light Intensity (per cent)", drawContour=FALSE, col=oceColorsJet, draw.time.range=FALSE)
dev.off()

