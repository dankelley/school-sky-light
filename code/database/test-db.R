library(oce)
if (FALSE) {
    library(RSQLite)
    m <- dbDriver("SQLite")
    con <- dbConnect(m, dbname="01.db")
    dbListTables(con)
    observations <- dbGetQuery(con, "select time,light_mean from observations")
    time <- number.as.POSIXct(observations$time) # timezone?
    light <- 100 * ((1023 - observations$light_mean) / 1023)
} else {
    d  <- read.table("~/Sites/skyview/skyview-01.dat", header=FALSE)
    time <- as.POSIXct(paste(d$V1, d$V2))
    light <- 100 * ((1023 - d$V3) / 1023)
}
oce.plot.ts(time, light)
