%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin; 
extern int yylex();
extern int yylineno;
extern char *yytext;

void yyerror(const char *msg);
%}


%token TK_BEGIN TK_END RESERVED IDENTIFIER INT_CONST STRING
%token VAR INT CHAR CONST IF ELSE THEN DO WHILE FOR READ WRITE BOOL TRUE FALSE


%union {
    char *str_val;
    int int_val;
}


%type <str_val> IDENTIFIER STRING
%type <int_val> INT_CONST


%start program

%%

program
    : TK_BEGIN declarations statements TK_END
        { printf("Program parsed successfully!\n"); }
    ;

declarations
    : declarations declaration
        { printf("Parsed a declaration.\n"); }
    | /* empty */
        { printf("No declarations found.\n"); }
    ;

declaration
    : VAR IDENTIFIER ':' INT
        { printf("Declared variable: %s\n", $2); }
    ;

statements
    : statements statement
        { printf("Parsed a statement.\n"); }
    | /* empty */
        { printf("No statements found.\n"); }
    ;

statement
    : assignment ';'
        { printf("Parsed an assignment statement.\n"); }
    | io_statement ';'
        { printf("Parsed an I/O statement.\n"); }
    | conditional
        { printf("Parsed a conditional statement.\n"); }
    | loop
        { printf("Parsed a loop statement.\n"); }
    ;

assignment
    : IDENTIFIER '=' expression
        { printf("Assigned value to %s.\n", $1); }
    ;

io_statement
    : READ '(' IDENTIFIER ')'
        { printf("Read into variable: %s\n", $3); }
    | WRITE '(' expression ')'
        { printf("Wrote expression value.\n"); }
    ;

conditional
    : IF condition '{' statements '}'
        { printf("Parsed an if block.\n"); }
    | IF condition '{' statements '}' ELSE '{' statements '}'
        { printf("Parsed an if-else block.\n"); }
    ;

loop
    : WHILE condition '{' statements '}'
        { printf("Parsed a while loop.\n"); }
    ;

condition
    : expression comparison_op expression
        { printf("Parsed a condition.\n"); }
    ;

comparison_op
    : '<'
    | "!="
    | "<="
    | '>'
    | ">="
    | '='
    ;

expression
    : expression '+' term
        { printf("Parsed an addition expression.\n"); }
    | expression '-' term
        { printf("Parsed a subtraction expression.\n"); }
    | term
        { /* Single term */ }
    ;

term
    : term '*' factor
        { printf("Parsed a multiplication term.\n"); }
    | term '/' factor
        { printf("Parsed a division term.\n"); }
    | term '%' factor
        { printf("Parsed a modulo term.\n"); }
    | factor
        { /* Single factor */ }
    ;

factor
    : IDENTIFIER
        { printf("Parsed identifier: %s\n", $1); }
    | INT_CONST
        { printf("Parsed integer constant: %d\n", $1); }
    | '(' expression ')'
        { /* Grouped expression */ }
    ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, msg);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Unable to open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
