%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int found_sentence = 0; // Flag to track if the sentence has been found

%}

%union {
    char *sval;
}

%start program
%token <sval> TEXT

%type <sval> line


%%

program:
    | program line { /*printf("%s\n", $2); */
        // if(found_sentence == 0) {
        //     printf("%s\n", $2);
        // }
    } // Print each line of the input file
    ;

line:
    | TEXT '\n' { // Check if the sentence is found in this line
        if (strcmp($1, "This is the sentence to remove.") == 0) {
            found_sentence = 1; // Set flag if sentence is found
        } 
        else {
            printf("%s\n", $1); // Print line if sentence is not found
        }
    }
    ;

%%

int main() {

    yyparse(); // Start parsing the input file

    return 0;
}

int yyerror(char const *s) {
    printf("Syntax error: %s\n", s);
    return 0;
}
