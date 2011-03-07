library(oce)
stationID <- 8539
year <- as.POSIXlt(Sys.time())$year+1900
skip <- 17                             # CAUTION: format may change at any time
pressure <- NULL
time <- NULL
tref <- as.POSIXct("2000-01-01")       # arbitrary
this.month <- 1 + as.POSIXlt(Sys.time())$mon
for (month in 1:this.month) {
    url <- sprintf("http://www.climate.weatheroffice.gc.ca/climateData/bulkdata_e.html?StationID=%d&Year=%d&Month=%d&Day=1&format=csv&type=hly", stationID, year, month)
    d <- read.csv(url, skip=skip, header=FALSE, stringsAsFactors=FALSE)
    time <- c(time, as.numeric(as.POSIXct(d$V1)))
    pressure <- c(pressure, d$V19)
    cat(url, "\n    has", sum(!is.na(d$V19)), "non-missing pressure data (first", d$V19[1], ")\n")
}
time <- tref + (time - as.numeric(tref))
var <- paste("station", stationID, sep="")
assign(var, list(time=time, pressure=pressure))
save(list=var, file="~/pressure-halifax.rda")

