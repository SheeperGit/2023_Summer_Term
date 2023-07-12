#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define FILENAME "foo"

void create_file()
{
  FILE *s = fopen(FILENAME, "w");
  fprintf(s, "abc\n");
  fclose(s);
}

int main(void)
{
  // Prep: Set up test file content.
  create_file();

  int fd1, fd2;
  char stuff;

  // Experiment 1: Two open's => independent "cursors"

  printf("Experiment 1: two opens\n");
  fd1 = open(FILENAME, O_RDONLY);
  fd2 = open(FILENAME, O_RDONLY);
  read(fd1, &stuff, 1);                      // obtains 'a'
  printf("one byte from fd1 (%d): %c\n", fd1, stuff);
  read(fd2, &stuff, 1);                      // obtains 'a' too
  printf("one byte from fd2 (%d): %c\n", fd2, stuff);
  close(fd1);
  close(fd2);
  printf("\n");

  // Experiment 2: One open => one "cursor" only. dup => shared cursor

  printf("Experiment 2: one open, one dup\n");
  fd1 = open(FILENAME, O_RDONLY);
  fd2 = dup(fd1);
  read(fd1, &stuff, 1);                      // obtains 'a'
  printf("one byte from fd1 (%d): %c\n", fd1, stuff);
  read(fd2, &stuff, 1);                      // obtains 'b'
  printf("one byte from fd2 (%d): %c\n", fd2, stuff);
  close(fd1);
  close(fd2);
  printf("\n");

  // At this point you can't distinguish these two theories yet:
  // 1. "cursor" is per open per process
  // 2. "cursor" is per open but otherwise system-wide, shared over processes
  // Experiment 3 rejects the former:

  // Experiment 3: one open, two processes => still shared "cursor"

  printf("Experiment 3: open then fork\n");
  fd1 = open(FILENAME, O_RDONLY);
  pid_t p = fork();
  if (p == -1) {
    perror("fork fails");
    return 1;
  } else if (p != 0) {
    // parent runs this code
    sleep(1); // try to let child go first
    read(fd1, &stuff, 1);
    printf("one byte from parent (fd1=%d): %c\n", fd1, stuff);
  } else {
    // child runs this code
    read(fd1, &stuff, 1);
    printf("one byte from child (fd1=%d): %c\n", fd1, stuff);
  }

  return 0;
}
