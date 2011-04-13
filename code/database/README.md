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

## Database performance

### Time

*Trial 1 (datetime type for time)* ``test-db.R`` can use either the flat file
or the database.  The user time to read and plot the database was 7.6s, as
compared with 8.4s for the flat file.  **Conclusion.** the database method is
10 percent better, for speed. (This on a laptop.)

*Trial 2 (integer type for time)* on a desktop, 0.8s for database, 8.5s for
flat file.  On a laptop, 0.9s for database, 9.1s for flat file.
**Conclusion.** the database storage method yields an order-of-magntitude
improvement in time.

### Storage

*Trial 1 (datetime type for time)* The flat file was 2.0M, while the database
was 2.2M.  **Conclusion.** the flat-file method is 10 percent better, for
storage.

*Trial 2 (integer type for time)* Flat file 2.0M, database 1.3M.
