#include <stdio.h>
#include "rect.h"
#include "bb.h"

int main(void)
{
  point myp[4] = { {1,2}, {-1,-1}, {0.5, -0.1}, {-0.3, 0.4} };
  rect myrect;

  bounding_box(&myrect, myp, 4);
  printf("w=%f h=%f area=%f\n", myrect.w, myrect.h, rect_area(&myrect));

  return 0;
}
