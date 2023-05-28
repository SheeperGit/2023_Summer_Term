// main returns the int read from argv[1].
// Except when the number is outside 0-255 or argv[1] makes no sense; then returns 1.
// If argv[1] doesn't exist, returns 0.

#include <stdio.h>

int main(int argc, char **argv)
{
  int r;

  if (argc <= 1) {
    r = 0;
  } else if (sscanf(argv[1], "%d", &r) != 1) {
    fprintf(stderr, "not an integer\n");
    return 1;
  }
  if (r < 0 || r > 255) {
    fprintf(stderr, "out of range\n");
    return 1;
  }
  printf("returning %d\n", r);
  return r;
}
