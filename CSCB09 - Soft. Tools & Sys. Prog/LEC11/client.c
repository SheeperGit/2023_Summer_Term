#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define MY_PORT 31337

int main(int argc, char **argv)
{
  if (argc < 2) {
    fprintf(stderr, "Need server IPv4 address.\n");
    return 1;
  }

  int cfd;
  struct sockaddr_in a;

  memset(&a, 0, sizeof(struct sockaddr_in));
  a.sin_family = AF_INET;
  a.sin_port = htons(MY_PORT);
  if (0 == inet_pton(AF_INET, argv[1], &a.sin_addr)) {
    fprintf(stderr, "That's not an IPv4 address.\n");
    return 1;
  }

  cfd = socket(AF_INET, SOCK_STREAM, 0);

  if (-1 == connect(cfd, (struct sockaddr *)&a, sizeof(struct sockaddr_in))) {
    perror("connect");
    return 1;
  }

  char x = 65, y;
  printf("I'm sending one byte value %d to the server.\n", x);
  write(cfd, &x, 1);
  printf("Reading one byte value from server.\n");
  read(cfd, &y, 1);
  printf("Received: %d.\n", y);
  printf("Bye!\n");

  close(cfd);
  return 0;
}
