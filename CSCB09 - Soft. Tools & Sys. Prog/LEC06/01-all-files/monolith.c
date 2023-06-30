#include <stdio.h>

// Part 1: Rectangle representation and basic operations.

typedef struct rect {
  double w, h;
} rect;

double rect_area(const rect *r)
{
  return r->w * r->h;
}


// Part 2: An algorithm related to rectangles but let's say doesn't belong to
// Part 1.

typedef struct point {
  double x, y;
} point;

// Compute the smallest upright bounding box of the given array of points.
void bounding_box(rect *r, const point *p, unsigned n)
{
  if (n == 0) {
    r->w = 0;
    r->h = 0;
  } else {
    double x_min, x_max, y_min, y_max;
    x_min = x_max = p[0].x;
    y_min = y_max = p[0].y;

    unsigned i;
    for (i = 0; i < n; i++) {
      if (p[i].x < x_min) { x_min = p[i].x; }
      if (p[i].x > x_max) { x_max = p[i].x; }
      if (p[i].y < y_min) { y_min = p[i].y; }
      if (p[i].y > y_max) { y_max = p[i].y; }
    }
    r->w = x_max - x_min;
    r->h = y_max - y_min;
  }
}


// Part 3: User of the above two. (This toy example just has main, but in
// general may have more, especially helper functions.)

int main(void)
{
  point myp[4] = { {1,2}, {-1,-1}, {0.5, -0.1}, {-0.3, 0.4} };
  rect myrect;

  bounding_box(&myrect, myp, 4);
  printf("w=%f h=%f area=%f\n", myrect.w, myrect.h, rect_area(&myrect));

  return 0;
}


// In a large project, we would split out the 3 parts into 3 modules.
