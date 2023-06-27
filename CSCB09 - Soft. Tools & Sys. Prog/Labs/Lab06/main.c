#include <stdio.h>


/* Part 1: Complex numbers. */

typedef struct complex
{
  double re, im;
} complex;

void complex_add(complex *dst, const complex *z1, const complex *z2)
{
  dst->re = z1->re + z2->re;
  dst->im = z1->im + z2->im;
}

void complex_mul(complex *dst, const complex *z1, const complex *z2)
{
  dst->re = z1->re * z2->re - z1->im * z2->im;
  dst->im = z1->re * z2->im + z1->im * z2->re;
}

void complex_print(const complex *z)
{
  printf("%f + %f i", z->re, z->im);
}


/* Part 2: 2D Vectors over complex numbers. */

typedef struct vector
{
  complex x1, x2;
} vector;

void vector_add(vector *dst, const vector *v1, const vector *v2)
{
  complex_add(&dst->x1, &v1->x1, &v2->x1);
  complex_add(&dst->x2, &v1->x2, &v2->x2);
}

void vector_scale(vector *dst, const complex *c, const vector *v)
{
  complex_mul(&dst->x1, c, &v->x1);
  complex_mul(&dst->x2, c, &v->x2);
}

void vector_print(const vector *v)
{
  printf("(");
  complex_print(&v->x1);
  printf(", ");
  complex_print(&v->x2);
  printf(")");
}


/* Part 3: main */

int main(void)
{
  const complex c1 = {3, -2};
  const complex c2 = {1, 2};
  const vector v = {{1, 0}, {-1, 4}};

  // This program checks an example of the following vector space axiom:
  // (c1 * c2) * v = c1 * (c2 * v)

  complex c;
  vector w, u;

  // 1. (c1 * c2) * v
  complex_mul(&c, &c1, &c2);
  vector_scale(&w, &c, &v);
  vector_print(&w);
  printf("\n");

  // 2. c1 * (c2 * v)
  vector_scale(&u, &c2, &v);
  vector_scale(&w, &c1, &u);
  vector_print(&w);
  printf("\n");

  return 0;
}
