#ifndef _BB_H
#define _BB_H

#include "rect.h"

typedef struct point {
  double x, y;
} point;

// Compute the smallest upright bounding box of the given array of points.
void bounding_box(rect *r, const point *p, unsigned n);

#endif // #ifndef _BB_H
