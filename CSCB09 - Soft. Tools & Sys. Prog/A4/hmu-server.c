// Server program.

#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define MAX_BUFFER_SIZE 1024

void handle_client(int client_sock) {
  char buffer[MAX_BUFFER_SIZE];
  char user_name[9]; // 8 letters or digits + '\0'
  char file_name[101]; // 100 bytes + '\0'
  char file_size_str[11]; // 10 digits for file size + '\0'

  // Receive username from client //
  int recv_bytes = recv(client_sock, buffer, sizeof(buffer) - 1, 0);
  if (recv_bytes <= 0) {
    close(client_sock);
    return;
  }
  buffer[recv_bytes] = '\0';
  sscanf(buffer, "%8[^\n]", user_name);

  // Receive filename from client //
  recv_bytes = recv(client_sock, buffer, sizeof(buffer) - 1, 0);
  if (recv_bytes <= 0) {
    close(client_sock);
    return;
  }
  buffer[recv_bytes] = '\0';
  sscanf(buffer, "%100[^/\n]", file_name);

  // Receive filesize from client //
  recv_bytes = recv(client_sock, buffer, sizeof(buffer) - 1, 0);
  if (recv_bytes <= 0) {
    close(client_sock);
    return;
  }
  buffer[recv_bytes] = '\0';
  sscanf(buffer, "%10[^\n]", file_size_str);
  long file_size = atol(file_size_str);

  // Receive file content from client //
  FILE *f; 
  if ((f = fopen(file_name, "wb")) == NULL) {
    send(client_sock, "HDERR\n", 6, 0);
    close(client_sock);
    return;
  }

  long total_received = 0;
  while (total_received < file_size) {
      recv_bytes = recv(client_sock, buffer, sizeof(buffer), 0);
      if (recv_bytes <= 0) {
        fclose(f);
        close(client_sock);
        return;
      }
      total_received += recv_bytes;
      fwrite(buffer, 1, recv_bytes, f);
  }
  fclose(f);

  // Send serial number to client //
  static int serial_number = 0;
  char serial_number_str[11]; // 10 digits for serial number + '\0'
  snprintf(serial_number_str, sizeof(serial_number_str), "%d", serial_number++);
  send(client_sock, serial_number_str, strlen(serial_number_str), 0);
  
  close(client_sock);
}

void sigchld_handler(int signum) {
  while (waitpid(-1, NULL, WNOHANG) > 0);
}

// cmdline reminder: portnum, helper
int main(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s <port_number> <helper_program_pathname>\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  int port_number = atoi(argv[1]);
  const char *helper_program_pathname = argv[2];

  struct sigaction sa;
  sa.sa_handler = sigchld_handler;
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = SA_RESTART;
  if (sigaction(SIGCHLD, &sa, NULL) == -1) {
    perror("Error setting signal handler");
    exit(EXIT_FAILURE);
  }

  int sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockfd == -1) {
    perror("Error opening socket");
    exit(EXIT_FAILURE);
  }

  struct sockaddr_in server_addr;
  memset(&server_addr, 0, sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = INADDR_ANY;
  server_addr.sin_port = htons(port_number);

  int optval = 1;
  if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval)) == -1) {
    perror("Error setting socket options");
    exit(EXIT_FAILURE);
  }

  if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
    perror("Error binding socket");
    exit(EXIT_FAILURE);
  }

  if (listen(sockfd, SOMAXCONN) == -1) {
    perror("Error listening on socket");
    exit(EXIT_FAILURE);
  }

  printf("Server is listening on port %d...\n", port_number);

  while (1) {
    struct sockaddr_in client_addr;
    socklen_t client_addr_len = sizeof(client_addr);

    int client_sock = accept(sockfd, (struct sockaddr *)&client_addr, &client_addr_len);
    if (client_sock == -1) {
      continue;
    }

    pid_t pid = fork();
    if (pid == -1) {
      perror("Error forking a child process");
      exit(EXIT_FAILURE);
    } else if (pid == 0) {
      // Child process //
      close(sockfd);
      execlp("./hmu-helper.c", "./hmu-helper.c", (char *)NULL);
      perror("Error executing hmu-helper.c");
      exit(EXIT_FAILURE);
    } else {
      // Parent process //
      close(client_sock);
    }
  }

  close(sockfd);
  return 0;
}

