#include <unistd.h>
#include <stdio.h>

int main(void)
{
  if (execlp("ls", "ls", "-l", (char*)NULL) == -1) {
    /* Exercise: Why "ls" twice? */
    perror(":(");
    return 1;
  }
  /* Code below won't be run because snapped away by exec. */
  printf("This should not happen.\n");
  return 0;
}
