#include <stdio.h>

int main(void)
{
  int i;

  scanf("%d", &i);

#ifdef MY_DEBUG_FLAG
  fprintf(stderr, "received i = %d\n", i);
#endif

  printf("%d\n", i*i);

  return 0;
}

// Compile with -DMY_DEBUG_FLAG, or without, and see the difference.
