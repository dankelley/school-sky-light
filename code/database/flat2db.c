#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sqlite3.h>
//2011-02-23 22:14:07 1022.0 0.0
//2011-02-23 22:15:07 1022.0 0.0
static int callback(void *NotUsed, int argc, char **argv, char **azColName){
    int i;
    for(i=0; i<argc; i++){
        printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
    }
    printf("\n");
    return 0;
}

int main(int argc, char **argv)
{
    sqlite3 *db;
    char *zErrMsg = 0;
    int rc;
    if( argc!=3 ){
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
    int max = 10;
    while (8 == fscanf(infile, "%4d-%2d-%2d %2d:%2d:%2d %lf %lf",
                &year, &month, &day, &hour, &minute, &second, &light_mean, &light_stddev)) {
        if (!max--)
            break;
        fprintf(stderr, ".");
        if (0 ==(++line % dots_per_line)) {
            fprintf(stderr, " %d\n", line);
        }
        printf("%d-%d-%d %d:%d:%d %f %f\n", year, month, day, hour, minute, second, light_mean, light_stddev);
        struct tm* time;
        time->tm_year = year - 1900;
        time->tm_mon = month;
        time->tm_mday = day;
        time->tm_hour = hour;
        time->tm_min = minute;
        time->tm_sec = second;
        fprintf(stderr, "  CHECK %s\n", asctime(time));
        sql = sqlite3_mprintf(
                "INSERT INTO observations(time,station_id,light_mean,light_stddev) VALUES(\"%4d-%02d-%02d %02d:%02d:%02d\",%d,%.0f,%.0f);",
                year, month, day, hour, minute, second, 1, light_mean, light_stddev);
        //printf("%s\n", sql);
        sqlite3_exec(db, sql, 0, 0, 0);
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
