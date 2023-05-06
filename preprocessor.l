%{
#include "y.tab.h"
%}

%%

\n          { return yytext[0]; } // Return newline character
[^\n]+      { yylval.sval = strdup(yytext); return TEXT; } // Return entire line as TEXT token

%%
