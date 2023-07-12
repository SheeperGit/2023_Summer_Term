#include <stdio.h>
#include <unistd.h>

int main(void)
{
  pid_t p;
  FILE *f;

  printf("hello ");  /* This presents a puzzle! */

  p = fork();
  if (p == -1) {
    perror(":(");
    return 1;
  } else if (p == 0) {
    /* Child process sees p == 0 */
    printf("child here\n");
  } else {
    /* Parent process sees p == child's process ID, != 0, != -1 */
    printf("parent here\n");
  }
  return 0;
}
