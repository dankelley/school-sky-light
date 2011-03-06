library(oce)
SKIP <- 17                             # warning: this changes at the whim of the weatheroffice
now <- as.POSIXlt(Sys.Date())
tomorrow <- trunc(now, "days") + 86400

base.url <- "http://www.climate.weatheroffice.gc.ca/climateData/bulkdata_e.html"
last.month.url <- sprintf("%s?StationID=%d&Year=%d&Month=%d&Day=1&format=csv&type=hly",
                          base.url, 8539, now$year+1900, now$mon)
this.month.url <- sprintf("%s?StationID=%d&Year=%d&Month=%d&Day=1&format=csv&type=hly",
                          base.url, 8539, now$year+1900, now$mon+1)
## don't both with the header; it's messed up anyway, and
last.month <- read.csv(last.month.url, skip=SKIP, header=FALSE, stringsAsFactors=FALSE)
this.month <- read.csv(this.month.url, skip=SKIP, header=FALSE, stringsAsFactors=FALSE)
##save(this.month, file="this.month.rda")
##save(last.month, file="last.month.rda")
time <- c(as.POSIXct(last.month$V1), as.POSIXct(this.month$V1))
pressure <- c(last.month$V19, this.month$V19)
missing <- is.na(pressure)
png("pressure.png", width=700, height=300, pointsize=13)
oce.plot.ts(time[!missing],pressure[!missing], ylab="Pressure [kPa]", cex=2/3,xlim=tomorrow + c(-11*86400, 0))
dev.off()

