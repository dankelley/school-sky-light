library(oce)
png("calibration.png", width=800, height=800, pointsize=14)
## curl http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-01.dat > skynet-01.dat
## curl http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-02.dat > skynet-02.dat
light <- function(count) 100 * (1023 - count) / 1023
d1 <- read.table('../skynet-01.dat', header=FALSE)
d2 <- read.table('../skynet-02.dat', header=FALSE)
t1 <- as.POSIXct(paste(d1$V1, d1$V2))
tlim <- range(t1)
light1 <- light(d1$V3)
t2 <- as.POSIXct(paste(d2$V1, d2$V2))
tlim[1] <- min(tlim[1], min(t2))
tlim[2] <- max(tlim[2], max(t2))
light2 <- light(d2$V3)
par(mfrow=c(2,1))
oce.plot.ts(t1, light1, xlim=tlim, ylim=c(0,100), main="black: skynet-01; red: skynet-01")
lines(t2, light2, xlim=tlim, ylim=c(0,100), col='red')
lines(t2, light2, col='red')
##legend("topright", col=c("black", "red"), legend=c("Sensor 1", "Sensor 2"), lwd=1, bg="white")
par(mar=c(3,3,2,2))
light1i <- approx(as.numeric(t1), light1, as.numeric(t2))$y
ok <- !is.na(light1i) & !is.na(light2)
light1i <- light1i[ok]
light2 <- light2[ok]
plot(light1i, light2, xlab="Sensor 1", ylab="Sensor 2")
m <- lm(light2~light1i + I(light1i^2))
xx <- seq(min(light1i), max(light1i), length.out=100)
lines(xx, predict(m, list(light1i=xx)), col='blue', lwd=2)
c <- coef(m)
title(sprintf("Sensor2 = %.3g + %.3g * Sensor1 + %.3g * Sensor1^2", c[1], c[2], c[3]))

