library(oce)
year <- 2011
stationID <- 8539
skip <- 17 # CAUTION: may change at any time
pressure <- NULL
time <- NULL
tref <- as.POSIXct("2000-01-01")
for (month in 1:12) {
    url <- sprintf("http://www.climate.weatheroffice.gc.ca/climateData/bulkdata_e.html?StationID=%d&Year=%d1&Month=%d&Day=1&format=csv&type=hly", stationID, year, month)
    cat(url, "\n")
    d <- read.csv(url, skip=skip, header=FALSE, stringsAsFactors=FALSE)
    time <- c(time, as.numeric(as.POSIXct(d$V1)))
    pressure <- c(pressure, d$V19)
}
time <- tref + (time - as.numeric(tref))
var <- paste("station", stationID, sep="")
assign(var, list(time=time, pressure=pressure))
save(list=var, file="~/pressure-halifax.rda")

