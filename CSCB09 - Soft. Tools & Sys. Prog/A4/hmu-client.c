// Client program.

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

#define MAX_BUFFER_SIZE 1024

void send_data(int sockfd, const char *data) {
    if (send(sockfd, data, strlen(data), 0) == -1) {
      perror("Error sending data");
      exit(EXIT_FAILURE);
    }
}

// cmdline reminder: IP-address, portnum, username, filename //
int main(int argc, char *argv[]) {
    if (argc != 5) {
      fprintf(stderr, "Usage: %s <server_address> <server_port> <username> <filename>\n", argv[0]);
      exit(EXIT_FAILURE);
    }

    const char *server_addr = argv[1];
    int server_port = atoi(argv[2]);
    const char *username = argv[3];
    const char *filename = argv[4];

    // Open the file to read its content and determine its size
    FILE *f = fopen(filename, "r");
    if (!f) {
      fprintf(stderr, "Error opening file: %s\n", filename);
      exit(EXIT_FAILURE);
    }

    fseek(f, 0, SEEK_END);
    long file_size = ftell(f);
    fseek(f, 0, SEEK_SET);

    // Create a buffer to store the entire file content
    char file_content[MAX_BUFFER_SIZE];
    size_t bytes_read = fread(file_content, 1, sizeof(file_content), f);
    fclose(f);

    if (bytes_read != file_size) {
      fprintf(stderr, "Error reading file: %s\n", filename);
      exit(EXIT_FAILURE);
    }

    // Connect to the server //
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
      perror("Error opening socket");
      exit(EXIT_FAILURE);
    }

    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(server_port);
    inet_pton(AF_INET, server_addr, &server_addr.sin_addr);

    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
      perror("Error connecting to the server");
      exit(EXIT_FAILURE);
    }

    // Send user name, file name, file size, and file content to the server //
    send_data(sockfd, username);
    send_data(sockfd, "\n");

    send_data(sockfd, filename);
    send_data(sockfd, "\n");

    char file_size_str[11]; // 10 digits for file size + '\0'
    sprintf(file_size_str, "%ld", file_size);
    send_data(sockfd, file_size_str);
    send_data(sockfd, "\n");

    send_data(sockfd, file_content);

    // Receive serial number from the server //
    char serial_number_str[11]; // 10 digits for serial number + '\0'
    int recv_bytes = recv(sockfd, serial_number_str, sizeof(serial_number_str) - 1, 0);
    if (recv_bytes <= 0) {
      perror("Error receiving serial number");
      exit(EXIT_FAILURE);
    }
    serial_number_str[recv_bytes] = '\0';

    printf("Received serial number: %s\n", serial_number_str);

    close(sockfd);
    return 0;
}

