#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>

// Takes sockaddr but actually expects sockaddr_in
void print_inet4_addr(const struct sockaddr *a) {
  if (a->sa_family != AF_INET) {
    fprintf(stderr, "non-IPv4 address\n");
    exit(1);
  }
  const struct sockaddr_in *a4 = (const struct sockaddr_in *)a;
  char buf[INET_ADDRSTRLEN];
  inet_ntop(AF_INET, & a4->sin_addr, buf, INET_ADDRSTRLEN);
  printf("%s\n", buf);
}

int main(int argc, char *argv[]) {
  struct addrinfo hint;
  struct addrinfo *head;

  // For each IPv4 address provided by getaddrinfo() (traverse the whole linked list),
  // use print_inet4_addr() above to print the IPv4 address in dot notation.

  //
  // Set the service parameter to the string "80" or "http", meaning port number
  // is 80.

  memset(&hint, 0, sizeof(hint));
  hint.ai_family = AF_INET;     // Set to IPv4 //
  hint.ai_socktype = SOCK_STREAM; // Use the socket stream //

  // Use getaddrinfo() to find the IPv4 addresses of domain/host name argv[1].
  int s; 
  if ((s = getaddrinfo(argv[1], "80", &hint, &head)) != 0) {
    fprintf(stderr, "getaddrinfo() error: %s\n", gai_strerror(s));
    return 1;
  }

  //
  // Set up the hint parameter to request IPv4-only and stream-only.
  //
  // For each IPv4 address provided by getaddrinfo() (traverse the whole linked list),
  // use print_inet4_addr() above to print the IPv4 address in dot notation.

  for (struct addrinfo *p = head; p != NULL; p = p->ai_next) {
    print_inet4_addr(p->ai_addr);
  }

  //
  // Lastly, use freeaddrinfo() to free the linked list.

  freeaddrinfo(head);

  //
  // Optional: If getaddrinfo() returns a non-zero number, use gai_strerror()
  // for printing out the error message to stderr, then exit.

  return 0;
}
