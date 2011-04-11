-- sqlite3 skyview.db < create-db.sql
CREATE TABLE observations(
    id integer primary key,
    sensor int, -- used with table 'sensors'
    time varchar(23), -- 2011-04-11 09:51:38 ADT
    light_mean real,
    light_stddev real);
CREATE TABLE sensors(
    id integer primary key, -- use for JOIN with table 'observations'
    latitude real, -- use negative for southern hemisphere
    longitude real, -- use negative for western hemisphere, e.g. Canada
    direction varchar(20), -- 'east', 'west', 'north', 'south', 'northeast', etc
    name varchar(100));

