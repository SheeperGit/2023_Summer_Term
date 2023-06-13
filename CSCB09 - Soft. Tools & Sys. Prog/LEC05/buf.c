#include <stdio.h>

/* Do a lot of putc's to a file.  If no argument, default buffering (full
 * buffering for files). Else, no buffering.  For measuring time difference.
 */
int main(int argc, char **argv)
{
  FILE *fp;
  int i;

  fp = fopen("testfile", "w");
  /* should check for NULL but meh it's 3AM */
  if (argc > 1) {
    setvbuf(fp, NULL, _IONBF, 0);
  }
  for (i = 0; i < 1000000; i++) {
    putc(255, fp);
  }
  fclose(fp);
  return 0;
}
