#include "complex.h"

int main(void)
{
  complex c1 = { .re = 1.0, .im = 2.0 };
  complex c2 = { 3.0, 4.0 };
  complex a, m;
  complex_add(&a, &c2, &c1);
  complex_mul(&m, &c2, &c1);
  complex_print(&a);
  complex_print(&m);
  return 0;
}
