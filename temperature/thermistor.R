d <- read.table("thermistor.dat", sep='\t', header=FALSE, skip=2, col.names=c("T.F","T","R"))
plot(d$T, d$R,type='b',xlim=c(20,100),ylim=c(0,5e4), xlab="T [degC]", ylab="Reistance [ohm]")
title("http://www.ussensor.com/rt%20charts/PT103J2.htm")
