#include "heapsort.h"
#include "customer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void heapify_at_v(FILE *f, int n, int i) {
    int largest = i;
    int left_index = (2 * i) + 1;
    int right_index = (2 * i) + 2;

    // Read the records at given indices. //
    customer curCust, largestCust;
    fseek(f, i * sizeof(customer), SEEK_SET);
    fread(&curCust, sizeof(customer), 1, f);

    fseek(f, largest * sizeof(customer), SEEK_SET);
    fread(&largestCust, sizeof(customer), 1, f);

    // Compare loyalty, and if same: sort alphabetically! // 
    if (left_index < n) {
        customer leftCust;
        fseek(f, left_index * sizeof(customer), SEEK_SET);
        fread(&leftCust, sizeof(customer), 1, f);

        if (leftCust.loyalty > largestCust.loyalty || 
            (leftCust.loyalty == largestCust.loyalty && strcmp(leftCust.name, largestCust.name) > 0))
        {
            largest = left_index;
            largestCust = leftCust;
        }
    }

    if (right_index < n) {
        customer rightCust;
        fseek(f, right_index * sizeof(customer), SEEK_SET);
        fread(&rightCust, sizeof(customer), 1, f);
            
        if (rightCust.loyalty > largestCust.loyalty ||
            (rightCust.loyalty == largestCust.loyalty && strcmp(rightCust.name, largestCust.name) > 0))
        {
            largest = right_index;
            largestCust = rightCust;
        }
    }

    // Swap records (if necessary) //
    if (largest != i) {
        // Write records at given indices //
        fseek(f, i * sizeof(customer), SEEK_SET);
        fwrite(&largestCust, sizeof(customer), 1, f);
        fseek(f, largest * sizeof(customer), SEEK_SET);
        fwrite(&curCust, sizeof(customer), 1, f);

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

        // Reduce heap size and heapify root //
        heapify_at_v(f, i, 0);
    }

    fclose(f);
    return 1;
}
