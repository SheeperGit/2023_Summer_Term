#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#include <signal.h>

#define MY_PORT 31337

void print_client_address(const char *prefix, const struct sockaddr_in *ptr)
{
  char dot_notation[INET_ADDRSTRLEN];
  inet_ntop(AF_INET, &ptr->sin_addr, dot_notation, INET_ADDRSTRLEN);
  printf("%s: %s port %d\n", prefix, dot_notation, ntohs(ptr->sin_port));
}

void ignore_sigpipe(void)
{
  struct sigaction myaction;

  myaction.sa_handler = SIG_IGN;
  sigaction(SIGPIPE, &myaction, NULL);
}

int main(void)
{
  int sfd;
  struct sockaddr_in a;

  // Bad clients can close before we write. Ignore SIGPIPE to keep running.
  ignore_sigpipe();

  sfd = socket(AF_INET, SOCK_STREAM, 0);

  memset(&a, 0, sizeof(struct sockaddr_in));
  a.sin_family = AF_INET;
  a.sin_port = htons(MY_PORT);
  a.sin_addr.s_addr = htonl(INADDR_ANY);
  if (-1 == bind(sfd, (struct sockaddr *)&a, sizeof(struct sockaddr_in))) {
    perror("bind");
    return 1;
  }

  if (-1 == listen(sfd, 2)) {
    perror("listen");
    return 1;
  }

  for (;;) {
    int cfd, n;
    struct sockaddr_in ca;
    socklen_t sinlen;
    char x;

    sinlen = sizeof(struct sockaddr_in);
    cfd = accept(sfd, (struct sockaddr *)&ca, &sinlen);
    print_client_address("Got client", &ca);
    // Bad clients can close before we read, always check return value.
    if (read(cfd, &x, 1) == 1) {    // (*)
      x++;
      write(cfd, &x, 1);            // (**)
      // If bad client closes before we write, and we ignore SIGPIPE, then write
      // returns -1, errno == EPIPE. This toy program doesn't need to know, but
      // real programs check this and react.
    }
    close(cfd);
  }

  // Note: This server is still naive. At (*), if client decides to chill out
  // and not write, server stuck waiting, unresponsive to other clients.
  //
  // True of (**) too if server writes large chunk, larger than kernel buffer,
  // and network or client too slow. Recall "write" blocks when kernel buffer
  // full.
  //
  // Solution is the topic of I/O multiplexing.
}
