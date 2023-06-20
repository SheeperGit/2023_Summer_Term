#include "heapsort.h"
#include "customer.h"
#include <stdio.h>
#include <string.h>

// Returns the numofRecords of filename. //
// O/w, return -1. //
int numofRecords(const char *filename){
    FILE *f;
    if ((f = fopen(filename, "r")) == NULL){
        fprintf(stderr, "Unable to read from file (to get fileSize)\n");
        return -1;
    }
    fseek(f, 0, SEEK_END);
    int numofRecords = ftell(f) / sizeof(customer);
    fclose(f);

    return numofRecords;
}

int heapsort(const char *filename) {
    FILE *f;
    if ((f = fopen(filename, "r")) == NULL) {
    fprintf(stderr, "Unable to read from file\n");
    return 0;
    }

    char buffer[CUSTOMER_NAME_MAX + 1];
    while (fgets(buffer, CUSTOMER_NAME_MAX + 1, f) != NULL) {
        // Remove newline character if present
        char* newline = strchr(buffer, '\n');
        if (newline != NULL) {
            *newline = '\0';
        }

        // Process the string
        printf("%s\n", buffer);

        // Stop reading if null character is encountered
        if (strchr(buffer, '\0') != NULL) {
            break;
        }
    }

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
