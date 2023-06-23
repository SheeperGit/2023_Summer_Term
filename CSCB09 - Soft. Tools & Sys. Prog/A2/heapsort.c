#include "heapsort.h"
#include "customer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void heapify_at_v(FILE *f, int n, int index) {
    int largest = index;
    int left = 2 * index + 1;
    int right = 2 * index + 2;

    // Read the records at the given indices. //
    customer current, largestCustomer;
    fseek(f, index * sizeof(customer), SEEK_SET);
    fread(&current, sizeof(customer), 1, f);
    fseek(f, largest * sizeof(customer), SEEK_SET);
    fread(&largestCustomer, sizeof(customer), 1, f);

    //printf("Stuff= %s:%u\t%s:%u\n", current.name, current.loyalty, largestCustomer.name, largestCustomer.loyalty);

    // Compare loyalty, and if same: sort alphabetically! // 
    if (left < n) {
        customer leftCustomer;
        fseek(f, left * sizeof(customer), SEEK_SET);
        fread(&leftCustomer, sizeof(customer), 1, f);
        if (leftCustomer.loyalty > largestCustomer.loyalty || 
            (leftCustomer.loyalty == largestCustomer.loyalty && strcmp(leftCustomer.name, largestCustomer.name) < 0))
        {
            largest = left;
            //printf("BfLeft= %s:%u\n", largestCustomer.name, largestCustomer.loyalty);
            largestCustomer = leftCustomer;
            //printf("BfLeft= %s:%u\n", leftCustomer.name, leftCustomer.loyalty);
        }
    }

    if (right < n) {
        customer rightCustomer;
        fseek(f, right * sizeof(customer), SEEK_SET);
        fread(&rightCustomer, sizeof(customer), 1, f);
        if (rightCustomer.loyalty > largestCustomer.loyalty ||
            (rightCustomer.loyalty == largestCustomer.loyalty && strcmp(rightCustomer.name, largestCustomer.name) < 0))
        {
            largest = right;
            //printf("BfRight= %s:%u\n", largestCustomer.name, largestCustomer.loyalty);
            largestCustomer = rightCustomer;
            //printf("BfRight= %s:%u\n", rightCustomer.name, rightCustomer.loyalty);
        }
    }

    // Swap records if necessary //
    if (largest != index) {
        // Write the records at the given indices
        fseek(f, index * sizeof(customer), SEEK_SET);
        fwrite(&largestCustomer, sizeof(customer), 1, f);
        fseek(f, largest * sizeof(customer), SEEK_SET);
        fwrite(&current, sizeof(customer), 1, f);

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
        customer root;
        fread(&root, sizeof(customer), 1, f);

        fseek(f, i * sizeof(customer), SEEK_SET);
        customer last;
        fread(&last, sizeof(customer), 1, f);

        fseek(f, i * sizeof(customer), SEEK_SET);
        fwrite(&root, sizeof(customer), 1, f);

        fseek(f, 0, SEEK_SET);
        fwrite(&last, sizeof(customer), 1, f);

        // Reduce heap size and heapify the root //
        heapify_at_v(f, i, 0);
    }

    fclose(f);
    return 1;
}

int main(void){
    const char *myfilename = "sample.dat";
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
    // Print the sorted records
    fseek(f, 0, SEEK_SET);
    printf("Sorted records:\n");
    for (int i = 0; i < numRecords; i++) {
        customer current;
        fread(&current, sizeof(customer), 1, f);
        printf("Name: %s\tLoyalty: %d\n", current.name, current.loyalty);
    }

    return 0;
}
