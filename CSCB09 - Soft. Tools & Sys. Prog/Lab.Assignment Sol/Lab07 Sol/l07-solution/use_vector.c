#include "complex.h"
#include "vector.h"

int main(void)
{
  vector v1 = { .x1 = {.re = 1.0, .im = 2.0}, .x2 = {3.0, 4.0}};
  vector v2 = {{1.0, 2.0}, {3.0, 4.0}};
  complex c = {0.3, 0.4};
  vector a;
  vector_add(&a, &v1, &v2);
  vector_print(&a);
  vector_scale(&a, &c, &v1);
  vector_print(&a);
  return 0;
}
