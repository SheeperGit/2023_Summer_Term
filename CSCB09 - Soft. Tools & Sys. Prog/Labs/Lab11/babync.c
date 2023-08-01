#include <errno.h>
#include <netdb.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

void parse_inaddr(struct addrinfo *ai, const char *hostname, const char *port) {
  struct addrinfo hint;
  struct addrinfo *head;

  memset(&hint, 0, sizeof(struct addrinfo));
  hint.ai_family = AF_INET;
  hint.ai_socktype = SOCK_STREAM;
  hint.ai_protocol = 0;
  hint.ai_flags = AI_NUMERICSERV;

  int r = getaddrinfo(hostname, port, &hint, &head);
  if (r != 0) {
    if (r == EAI_SYSTEM) {
      perror("getaddrinfo");
    } else {
      fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(r));
    }
    exit(1);
  } else {
    *ai = *head;
    ai->ai_next = NULL;
    freeaddrinfo(head);
  }
}

int main(int argc, char **argv)
{
  if (argc < 3) {
    fprintf(stderr, "Need IPv4 address and port.\n");
    return 1;
  }

  struct addrinfo ai;
  parse_inaddr(&ai, argv[1], argv[2]);

  int s = socket(ai.ai_family, ai.ai_socktype, ai.ai_protocol);
  if (-1 == connect(s, ai.ai_addr, ai.ai_addrlen)) {
    perror("connect");
    return 1;
  }

  // TODO: A select() loop to copy stdin to socket (s), copy socket to stdout.
  // Do not exit until both stdin and socket are EOF.
  // Do not monitor an FD for reading if it reached EOF in the past, lest you
  // would cause busy-polling. (Why?)

  // Set up variables for select() loop
  fd_set read_fds, write_fds;
  FD_ZERO(&read_fds);
  FD_ZERO(&write_fds);

  int maxfd = s > 0 ? s : 0;

  FILE *stdin_fp = fdopen(STDIN_FILENO, "r");
  FILE *stdout_fp = fdopen(STDOUT_FILENO, "w");

  for (;;) {
    FD_SET(STDIN_FILENO, &read_fds);
    FD_SET(s, &read_fds);

    // Select the appropriate FDs based on previous EOF status
    if (!feof(stdin_fp)) {
      FD_SET(STDIN_FILENO, &write_fds);
    }

    if (!feof(stdout_fp)) {
      FD_SET(s, &write_fds);
    }

    int ret = select(maxfd + 1, &read_fds, NULL, NULL, NULL);

    if (ret == -1) {
      perror("select");
      break;
    } 

    if (FD_ISSET(STDIN_FILENO, &read_fds)) {
      // Data available to read from stdin, write it to the socket
      char buffer[1024];
      ssize_t bytes_read = read(STDIN_FILENO, buffer, sizeof(buffer));
      if (bytes_read <= 0) {
        // Either EOF or an error occurred, so stop monitoring stdin for reading
        FD_CLR(STDIN_FILENO, &read_fds);
      } else {
        ssize_t bytes_written = write(s, buffer, bytes_read);
        if (bytes_written == -1) {
          perror("write to socket");
          close(s);
          return 1;
        }
      }
    }

    if (FD_ISSET(s, &read_fds)) {
      // Data available to read from the socket, write it to stdout
      char buffer[1024];
      ssize_t bytes_read = read(s, buffer, sizeof(buffer));
      if (bytes_read <= 0) {
        // Either EOF or an error occurred, so stop monitoring the socket for reading
        FD_CLR(s, &read_fds);
      } else {
        ssize_t bytes_written = write(STDOUT_FILENO, buffer, bytes_read);
        if (bytes_written == -1) {
          perror("write to stdout");
          close(s);
          return 1;
        }
      }
    }
  }

  close(s);
  return 0;
}