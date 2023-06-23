#include "heapsort.h"
#include "customer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Returns the numofRecords of filename. //
// O/w, return -1. //
int numofRecords(const char *filename){
    FILE *f;
    if ((f = fopen(filename, "r")) == NULL){
        fprintf(stderr, "Unable to read from file (to get numofRecords)\n");
        return -1;
    }
    fseek(f, 0, SEEK_END);
    int numofRecords = ftell(f) / sizeof(customer);
    fclose(f);

    return numofRecords;
}

long getNextNamePosition(FILE* file, long currentPosition) {
    fseek(file, currentPosition, SEEK_SET);  // Set the file position indicator to the current position

    char buffer[CUSTOMER_NAME_MAX];
    fread(buffer, sizeof(char), CUSTOMER_NAME_MAX, file);  // Read the next name into the buffer

    // Find the position of the next name
    for (int i = 0; i < CUSTOMER_NAME_MAX; i++) {
        if (buffer[i] == '\0') {
            long nextPosition = currentPosition + i + 1;
            // Skip any remaining null characters
            while (buffer[nextPosition - currentPosition] == '\0') {
                nextPosition++;
            }
            return nextPosition;  // Return the position of the next name
        }
    }

    return -1;  // Return -1 if the next name position could not be determined
}


char *getCustomerName(const char* filename, long pos) {
    FILE* f;
    if ((f = fopen(filename, "r")) == NULL) {
        fprintf(stderr, "Unable to read from file (to getCustomerName)\n");
        return NULL;
    }

    if (fseek(f, pos, SEEK_SET) != 0) {
        fprintf(stderr, "Failed to set file position (to getCustomerName)\n");
        fclose(f);
        return NULL;
    }

    // Storing an extra char b/c fgets reads (n - 1) chars. //
    char* buffer = (char*)malloc(CUSTOMER_NAME_MAX * sizeof(char) + sizeof(char));
    if (buffer == NULL) {
        printf("Failed to allocate memory.\n");
        fclose(f);
        return NULL;
    }

    fgets(buffer, CUSTOMER_NAME_MAX + 1, f);
    fclose(f);

    return buffer;
}

int heapsort(const char *filename) {
    FILE *f;
    if ((f = fopen(filename, "r")) == NULL) {
    fprintf(stderr, "Unable to read from file\n");
    return 0;
    }

    int i = 0;
    long currentPos = 0;
    char *customerName[1000];
    while (1) {
        char* name = getCustomerName(filename, currentPos);
        if (name == NULL) {
            fprintf(stderr, "Failed to read the name.\n");
            break;
        }

        customerName[i] = name;
        printf("Name Saved: %s\n", customerName[i]);
        i++;

        currentPos = getNextNamePosition(f, currentPos);
        if (currentPos == -1) {
            fprintf(stderr, "Failed to get the next name position.\n");
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
