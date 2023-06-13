#include <stdio.h>

int main(void)
{
  FILE *f;

  /* 1. Write 0 bytes to testfile. */
  if ((f = fopen("testfile", "w")) == NULL) {
    fprintf(stderr, "Can't open testfile for writing.");
    return 1;
  }
  fclose(f);

  /* 2. Test feof and ferror, both before read, after read, after clearerr. */
  if ((f = fopen("testfile", "r")) == NULL) {
    fprintf(stderr, "Can't open testfile.");
    return 1;
  }

  printf("Before attempting to read, feof returns %d, ferror returns %d\n",
         feof(f), ferror(f));

  getc(f);
  printf("After attempting to read, feof returns %d, ferror returns %d\n",
         feof(f), ferror(f));

  clearerr(f);
  printf("After clearerr, feof returns %d, ferror returns %d\n",
         feof(f), ferror(f));

  fclose(f);

  return 0;
}
