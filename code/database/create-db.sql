-- sqlite3 skyview.db < create-db.sql
CREATE TABLE observations(
    id integer primary key,
    station_id int, -- used with table 'sensors'
    time datetime, -- 2011-04-11 09:51:38 ADT
    light_mean real,
    light_stddev real);
CREATE TABLE stations(
    id integer primary key, -- use for JOIN with table 'observations'
    latitude real, -- use negative for southern hemisphere
    longitude real, -- use negative for western hemisphere, e.g. Canada
    direction_id int, --enu('north', 'northeast','east','southeast','south','southwest','west','northeast','vertical'),
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

