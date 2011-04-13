-- sqlite3 skyview.db < create-db.sql
CREATE TABLE observations(
    id integer primary key,
    station_id int,
    time int,
    light_mean real,
    light_stddev real);
CREATE TABLE stations(
    id integer primary key,
    latitude real, -- negative for southern hemisphere
    longitude real, -- negative for western hemisphere, e.g. Canada
    direction_id int,
    name varchar(100));
CREATE TABLE directions(
    id integer primary key,
    heading varchar(20));
INSERT INTO directions (heading) VALUES ("north");
INSERT INTO directions (heading) VALUES ("northeast");
INSERT INTO directions (heading) VALUES ("east");
INSERT INTO directions (heading) VALUES ("southeast");
INSERT INTO directions (heading) VALUES ("south");
INSERT INTO directions (heading) VALUES ("southwest");
INSERT INTO directions (heading) VALUES ("west");
INSERT INTO directions (heading) VALUES ("northwest");
INSERT INTO directions (heading) VALUES ("omnidirectional");

