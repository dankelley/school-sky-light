library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="skyview.db")
dbListTables(con)
dbGetQuery(con, "select * from observations")

