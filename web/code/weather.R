library(oce)
d <- read.table('../skynet-01.dat', header=FALSE)
t <- as.POSIXct(paste(d$V1, d$V2))
light  <- 100 * (1023 - d$V3) / 1023
std <- d$V4
png("plot.png", width=800, height=300, pointsize=12)
oce.plot.ts(t, light, type='l', ylab='Light intensity (per cent)', ylim=c(0, 100))
abline(h=80, col='red')
mtext("Office light", side=4, at=80, col='red')
