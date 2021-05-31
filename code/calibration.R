library(oce)
png("calibration-timeseries.png", width=500, height=350, pointsize=12)
## curl http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-01.dat > skynet-01.dat
## curl http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-02.dat > skynet-02.dat
light <- function(count) 100 * (1023 - count) / 1023
d1 <- read.table('../skyview-01.dat', header=FALSE)
d2 <- read.table('../skyview-02.dat', header=FALSE)
t1 <- as.POSIXct(paste(d1$V1, d1$V2))
tlim <- range(t1)
light1 <- light(d1$V3)
t2 <- as.POSIXct(paste(d2$V1, d2$V2))
tlim[1] <- min(tlim[1], min(t2))
tlim[2] <- max(tlim[2], max(t2))
light2 <- light(d2$V3)
oce.plot.ts(t1, light1, xlim=tlim, ylim=c(0,100), main="black: skyview-01; red: skyview-02")
lines(t2, light2, xlim=tlim, ylim=c(0,100), col='red')
lines(t2, light2, col='red')
dev.off()

png("calibration.png", width=400, height=400, pointsize=12)
par(mar=c(3,3,2,2))
light1i <- approx(as.numeric(t1), light1, as.numeric(t2))$y
ok <- !is.na(light1i) & !is.na(light2)
light1i <- light1i[ok]
light2 <- light2[ok]
smoothScatter(light1i, light2, xlab="skyview-01", ylab="skyview-02", asp=1)
m <- lm(light2~light1i + I(light1i^2))
xx <- seq(min(light1i), max(light1i), length.out=100)
lines(xx, predict(m, list(light1i=xx)), col='red', lwd=2)
c <- coef(m)
title(sprintf("s2 = %.0g + %.2g * s1 + %.2g * s1^2", c[1], c[2], c[3]), cex=3/4)

