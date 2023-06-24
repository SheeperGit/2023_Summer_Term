#include "heapsort.h"
#include "customer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// I won't bother checking whether delimiting is needed. //
// The additional if statement seems like more computation //
// and so I'm choosing to ignore this check. I think this is right? //

void heapify_at_v(FILE *f, int n, int i) {
    int largest = i;
    int left_index = (2 * i) + 1;
    int right_index = (2 * i) + 2;

    char curCustName[CUSTOMER_NAME_MAX + 1];
    char largestCustName[CUSTOMER_NAME_MAX + 1];
    unsigned curCustLoyalty;
    unsigned largestCustLoyalty;

    // Read the records at given indices. //
    fseek(f, i * sizeof(CUSTOMER_NAME_MAX), SEEK_SET);
    fread(&curCustName, sizeof(CUSTOMER_NAME_MAX) + 1, 1, f);
    curCustName[CUSTOMER_NAME_MAX - 1] = '\0';
    fread(&curCustLoyalty, sizeof(unsigned), 1, f);

    fseek(f, largest * sizeof(CUSTOMER_NAME_MAX), SEEK_SET);
    fread(&largestCustName, sizeof(CUSTOMER_NAME_MAX) + 1, 1, f);
    largestCustName[CUSTOMER_NAME_MAX - 1] = '\0';
    fread(&largestCustLoyalty, sizeof(unsigned), 1, f);
    

    // Compare loyalty, and if same: sort alphabetically! // 
    if (left_index < n) {
        char leftCustName[CUSTOMER_NAME_MAX + 1];
        unsigned leftCustLoyalty;

        fseek(f, left_index * sizeof(CUSTOMER_NAME_MAX), SEEK_SET);
        fread(&leftCustName, sizeof(CUSTOMER_NAME_MAX) + 1, 1, f);
        leftCustName[CUSTOMER_NAME_MAX - 1] = '\0';
        fread(&leftCustLoyalty, sizeof(unsigned), 1, f);
    
        if (leftCustLoyalty > largestCustLoyalty || 
            (leftCustLoyalty == largestCustLoyalty && strcmp(leftCustName, largestCustName) > 0))
        {
            largest = left_index;
            strcpy(largestCustName, leftCustName);
            largestCustLoyalty = leftCustLoyalty;
        }
    }

    if (right_index < n) {
        char rightCustName[CUSTOMER_NAME_MAX + 1];
        unsigned rightCustLoyalty;

        fseek(f, right_index * sizeof(CUSTOMER_NAME_MAX), SEEK_SET);
        fread(&rightCustName, sizeof(CUSTOMER_NAME_MAX) + 1, 1, f);
        rightCustName[CUSTOMER_NAME_MAX - 1] = '\0';
        fread(&rightCustLoyalty, sizeof(unsigned), 1, f);

        if (rightCustLoyalty > largestCustLoyalty || 
            (rightCustLoyalty == largestCustLoyalty && strcmp(rightCustName, largestCustName) > 0))
        {
            largest = right_index;
            strcpy(largestCustName, rightCustName);
            largestCustLoyalty = rightCustLoyalty;
        }
    }

    // Swap records (if necessary) //
    if (largest != i) {
        // Write records at given indices //
        fseek(f, i * sizeof(CUSTOMER_NAME_MAX), SEEK_SET);
        fwrite(&largestCustName, sizeof(CUSTOMER_NAME_MAX), 1, f);
        fwrite(&largestCustLoyalty, sizeof(unsigned), 1, f);

        fseek(f, largest * sizeof(CUSTOMER_NAME_MAX), SEEK_SET);
        fwrite(&curCustName, sizeof(CUSTOMER_NAME_MAX), 1, f);
        fwrite(&curCustLoyalty, sizeof(unsigned), 1, f);

        // Recursively heapify the affected subtree //
        heapify_at_v(f, n, largest);
    }
}

int heapsort(const char *filename) {
    FILE *f = fopen(filename, "r+b");
    if (f == NULL) {
        fprintf(stderr, "Unable to open %s for reading\n", filename);
        return 0;
    }

    fseek(f, 0, SEEK_END);
    int numRecords = ftell(f) / sizeof(customer);

    // Building max heap... //
    for (int i = numRecords / 2 - 1; i >= 0; i--) {
        heapify_at_v(f, numRecords, i);
    }

    // Heapsort //
    for (int i = numRecords - 1; i > 0; i--) {

        // Swap root (max element) with the last record //
        fseek(f, 0, SEEK_SET);
        char rootName[CUSTOMER_NAME_MAX + 1];
        char lastName[CUSTOMER_NAME_MAX + 1];
        unsigned rootLoyalty;
        unsigned lastLoyalty;

        fread(&rootName, sizeof(CUSTOMER_NAME_MAX) + 1, 1, f);
        rootName[CUSTOMER_NAME_MAX - 1] = '\0';
        fread(&rootLoyalty, sizeof(unsigned), 1, f);
        
        fseek(f, i * sizeof(customer), SEEK_SET);

        fread(&lastName, sizeof(CUSTOMER_NAME_MAX) + 1, 1, f);
        lastName[CUSTOMER_NAME_MAX - 1] = '\0';
        fread(&lastLoyalty, sizeof(unsigned), 1, f);
        

        fseek(f, i * sizeof(CUSTOMER_NAME_MAX), SEEK_SET);
        fwrite(&rootName, sizeof(CUSTOMER_NAME_MAX), 1, f);
        fwrite(&rootLoyalty, sizeof(unsigned), 1, f);

        fseek(f, 0, SEEK_SET);
        fwrite(&lastName, sizeof(CUSTOMER_NAME_MAX), 1, f);
        fwrite(&lastLoyalty, sizeof(unsigned), 1, f);

        // Reduce heap size and heapify root //
        heapify_at_v(f, i, 0);
    }

    fclose(f);
    return 1;
}

int main(void){
    const char *myfilename = "outputsample.dat";
    int final = heapsort(myfilename);
    if (final)
        printf("Sorting completed successfully.\n");
    else
        printf("Error occurred during sorting.\n");

    FILE *f = fopen(myfilename, "r+b");
    if (f == NULL) {
        fprintf(stderr, "Unable to open %s for reading\n", myfilename);
        return 0;
    }

    fseek(f, 0, SEEK_END);
    int numRecords = ftell(f) / sizeof(customer);

    // Print the sorted records //
    fseek(f, 0, SEEK_SET);
    printf("Sorted records:\n");
    for (int i = 0; i < numRecords; i++) {
        char curName[CUSTOMER_NAME_MAX + 1];
        unsigned curLoyalty;
        fread(&curName, sizeof(CUSTOMER_NAME_MAX), 1, f);
        fread(&curLoyalty, sizeof(unsigned), 1, f);

        printf("Name: %s\tLoyalty: %u\n", curName, curLoyalty);
    }

    return 0;
}