#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>

/* Basically "parent | sort". */

int main(void)
{
  int pipefd[2];

  if (pipe(pipefd) == -1) {
    perror("pipe :( ");
    return 1;
  }

  pid_t p;

  if ((p = fork()) == -1) {
    perror("fork :( ");
    return 1;
  } else if (p != 0) {
    FILE *out;
    /* Parent doesn't need read end. */
    close(pipefd[0]);
    out = fdopen(pipefd[1], "a");
    fprintf(out, "hello there\n");
    fprintf(out, "aloha everyone\n");
    fprintf(out, "bonjour\n");
    fclose(out);
    wait(NULL);  // wait for child to be sure :)
    return 0;
  } else {
    /* Child doesn't need write end. */
    close(pipefd[1]);
    /* Redirect stdin from read end before exec'ing sort. sort reads stdin, but
     * that's our pipe! */
    dup2(pipefd[0], 0);
    /* Doesn't need original read-end FD, 0 has read end now. */
    close(pipefd[0]);
    if (execlp("sort", "sort", (char*)NULL) == -1) {
      perror("exec :( ");
      return 1;
    }
  }
}
