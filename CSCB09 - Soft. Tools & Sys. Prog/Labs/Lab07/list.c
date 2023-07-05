#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

// Please use the man pages of opendir etc to find out more #include's you need.

int main(int argc, char *argv[]) {
  // If the user gives 1 cmdline argument:
  //   argc=2, argv[1] is the argument.
  // If the user gives 2 cmdline arguments:
  //   argc=3, argv[1] is the 1st argument, argv[2] the 2nd.

  if (argc < 2){
    fprintf(stderr, "Usage: list dirName [charToIgnore]\n");
    return 1;
  }

  DIR *d = opendir(argv[1]);
  if (d == NULL) {
    fprintf(stderr, "Couldn't find dir!\n");
    return 2;
  }

  ////////////////////////////////////////////////////////
  ////////////// Here comes the fun stuff! //////////////
  //////////////////////////////////////////////////////
  
  struct dirent *dp;

  if (argc == 2) {
    while ((dp = readdir(d)) != NULL){
      printf("%s\n", dp->d_name);
    }
  }

  if (argc > 2) {
    char ignore_c = argv[2][0];
    while ((dp = readdir(d)) != NULL){
      if (dp->d_name[0] != ignore_c){
        printf("%s\n", dp->d_name);
      }
    }
  }

  closedir(d);
  return 0;
}
