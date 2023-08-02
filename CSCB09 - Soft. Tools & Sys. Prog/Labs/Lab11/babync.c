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

#define MAX_BUFFER_SIZE 1024

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
  fd_set readfds;
  int stdineof = 0;
  int sockeof = 0;

  for(;;){
    // Close if done reading and sock is done processing //
    if(stdineof && sockeof) {
      break;
    }

    FD_ZERO(&readfds);

    if(!stdineof){
      FD_SET(0, &readfds);
    }
    if(!sockeof){
      FD_SET(s, &readfds);
    } 

    int res = select(s+1, &readfds, NULL, NULL, NULL);

    if(res < 0){
      perror("Error with select");
      exit(EXIT_FAILURE);
    }

    if(FD_ISSET(STDIN_FILENO, &readfds)){
      char stdin_buffer[MAX_BUFFER_SIZE];
      int r = read(STDIN_FILENO, stdin_buffer, MAX_BUFFER_SIZE);
      if(r == 0){
        stdineof = 1;
      }else if(r < 0){
        perror("Read Error");
        exit(EXIT_FAILURE);
      }else{
        write(s, stdin_buffer, r);
      }
    }

    if(FD_ISSET(s, &readfds)){
      char stdin_buffer[MAX_BUFFER_SIZE];
      int r = read(s, stdin_buffer, MAX_BUFFER_SIZE);
      if(r == 0){
        sockeof = 1;
      }else if(r < 0){
        perror("Read Error");
        exit(EXIT_FAILURE);
      }else{
        write(STDOUT_FILENO, stdin_buffer, r);
      }
    }
  }

  close(s);
  return 0;
}
