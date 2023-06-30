#ifndef _RECT_H
#define _RECT_H

typedef struct rect {
  double w, h;
} rect;

double rect_area(const rect *r);

#endif // #ifndef _RECT_H
