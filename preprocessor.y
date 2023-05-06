%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    extern char* yytext;
    extern FILE* yyin;
    void into_key();
    void into_value();
    int yyerror(char *s);
    void replace();
    void resolve_conflict();


    int found_sentence = 0; // Flag to track if the sentence has been found
%}
%union {
    char *sval;
}

%start file
%token DEFINE IDENTIFIER END NEWLINE TAB 

%%
file                :  END | define S1 | id S2 | newline file

S1                  :  define S1 | id {/*printf("called5\n");*/resolve_conflict();} S2  | newline S1 | END
S2                  :  id S2 | define S1| newline S2 | END

define              : DEFINE IDENTIFIER{into_key();} IDENTIFIER{into_value();} 
                    ;

id                  : IDENTIFIER{/*printf("called8\n");*/replace(yytext);}
                    ;
newline             : NEWLINE {printf("\n");}
                    | TAB {printf("\t");}
                    ;

%%
#include "function.h"

//insert key from CFG to HashTable
void into_key() {
    strcpy(temp_key,yytext);
}
//insert value from CFG to HashTable
void into_value() {
    strcpy(temp_value,yytext);
    insert(temp_key,temp_value);
}
//check and replace IDENTIFIER with REPLACEMENT (value)
void replace(char* yytext) {
    if(get(yytext) != NULL) {
        printf("%s ",get(yytext));
    }
    else {
        printf("%s ",yytext);
    }
}


int yyerror(char *s) {
    //fprintf(stderr, "do something about it : %s\n", s);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    char* input_file_name;
    input_file_name = argv[1]; // Store the input file name in the global variable

    FILE* input_file = fopen(input_file_name, "r");
    if (input_file == NULL) {
        printf("Failed to open input file %s\n", input_file_name);
        return 1;
    }

    // Parse the input file
    yyin = input_file;
    yyparse();
    fclose(input_file);

    //conflicts
    //resolve_conflict();

    //traverse and print
    //traverse();
    
    //clearing map
    cleanup();
    return 0;
}



