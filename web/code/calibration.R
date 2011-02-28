library(oce)
png("calibration.png", width=800, height=600, pointsize=14)
## curl http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet.dat > skynet.dat
## curl http://emit.phys.ocean.dal.ca/~kelley/skynet/skynet-02.dat > skynet-02.dat
light <- function(count) 100 * (1023 - count) / 1023
d1 <- read.table('../skynet-01.dat', header=FALSE)
d2 <- read.table('../skynet-02.dat', header=FALSE)
d2 <- d2[-1,] # drop first point, thought to be a startup problem
t1 <- as.POSIXct(paste(d1$V1, d1$V2))
tlim <- range(t1)
light1 <- light(d1$V3)
t2 <- as.POSIXct(paste(d2$V1, d2$V2))
light2 <- light(d2$V3)
par(mfrow=c(2,1))
oce.plot.ts(t1, light1, xlim=tlim, ylim=c(0,100))
lines(t2, light2, xlim=tlim, ylim=c(0,100), col='red')
lines(t2, light2, col='red')
legend("topright", col=c("black", "red"), legend=c("Sensor 1", "Sensor 2"), lwd=1, bg="white")
par(mar=c(3,3,2,2))
light1i <- approx(as.numeric(t1), light1, as.numeric(t2))$y
plot(light1i, light2, xlab="Sensor 1", ylab="Sensor 2")
m <- lm(light2~light1i)
abline(m)
c <- coef(m)
title(sprintf("Sensor2 = %.2g + %.2g Sensor1", c[1], c[2]))

