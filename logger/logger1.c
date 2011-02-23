/* http://en.wikibooks.org/wiki/Serial_Programming:Unix/termios */
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>

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
    int first = 1;
    buf[4] = '\0'; 
    char *atime;
    char timeformatted[70];

    if (argc !=  2) {
        fprintf(stderr, "Usage: %s /dev/ttyS1 (for example)\n", argv[0]);
        exit(1);
    }
    fprintf(stderr, "Type 'q' to quit\n");

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
    tty_fd = open(argv[1], O_RDWR | O_NONBLOCK);      
    cfsetospeed(&tio, B9600);            // baud
    cfsetispeed(&tio, B9600);            // baud
    tcsetattr(tty_fd, TCSANOW, &tio);
    int ic = 0, ia;
    while (c != 'q') {
        if (read(tty_fd, &c, 1) > 0) {
            buf[ic++] = c;
            if (c == '\n') {
                buf[ic] = '\0';
                time(&seconds);
                timeinfo = localtime(&seconds);
                strftime(timeformatted, sizeof(timeformatted)-1, "%Y-%m-%d %H:%M:%S", timeinfo);
                if (first) {
                    first = 0;
                } else {
                    printf("%s %s", timeformatted, buf); // FIXME: out by one time unit
                    fflush(stdout);
                }
                ic = 0;
            }
        }
        usleep(10000);                                // sleep 0.1 seconds
    }
    fprintf(stderr, "Do\n     stty sane\n    to reset your terminal\n");
    close(tty_fd);
}
