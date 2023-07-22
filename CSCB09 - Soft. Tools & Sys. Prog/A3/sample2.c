#include <stdio.h>
#include "command.h"

static command_list *foo(void) {
  static char *c0[] = {"tr", "-cs", "A-Za-z", "\\n", NULL};
  static char *c1[] = {"tr", "a-z", "A-Z", NULL};
  static char *c2[] = {"uniq", NULL};
  static char **c[] = {c0, c1, c2};
  static command_list cs = {sizeof c / sizeof(char **), c};
  return &cs;
}

int main(void) {
  chain_piping(foo());
  return 0;
}
