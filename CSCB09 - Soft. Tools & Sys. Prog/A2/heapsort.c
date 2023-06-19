#include "heapsort.h"
#include "customer.h"
#include <stdio.h> // DELETE LATER

int heapsort(const char *filename) {
    FILE *f;
    if ((f = fopen(filename, "r")) == NULL) {
    fprintf(stderr, "Unable to read from file\n");
    return 0;
    }

    fseek(f, 48, 0);
    int numofRecords = ftell(f) / sizeof(customer);
    printf("numofRecords = %d\n", numofRecords);

    fclose(f);
    return 1;
}

int main(void){
    char *myfilename = "sample.dat";
    int result = heapsort(myfilename);
    return 0;
}

// My debug/test cases: //
#ifndef EBUGFLAG
#define EBUGFLAG


#endif
