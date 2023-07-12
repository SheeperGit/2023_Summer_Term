#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
  pid_t p;

  p = fork();
  if (p == -1) {
    perror(":(");
    return 1;
  } else if (p == 0) {
    // child delays 1 second, then exits with exit code 42
    sleep(1);
    return 42;
  } else {
    // parent waits and reports
    int s;
    wait(&s);
    printf("wstatus = %d\n", s)
    if (WIFEXITED(s)) {
      printf("child normal exit code: %d\n", WEXITSTATUS(s));
    } else {
      printf("something else\n");
    }
    // Exercise: What if I use WEXITSTATUS unconditionally, without checking
    // WIFEXITED first?

    return 0;
  }
}
