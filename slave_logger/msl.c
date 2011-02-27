#define arg_eg "10 60 /dev/tty.usbmodem3a21 /Users/kelley/Sites/skynet/skynet-02.dat"
#define debug 0
// debug=0 for no debugging
// debug=1 for moderate debugging, e.g. showing data before statistical reduction
// debug=2 for high debugging, e.g. showing handshaking with device

/* http://en.wikibooks.org/wiki/Serial_Programming:Unix/termios */
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <math.h>
#define NBUF 128

int main(int argc,char** argv)
{
    struct termios tio;
    int tty_fd;
    fd_set rdset;
    time_t seconds;
    struct tm *timeinfo;

    unsigned char c = 'D';
    char buf[NBUF];
    buf[NBUF - 1] = '\0'; 
    char timeformatted[70];

    if (argc != 5) {
        fprintf(stderr, "Usage example: %s %s\n", argv[0], arg_eg);
        exit(1);
    }
    double samplingInterval = atof(argv[1]);
    double reportingInterval = atof(argv[2]);
    char *inFile = argv[3];
    char *outFile = argv[4];
    if (debug != 0)
        fprintf(stderr, "SET UP:\n  sampling every %f s\n  reporting every %f s\n  data from '%s'\n  results to '%s'\n",
                samplingInterval, reportingInterval, inFile, outFile);
    int Nx = (int)floor(0.5 + reportingInterval / samplingInterval);
    if (abs(reportingInterval - Nx * samplingInterval) > 0.001 * reportingInterval) {
        fprintf(stderr, "Must have reportingInterval an integral multiple of samplingInterval\n");
        exit(1);
    }
    FILE *outFile_fp = fopen(outFile, "a");
    if (outFile_fp == NULL) {
        fprintf(stderr, "Cannot open output file '%s' for appending\n", outFile);
        exit(1);
    }
    //
    // set up for serial reading
    memset(&tio, 0, sizeof(tio));
    tio.c_iflag = 0;
    tio.c_oflag = 0;
    tio.c_cflag = CS8|CREAD|CLOCAL;           // 8n1, see termios.h for more information
    tio.c_lflag = 0;
    tio.c_cc[VMIN] = 1;
    tio.c_cc[VTIME] = 5;
    tty_fd = open(inFile, O_RDWR | O_NONBLOCK);      
    cfsetospeed(&tio, B9600);            // baud
    cfsetispeed(&tio, B9600);            // baud
    tcsetattr(tty_fd, TCSANOW, &tio);
    int ic = 0;
    double Sx = 0.0, Sxx = 0.0, xbar, xvar, xstd;
    long double Sseconds = 0.0;
    double dbuf;
    int ix = 0;
    int first = 1;
    char prompt = '>';
    int write_status;
    while (1) {
        write_status = write(tty_fd, &prompt, sizeof(prompt));
        if (write_status != sizeof(prompt)) {
            fprintf(stderr, "problem writing prompt to serial device\n");
            exit(1);
        }
        while (1) {
            usleep(1000); // sleep 1 millisecond between reading characters
            if (read(tty_fd, &c, 1) > 0) {
                if (debug >= 2)
                    fprintf(stderr, "c='%c'   ic=%d\n", c, ic);
                buf[ic++] = c;
                if (c == '\n') {
                    buf[ic] = '\0'; // null terminate, so an use atof() below
                    if (first) {
                        first = 0; // first line may be partial, or 'READY\n', so we skip it
                        if (debug >= 2)
                            fprintf(stderr, "skipping the above\n");
                        ix = 0;
                    } else {
                        if (debug >= 2)
                            fprintf(stderr, "data...?\n");
                        time(&seconds);
                        Sseconds += seconds;
                        dbuf = atof(buf);
                        if (debug > 0)
                            fprintf(stderr, "%ld %.2f\n", seconds, dbuf);
                        usleep(samplingInterval * 1000000);
                        Sx += dbuf;
                        Sxx += dbuf * dbuf;
                        if (++ix == Nx) {
                            seconds = (time_t)floor(Sseconds / Nx);
                            timeinfo = localtime(&seconds);
                            strftime(timeformatted, sizeof(timeformatted)-1, "%Y-%m-%d %H:%M:%S", timeinfo);
                            xbar = Sx / Nx;
                            xvar = (Sxx - Sx * Sx / Nx) / (Nx - 1.0);
                            xstd = sqrt((Sxx - Sx * Sx / Nx) / (Nx - 1.0));
                            if (debug >= 2) 
                                fprintf(stderr, "%s %.1lf %.1lf %.1lf seconds=%ld Sx=%.1lf Sxx=%.1lf\n",
                                        timeformatted, xbar, xvar, xstd,seconds,Sx,Sxx); //std);
                            if (debug >= 1)
                                fprintf(stderr, "%ld %.0f %.0f %s\n",
                                        seconds, xbar, xstd, timeformatted);
                            fprintf(outFile_fp, "%s %.1lf %.1lf\n", timeformatted, xbar, xstd);
                            fflush(outFile_fp);
                            ix = 0;
                            Sx = 0.0;
                            Sxx = 0.0;
                            Sseconds = 0.0;
                        }
                    }
                    write_status = write(tty_fd, &prompt, sizeof(prompt));
                    if (write_status != sizeof(prompt)) {
                        fprintf(stderr, "problem writing prompt to serial device\n");
                        exit(1);
                    }
                    ic = 0;
                }
                if (ic > NBUF - 1)
                    ic = NBUF;
            }
        }
    }
    close(tty_fd);
}
