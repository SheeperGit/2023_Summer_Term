#include <stdio.h>
#include "command.h"

static command_list *foo(void) {
  static char *c0[] = {"sort", NULL};
  static char **c[] = {c0};
  static command_list cs = {sizeof c / sizeof(char **), c};
  return &cs;
}

int main(void) {
  chain_piping(foo());
  return 0;
}
