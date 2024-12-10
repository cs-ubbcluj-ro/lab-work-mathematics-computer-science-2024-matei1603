%{
#include <stdio.h>
#include <stdlib.h>

// Declare yyin to allow input redirection for yylex
extern FILE *yyin;

// Function declarations
void yyerror(const char *msg);
extern int yylex();
extern int yylineno; // Line number
%}

// Tokens from Lex
%token INT FLOAT STRUCT IF ELSE WHILE DO THEN VAR READ WRITE BEGIN END
%token ID STRING OPERATOR REL_OP SEP ASSIGN
%token NUM LE EQ GE NE // Add missing tokens

// Precedence and associativity for operators
%left ELSE // Handle "else" ambiguity with precedence
%left '+' '-'
%left '*' '/' '%'

// Grammar Rules
%%
program:
    declarations statements { printf("Program syntactic correct\n"); }
    ;

declarations:
    declarations declaration
    | /* epsilon */
    ;

declaration:
    INT ID ';' 
    | FLOAT ID ';'
    | STRUCT ID '{' declarations '}' ';'
    ;

statements:
    statements statement
    | /* epsilon */
    ;

statement:
    assignment
    | if_statement
    | while_statement
    | read_statement
    | write_statement
    | compound_statement
    ;

assignment:
    ID ASSIGN expression ';' 
    ;

if_statement:
    IF '(' condition ')' THEN statement
    | IF '(' condition ')' THEN statement ELSE statement
    ;

while_statement:
    WHILE '(' condition ')' statement
    ;

read_statement:
    READ ID ';'
    ;

write_statement:
    WRITE expression ';'
    ;

compound_statement:
    BEGIN statements END
    ;

expression:
    term expression_prime
    ;

expression_prime:
    '+' term expression_prime
    | '-' term expression_prime
    | /* epsilon */
    ;

term:
    factor term_prime
    ;

term_prime:
    '*' factor term_prime
    | '/' factor term_prime
    | '%' factor term_prime
    | /* epsilon */
    ;

factor:
    ID
    | NUM
    | '(' expression ')'
    ;

condition:
    expression relational_operator expression
    ;

relational_operator:
    '<'
    | LE
    | EQ
    | GE
    | '>'
    | NE
    ;
%%

// Error handler
void yyerror(const char *msg) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, msg);
}

// Main function
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file; // Assign input file to yyin
    }
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
