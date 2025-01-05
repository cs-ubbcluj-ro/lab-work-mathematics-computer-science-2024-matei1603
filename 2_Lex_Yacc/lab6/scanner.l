%{
#include "parser.tab.h"  // Include tokens defined by the parser
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylineno;  // Line number tracking
extern char *yytext;  // Current matched text
%}

DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT}|_)*
RESERVED    (var|int|char|const|if|else|then|do|while|for|read|write|bool|true|false)
OPERATOR    (\+|\-|\*|\/|:=|<|<=|=|>=|>|%)
SEPARATOR   (\[|\]|\{|\}|:|\(|\)|;)
STRING      \"[^\"]*\"
COMMENT     \/\/[^\n]*

%%

"begin"            { return TK_BEGIN; }
"end"              { return TK_END; }
{RESERVED}         { return RESERVED; }
{IDENTIFIER}       { yylval.str_val = strdup(yytext); return IDENTIFIER; }
{DIGIT}+           { yylval.int_val = atoi(yytext); return INT_CONST; }
{STRING}           { yylval.str_val = strdup(yytext); return STRING; }
{OPERATOR}         { return yytext[0]; }
{SEPARATOR}        { return yytext[0]; }
{COMMENT}          { /* Ignore comments */ }
\n                 { yylineno++; }
[ \t\r]+           { /* Ignore whitespace */ }
.                  { printf("Lexical error at line %d: %s\n", yylineno, yytext); }

%%

int yywrap() {
    return 1;
}
