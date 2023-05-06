%{
#include "y.tab.h"
%}

variable            [0-9a-zA-Z_(){}\[\];<>=.!+\-*/;]+

%%

#define             {return DEFINE;}
{variable}          {return IDENTIFIER;}
[\t]+               {return TAB;}
[ ]+                ;
\n                  {return NEWLINE; } // Return newline character
<<EOF>>             {return END;}

%%

int yywrap(void) {
    return 1;
}