library(oce)
d <- read.table('../skynet-01.dat', header=FALSE)
time <- as.POSIXct(paste(d$V1, d$V2))
light  <- 100 * (1023 - d$V3) / 1023
time.g <- seq(trunc(time[1], "day"), 86400 + trunc(time[length(time)], "day"), by=60)
light.g <- approx(time, light, time.g, rule=2)$y

days <- floor(length(light.g)/24/60)
data.per.day <- 24 * 60
light.m <- matrix(light.g[1:(days*data.per.day)], ncol=86400/60, byrow=TRUE)
png("weather_image.png", width=700, height=300, pointsize=13)
imagep(1:days, (1:data.per.day)/60, light.m, xlab="Day", ylab="Hour", draw.contour=FALSE, col=oce.colors.jet, axes=FALSE)
axis(2)
usr <- par('usr')
usr[1] <- min(time)
usr[2] <- max(time)
mar <- par('mar')
mar[1] <- 3.3
par(usr=usr, mar=mar)
oce.axis.POSIXct(1, x=time)
dev.off()

