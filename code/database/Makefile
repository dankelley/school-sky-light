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
test_insert: test_insert.c
	gcc -o $@ $< -lsqlite3
	./$@ 1 skyview.db

flat2db: flat2db.c
	gcc -o flat2db -O flat2db.c -lsqlite3
do_flat2db: flat2db force
	sqlite3 ~/Sites/skyview/skyview.db < create-db.sql
	sqlite3 ~/Sites/skyview/skyview.db < add-station.sql
	./flat2db ~/Sites/skyview/skyview-01.dat ~/Sites/skyview/skyview.db
	
clean:
	-rm skyview.db *~
clean_web:
	-rm ~/Sites/skyview/skyview.db

force:
