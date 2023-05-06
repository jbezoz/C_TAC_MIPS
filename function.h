#include <stdio.h>
#include <stdlib.h>
#include <string.h> 

#define TABLE_SIZE 100

char temp_key[100];
char temp_value[100];

// A node in the hash table
typedef struct node
{
    char *key;
    char *value;
    struct node *next;
} Node;

// The hash table
Node *table[TABLE_SIZE];

// A hash function to map a key to an index in the table
unsigned int hash(char *key)
{
    unsigned int hash = 0;
    for (int i = 0; key[i] != '\0'; i++)
    {
        hash = hash * 31 + key[i];
    }
    //printf("\nhash(%s) : %d\n",key,hash%TABLE_SIZE);
    return hash % TABLE_SIZE;
}

// Insert a key-value pair into the hash table
void insert(char *key, char *value)
{
    unsigned int index = hash(key);

    // Check if the key already exists in the table
    Node *current = table[index];
    while (current != NULL)
    {
        if (strcmp(current->key, key) == 0)
        {
            // Update the value for an existing key
            free(current->value);
            current->value = strdup(value);
            return;
        }
        current = current->next;
    }

    // Insert the key-value pair into the table
    Node *node = malloc(sizeof(Node));
    node->key = strdup(key);
    node->value = strdup(value);
    node->next = table[index];
    table[index] = node;
}

// Get the value associated with a key from the hash table
char *get(char *key)
{
    unsigned int index = hash(key);

    // Search for the key in the table
    Node *current = table[index];
    while (current != NULL)
    {
        if (strcmp(current->key, key) == 0)
        {
            return current->value;
        }
        current = current->next;
    }

    // Key not found
    return NULL;
}

// Remove a key-value pair from the hash table
void remove_key(char *key)
{
    unsigned int index = hash(key);

    // Search for the key in the table
    Node *current = table[index];
    Node *prev = NULL;
    while (current != NULL)
    {
        if (strcmp(current->key, key) == 0)
        {
            if (prev == NULL)
            {
                // The key-value pair is the head of the linked list
                table[index] = current->next;
            }
            else
            {
                // The key-value pair is in the middle or end of the linked list
                prev->next = current->next;
            }
            free(current->key);
            free(current->value);
            free(current);
            return;
        }
        prev = current;
        current = current->next;
    }
}

// Traverse the hash table and print all key-value pairs
void traverse()
{
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        Node *current = table[i];
        while (current != NULL)
        {
            printf("%s: %s\n", current->key, current->value);
            current = current->next;
        }
    }
}

// Free the memory used by the hash table
void cleanup()
{
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        Node *current = table[i];
        while (current != NULL)
        {
            Node *next = current->next;
            free(current->key);
            free(current->value);
            free(current);
            current = next;
        }
        table[i] = NULL;
    }
}

//recursivly check for conflicts
char* check(char* key,char* key1) {
    char* value = get(key);

    if(get(value) == NULL || !strcmp(key,value) || !strcmp(key1,value)) {
        if(!strcmp(key1,value)) {
            remove_key(key);
            value = NULL;
        }
    }
    else {
        value = check(value,key1);
        if(value == NULL) {
            remove_key(key);
        }
    }
    return value;
}

//resolve conflict in hash_table
void resolve_conflict() {
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        Node *current = table[i];
        Node *next = NULL;
        while (current != NULL)
        {
            //dwell later into the error and work around for insert(current->key,check(current->key));
            /* printf("\nfirst check - %s : %s\n",current->key,check(current->key)); */
            next = current->next;
            char* value = check(current->key,current->key);
            if(value != NULL && strcmp(current->value,value) ) {
                insert(current->key,value);
            }
            current = next;
        }
    }
}