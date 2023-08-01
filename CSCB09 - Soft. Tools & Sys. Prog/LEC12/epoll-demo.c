#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/epoll.h>

int pipefd[2];
// accessible from both signal handler and main

void myhandler(int sig)
{
  write(pipefd[1], &sig, sizeof(int));
}

int main(void)
{
  struct sigaction myaction;

  pipe(pipefd);
  myaction.sa_handler = myhandler;
  myaction.sa_flags = SA_RESTART;
  sigfillset(&myaction.sa_mask);
  sigaction(SIGINT, &myaction, NULL);
  sigaction(SIGTERM, &myaction, NULL);

  int ep;
  struct epoll_event e;

  ep = epoll_create1(0);
  e.events = EPOLLIN;
  e.data.fd = 0;
  epoll_ctl(ep, EPOLL_CTL_ADD, 0, &e);
  e.events = EPOLLIN;
  e.data.fd = pipefd[0];
  epoll_ctl(ep, EPOLL_CTL_ADD, pipefd[0], &e);

  for (;;) {
    int i, n;
    struct epoll_event es[2];
    printf("calling epoll_wait\n");
    // Because I installed signal handlers, epoll can return -1 after handled
    // signals. No worries, the inner-loop below will be skipped because n = -1,
    // then the outer loop will try again.
    n = epoll_wait(ep, es, 2, -1);
    for (i = 0; i < n; i++) {
      if (es[i].data.fd == 0) {
        char line[1024];
        if (fgets(line, 1023, stdin) != NULL) {
          printf("user entered %s\n", line);
        } else {
          printf("user ends, bye!\n");
          return 0;
        }
      } else if (es[i].data.fd == pipefd[0]) {
        int s;
        read(pipefd[0], &s, sizeof(int));
        printf("received signal number %d. (No, I am not quitting!)\n", s);
        // Exercise: If s==SIGTERM, quit, but quit with a HOWL!
      }
    }
  }
}
