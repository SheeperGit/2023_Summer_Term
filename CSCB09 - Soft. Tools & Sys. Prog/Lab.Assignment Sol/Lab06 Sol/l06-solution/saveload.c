#include <stdio.h>
#include "point.h"

ssize_t save_point_array(const char *pathname, size_t n, const point *a)
{
  FILE *f;
  size_t r;

  f = fopen(pathname, "wb");
  if (f == NULL) {
    // fprintf(stderr, "cannot open %s for writing\n", pathname);
    return -1;
  }
  r = fwrite(a, sizeof(point), n, f);
  fclose(f);
  return r;
}

ssize_t load_point_array(const char *pathname, size_t n, point *a)
{
  FILE *f;
  size_t r;

  f = fopen(pathname, "rb");
  if (f == NULL) {
    // fprintf(stderr, "cannot open %s for reading\n", pathname);
    return -1;
  }
  r = fread(a, sizeof(point), n, f);
  fclose(f);
  return r;
}
