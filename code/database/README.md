# Database work

## Should SkyView use a database to store the data?

**Pro.** It may be faster.  It offers ability to stream data from multiple sensors.

**Con.** Dealing with a database is tricker than with a flat file, e.g. it
cannot simply be listed on a screen or in a webpage.

**Decision.** Use a database.

## Working notes

* ``create-db.sql`` creates a database, without populating it

* ``test-db.R`` reads the database in R

* ``add-station.sql`` adds DEK office as a station

