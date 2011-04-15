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
        fprintf(stderr, "Usage example: %s ~/Sites/skyview/skyview-01.dat ~/Sites/skyview/skyview.db\n", argv[0]);
        exit(1);
    }
    FILE *infile = fopen(argv[1], "r");
    if (0 == infile) {
        fprintf(stderr, "Cannot open input file \"%s\"\n", argv[1]);
        exit(1);
    }
    fprintf(stderr, "Opened flat file: %s\n", argv[1]);
    rc = sqlite3_open(argv[2], &db);
    if (0 != rc) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        exit(1);
    }
    fprintf(stderr, "Opened database: %s\n", argv[2]);
    int year, month, day, hour, minute, second;
    double light_mean, light_stddev;
    char *sql = sqlite3_malloc(1000); // FIXME: think about the length of this
    int line = 0, dots_per_line = 100;
    int max = -1; // set to a positive number to limit the number of data, for testing
    while (8 == fscanf(infile, "%4d-%2d-%2d %2d:%2d:%2d %lf %lf",
                &year, &month, &day, &hour, &minute, &second, &light_mean, &light_stddev)) {
        if (!max--)
            break;
#ifdef MONITOR
        printf(".");
        if (0 ==(++line % dots_per_line))
            printf(" %d\n", line);
#endif
        struct tm t;
        t.tm_year = year - 1900; // year - 1900
        t.tm_mon = month - 1; // month of year (0 - 11)
        t.tm_mday = day;
        t.tm_hour = hour;
        t.tm_min = minute;
        t.tm_sec = second;
        int sec = mktime(&t);
        sql = sqlite3_mprintf("INSERT INTO observations(time,station_id,light_mean,light_stddev) VALUES(%d,%d,%.0f,%.0f);",
                sec, 1, light_mean, light_stddev);
#ifdef DEBUG
        printf("%d-%d-%d %d:%d:%d %f %f   %d\n", year, month, day, hour, minute, second, light_mean, light_stddev, sec);
        printf("%s\n", sql);
#endif
        rc = sqlite3_exec(db, sql, 0, 0, 0);
        if (rc != SQLITE_OK) {
            fprintf(stderr, "SQL error: %s\n", zErrMsg);
            fprintf(stderr, "The command was '%s'\n", sql);
            sqlite3_free(zErrMsg);
            exit(1);
        }
    }
    fprintf(stderr, "\n%d lines of data processed\n", line);
    sqlite3_free(sql);
    sqlite3_close(db);
    return 0;
}
