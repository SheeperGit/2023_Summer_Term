#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/select.h>

int pipefd[2];
// accessible from both signal handler and main

void myhandler(int sig)
{
  write(pipefd[1], &sig, sizeof(int));
}

int main(void)
{
  fd_set readfds;
  struct sigaction myaction;

  pipe(pipefd);
  myaction.sa_handler = myhandler;
  myaction.sa_flags = SA_RESTART;
  sigfillset(&myaction.sa_mask);
  sigaction(SIGINT, &myaction, NULL);
  sigaction(SIGTERM, &myaction, NULL);
  for (;;) {
    FD_ZERO(&readfds);
    FD_SET(0, &readfds);
    FD_SET(pipefd[0], &readfds);
    printf("calling select\n");
    // Because I installed signal handlers, select can return -1 after handled
    // signals. No worries, just keep calling.
    while (select(pipefd[0]+1, &readfds, NULL, NULL, NULL) == -1) {}
    if (FD_ISSET(0, &readfds)) {
      char line[1024];
      if (fgets(line, 1023, stdin) != NULL) {
        printf("user entered %s\n", line);
      } else {
        printf("user ends, bye!\n");
        break;
      }
    }
    if (FD_ISSET(pipefd[0], &readfds)) {
      int s;
      if (read(pipefd[0], &s, sizeof(int)) != -1) {
        printf("received signal number %d. (No, I am not quitting!)\n", s);
        // Exercise: If s==SIGTERM, quit, but quit with a HOWL!
      }
    }
  }

  return 0;
}
