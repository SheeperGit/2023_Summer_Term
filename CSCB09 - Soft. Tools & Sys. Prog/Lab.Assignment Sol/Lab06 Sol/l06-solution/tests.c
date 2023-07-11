/**
 * This is a template for a basic testing file that can be used to test the
 * exercises / assignments.
 *
 * (C) Mustafa Quraish, 2020
 */

#define __testing__

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include "point.h"

/* ------------------------------------------------------------------------- */
/*                              TEST CASES                                   */
/* ------------------------------------------------------------------------- */
/*     Each function is one test case. If the test case does not pass        */
/*     then the function should exit with a non-zero status. Using the       */
/*     <assert.h> library to perform the checks does this automatically.     */
/* ------------------------------------------------------------------------- */

ssize_t __my_save(const char *path, size_t n, const point *a) {
  FILE *f;
  size_t r;

  f = fopen(path, "w");
  if (f == NULL) {
    fprintf(stderr, "cannot open %s for writing\n", path);
    return -1;
  }
  r = fwrite(a, sizeof(point), n, f);
  fclose(f);
  return r;
}

ssize_t __my_load(const char *path, size_t n, point *a) {
  FILE *f;
  size_t r;

  f = fopen(path, "r");
  if (f == NULL) {
    fprintf(stderr, "cannot open %s for reading\n", path);
    return -1;
  }
  r = fread(a, sizeof(point), n, f);
  fclose(f);
  return r;
}

void check(const point *orig, size_t n, const point *stud, int read) {
  for (int i = 0; i < n; i++) {
    if (orig[i].x != stud[i].x || orig[i].y != stud[i].y) {
      if (read) {
        fprintf(stderr, "Function did not read the file properly.\n");
      } else {
        fprintf(stderr, "Function did not write to the file properly.\n");
      }
      exit(1);
    }
  }
}

/* SAVE TESTS */

void test_00() {
  // Make sure file is overwritten, not appended
  const int n = 2;
  point arr[2] = {{1,2}, {3, 4}};
  point arr_sol[2+1] = {};
  
  point arr2[2] = {{2,3}, {4, 5}};
  __my_save("test00.dat", n, arr2);

  save_point_array("test00.dat", n, arr);
  ssize_t ret_sol = __my_load("test00.dat", n+1, arr_sol);
  // That's right, deliberately request one more element to catch bugs of
  // writing too much.
  if (ret_sol != n) {
    fprintf(stderr, "Wrong number of elements saved\n");
    exit(1);
  }
  check(arr_sol, n, arr, 0);
}

void test_01() {
  // Save 1 item
  const int n = 1;
  point arr[1] = {{-456, 546}};
  point arr_sol[1] = {};
  
  ssize_t ret = save_point_array("test01.dat", n, arr);
  if (ret != n) {
    fprintf(stderr, "Function did not return correct value\n");
    exit(1);
  }

  ssize_t ret_sol = __my_load("test01.dat", n, arr_sol);
  if (ret_sol != n) {
    fprintf(stderr, "Wrong number of elements saved\n");
    exit(1);
  }
  check(arr_sol, n, arr, 0);
}

void test_02() {
  // Save many items
  const int n = 1000;
  point arr[1000] = {};
  point arr_sol[1000] = {};
 
  for (int i = 0; i < n; i++) {
    arr[i].x = rand();
    arr[i].y = rand();
  }

  ssize_t ret = save_point_array("test02.dat", n, arr);
  if (ret != n) {
    fprintf(stderr, "Function did not return correct value\n");
    exit(1);
  }
  ssize_t ret_sol = __my_load("test02.dat", n, arr_sol);
  if (ret_sol != n) {
    fprintf(stderr, "Wrong number of elements saved\n");
    exit(1);
  }
  check(arr_sol, n, arr, 0);
}

const char fname3[] = "test03.dat";

void test_03() {
  // Permission denied error.
  // 1st make test03.dat to exist but read-only:
  FILE *f = fopen(fname3, "w");
  fclose(f);
  chmod(fname3, 0400);

  const int n = 1;
  point arr[1] = {{1, 2}};
  ssize_t ret = save_point_array(fname3, n, arr);
  if (ret != -1) {
    fprintf(stderr, "Function returned %zd, not -1.\n", ret);
    exit(1);
  }
}

/* LOAD TESTS */

void test_04() {
  // Load 1 item
  const int n = 1;

  point arr[1] = {{2,3}};
  point arr_sol[1] = {}; 
  
  __my_save("test04.dat", n, arr);
  ssize_t ret = load_point_array("test04.dat", n, arr_sol);

  if (ret != n) {
    fprintf(stderr, "Function did not return correct value\n");
    exit(1);
  }

  check(arr_sol, n, arr, 1);
}

void test_05() {
  // Load many items

  const int n = 1000;
  point arr[1000] = {};
  point arr_sol[1000] = {};
 
  for (int i = 0; i < n; i++) {
    arr[i].x = rand();
    arr[i].y = rand();
  }

  __my_save("test05.dat", n, arr);
  ssize_t ret = load_point_array("test05.dat", n, arr_sol);

  if (ret != n) {
    fprintf(stderr, "Function did not return correct value\n");
    exit(1);
  }

  check(arr_sol, n, arr, 1);
}


void test_06() {
  // Doesn't-exist error.
  // 1st ensure test06.dat DNE:
  remove("test06.dat");

  const int n = 1;
  point arr[1] = {{1, 2}};
  ssize_t ret = load_point_array("test06.dat", n, arr);
  if (ret != -1) {
    fprintf(stderr, "Function returned %zd, not -1.\n", ret);
    exit(1);
  }
}


// Other test cases go here, including helper functions to check correctness
// For eg: compare_linked_lists(...)

/* ------------------------------------------------------------------------- */
/*                CHANGE THE VALUES HERE BASED ON YOUR TESTS                 */
/* ------------------------------------------------------------------------- */

// Change this to the number of tests you have
#define NUMTESTS 7

// Remove all the ones you don't need.
void (*TESTS[NUMTESTS])() = {
    test_00, test_01, test_02, test_03, test_04, test_05, test_06 
};

// ----------------------------------------------------------------------------

int main(int argc, char *argv[]) {
  // If the executable is called with a valid test number as an argument, then
  // get and run only that test. Otherwise, run everything.
  if (argc > 1) {
    int test_num = atoi(argv[1]);
    if (test_num >= 0 && test_num < NUMTESTS) {
      void (*test_case)() = TESTS[test_num];
      test_case();  // Will exit if it fails
      return 0;     // If we reach here, test case passed.
    } else {
      fprintf(stderr, "Test number is invalid. Running all...\n");
    }
  }
  // Run all the tests...
  for (int test_num = 0; test_num < NUMTESTS; test_num++) {
    void (*test_case)() = TESTS[test_num];
    test_case();  // Will exit if it fails
  }

  return 0;  // If we reach here, all test cases passed.
}
