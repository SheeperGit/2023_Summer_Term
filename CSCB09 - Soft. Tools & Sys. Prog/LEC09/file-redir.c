#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

#define FILENAME "infile"

void mkinfile(void)
{
  FILE *f = fopen(FILENAME, "w");
  if (f == NULL) {
    perror("file-redir during mkfile");
    exit(1);
  }
  fprintf(f, "hello there\n");
  fprintf(f, "aloha everyone\n");
  fprintf(f, "bonjour\n");
  fclose(f);
}

/* Basically sort < infile, infile as made above. */

int main(void)
{
  // Set up infile
  mkinfile();

  pid_t p;
  int fd_inp;

  if ((fd_inp = open(FILENAME, O_RDONLY | O_CLOEXEC)) == -1) {
    perror("open input file :( ");
    return 1;
  }

  /* Opening before fork-exec allows you to: If opening fails, don't bother to
   * fork-exec at all.
   */

  if ((p = fork()) == -1) {
    perror("fork :( ");
    return 1;
  } else if (p != 0) {
    /* This parent shows what shell does: close fd_inp and wait for child to
     * finish, because shell still has more to do after.
     * But if you have nothing left to do, you can quit right away.
     */
    close(fd_inp);
    wait(NULL);
    return 0;
  } else {
    /* Child. Here be file redirection! */
    dup2(fd_inp, 0);
    // Note fd_inp is marked close-on-exec, the exec below will close it.
    if (execlp("sort", "sort", (char*)NULL) == -1) {
      perror("exec :( ");
      return 1;
    }
  }
}
