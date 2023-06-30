#include "rect.h"
#include "bb.h"

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
