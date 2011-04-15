// convert (flat) skyview*.dat file to database file
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sqlite3.h>
#define MONITOR
//#define DEBUG
int main(int argc, char **argv)
{
    sqlite3 *db;
    char *zErrMsg = 0;
    int rc;
    if (argc != 3) {
        fprintf(stderr, "Usage example: %s station_id ~/Sites/skyview/skyview.db\n", argv[0]);
        exit(1);
    }
    int station_id = atoi(argv[1]);
    rc = sqlite3_open(argv[2], &db);
    if (0 != rc) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        exit(1);
    }
    time_t now;
    time(&now);
    double light_mean = 100;
    double light_stddev = 1.0;
    char *sql = sqlite3_malloc(1000); // FIXME: think about the length of this
    sql = sqlite3_mprintf("INSERT INTO observations(time,station_id,light_mean,light_stddev) VALUES(%d,%d,%.0f,%.0f);",
            now, 1, light_mean, light_stddev);
    printf("%s\n", sql);
    rc = sqlite3_exec(db, sql, 0, 0, 0);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        fprintf(stderr, "The command was '%s'\n", sql);
        sqlite3_free(zErrMsg);
        exit(1);
    }
    sqlite3_free(sql);
    sqlite3_close(db);
    return 0;
}
