#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "customer.h"
#include "heapsort.h"

void print_customer_data(const char *filename) {
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        fprintf(stderr, "Unable to open %s for reading\n", filename);
        return;
    }

    fseek(f, 0, SEEK_END);
    long file_size = ftell(f);
    int num_records = file_size / sizeof(customer);
    fseek(f, 0, SEEK_SET);

    customer *customers = malloc(num_records * sizeof(customer));
    if (customers == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        fclose(f);
        return;
    }

    fread(customers, sizeof(customer), num_records, f);
    fclose(f);

    for (int i = 0; i < num_records; i++) {
        printf("Name: %.44s\tLoyalty: %u\n", customers[i].name, customers[i].loyalty);
    }

    free(customers);
}

void add_customer(const char *filename, const char *name, unsigned loyalty) {
    FILE *f = fopen(filename, "ab");
    if (f == NULL) {
        fprintf(stderr, "Unable to open %s for writing\n", filename);
        return;
    }

    customer new_customer;
    strncpy(new_customer.name, name, CUSTOMER_NAME_MAX);
    new_customer.name[CUSTOMER_NAME_MAX - 1] = '\0';
    new_customer.loyalty = loyalty;

    fwrite(&new_customer, sizeof(customer), 1, f);
    fclose(f);
}

void erase_file(const char *filename) {
    FILE *f = fopen(filename, "wb");
    if (f == NULL) {
        fprintf(stderr, "Unable to open %s for writing\n", filename);
        return;
    }

    fclose(f);
}


int main(int argc, char *argv[]) {
    int opt;
    char *filename = "outputsample.dat";
    char *name = NULL;
    unsigned loyalty = 0;
    int erase_data = 0;

    while ((opt = getopt(argc, argv, "f:n:l:e")) != -1) {
        switch (opt) {
            case 'f':
                filename = optarg;
                break;
            case 'n':
                name = optarg;
                break;
            case 'l':
                loyalty = atoi(optarg);
                break;
            case 'e':
                erase_data = 1;
                break;
            default:
                fprintf(stderr, "Usage: %s -f filename -n name -l loyalty -e\n", argv[0]);
                return 1;
        }
    }

    if (filename == NULL) {
        fprintf(stderr, "Missing required argument: -f filename\n");
        fprintf(stderr, "Usage: %s -f filename -n name -l loyalty -e\n", argv[0]);
        return 1;
    }

    if (erase_data) {
        erase_file(filename);
        printf("Erased all customer data from %s\n", filename);
    } else if (name != NULL && loyalty != 0) {
        printf("Customer Data:\n");
        print_customer_data(filename);

        printf("\nAdding new customer!\n");
        add_customer(filename, name, loyalty);

        printf("\nUpdated Customer Data:\n");
        print_customer_data(filename);
    } else {
        printf("No action specified\n");
    }

    return 0;
}