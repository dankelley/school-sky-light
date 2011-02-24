/* http://en.wikibooks.org/wiki/Serial_Programming:Unix/termios */
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <math.h>

int main(int argc,char** argv)
{
    struct termios tio;
    struct termios stdio;
    int tty_fd;
    fd_set rdset;
    time_t seconds;
    struct tm *timeinfo;

    unsigned char c = 'D';
    unsigned char buf[5];
    buf[4] = '\0'; 
    char timeformatted[70];

    if (argc != 3) {
        fprintf(stderr, "Usage: %s 6 /dev/tty.usbmodem5d11 (e.g. ensembles of 6 data, from named file)\n", argv[0]);
        exit(1);
    }
    int Nx = atoi(argv[1]);

    memset(&stdio, 0, sizeof(stdio));
    stdio.c_iflag = 0;
    stdio.c_oflag = 0;
    stdio.c_cflag = 0;
    stdio.c_lflag = 0;
    stdio.c_cc[VMIN] = 1;
    stdio.c_cc[VTIME] = 0;
    tcsetattr(STDOUT_FILENO, TCSANOW, &stdio);
    tcsetattr(STDOUT_FILENO, TCSAFLUSH, &stdio);
    fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);       // make the reads non-blocking

    memset(&tio,0,sizeof(tio));
    tio.c_iflag = 0;
    tio.c_oflag = 0;
    tio.c_cflag = CS8|CREAD|CLOCAL;           // 8n1, see termios.h for more information
    tio.c_lflag = 0;
    tio.c_cc[VMIN] = 1;
    tio.c_cc[VTIME] = 5;
    tty_fd = open(argv[2], O_RDWR | O_NONBLOCK);      
    cfsetospeed(&tio, B9600);            // baud
    cfsetispeed(&tio, B9600);            // baud
    tcsetattr(tty_fd, TCSANOW, &tio);
    int ic = 0;
    double Sx = 0.0, Sxx = 0.0, xbar, xvar, xstd;
    long double Sseconds = 0.0;
    double dbuf;
    int ix = 0;
    int first = 1;
    while (c != 'q') {
        if (read(tty_fd, &c, 1) > 0) {
            buf[ic++] = c;
            if (c == '\n') {
                buf[ic] = '\0'; // null terminate, so an use atof() below
                if (first) {
                    first = 0; // the first datum may be partial
                } else {
                    time(&seconds);
                    Sseconds += seconds;
                    dbuf = atof(buf);
                    //printf("datum dbuf=%f; seconds=%ld\n", dbuf, seconds);
                    Sx += dbuf;
                    Sxx += dbuf * dbuf;
                    if (++ix == Nx) {
                        seconds = (time_t)floor(Sseconds / Nx);
                        timeinfo = localtime(&seconds);
                        strftime(timeformatted, sizeof(timeformatted)-1, "%Y-%m-%d %H:%M:%S", timeinfo);
                        xbar = Sx / Nx;
                        xvar = (Sxx - Sx * Sx / Nx) / (Nx - 1.0);
                        xstd = sqrt((Sxx - Sx * Sx / Nx) / (Nx - 1.0));
                        //printf("%s %.1lf %.1lf %.1lf seconds=%ld Sx=%.1lf Sxx=%.1lf\n",
                        //        timeformatted, xbar, xvar,xstd,seconds,Sx,Sxx); //std);
                        printf("%s %.1lf %.1lf\n", timeformatted, xbar, xstd);
                        fflush(stdout);
                        ix = 0;
                        Sx = 0.0;
                        Sxx = 0.0;
                        Sseconds = 0.0;
                    }
                }
                ic = 0;
            }
        }
        usleep(10000);                                // sleep 0.1 seconds
    }
    //fprintf(stderr, "Do\n     stty sane\n    to reset your terminal\n");
    close(tty_fd);
}
