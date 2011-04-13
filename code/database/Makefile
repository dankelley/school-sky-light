test:
	make clean
	sqlite3 skyview.db < create-db.sql
	sqlite3 skyview.db < add-station.sql
	#sqlite3 skyview.db < add-data.sql
	sqlite3 skyview.db ".dump"
	R --slave < test-db.R
	echo "Examine Rplots.pdf"
	
create:
	make clean
	sqlite3 skyview.db < create-db.sql
	sqlite3 skyview.db < add-station.sql
	sqlite3 skyview.db ".dump"
access: access.c
	gcc -o access access.c -lsqlite3
	./access skyview.db 'SELECT * FROM observations'

flat2db: flat2db.c
	gcc -o flat2db -g flat2db.c -lsqlite3
	cp skyview.db 01.db
	./flat2db ~/Sites/skyview/skyview-01.dat 01.db
	
clean:
	-rm skyview.db *~


