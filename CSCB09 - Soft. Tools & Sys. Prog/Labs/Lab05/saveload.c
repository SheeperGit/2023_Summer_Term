#include <stdio.h>
#include "point.h"

ssize_t save_point_array(const char *pathname, size_t n, const point *a){
  FILE *f;
  if ((f = fopen(pathname, "w")) == NULL) {
    fprintf(stderr, "Can't open file for writing!");
    return -1;
  }

  int bitsWritten = fwrite(a, sizeof(point), n, f);
  fclose(f);

  return bitsWritten;
}

ssize_t load_point_array(const char *pathname, size_t n, point *a){
  FILE *f;
  if ((f = fopen(pathname, "r")) == NULL) {
    fprintf(stderr, "Can't open file for reading!");
    return -1;
  }

  int bitsRead = fread(a, sizeof(point), n, f);
  fclose(f);

  return bitsRead;
}
