test:
	make clean
	sqlite3 skyview.db < create-db.sql
	sqlite3 skyview.db < add-station.sql
	sqlite3 skyview.db < add-data.sql
	sqlite3 skyview.db ".dump"
	R --slave < test-db.R
	echo "Examine Rplots.pdf"
clean:
	-rm skyview.db *~


