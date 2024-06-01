#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "syntax_tree.h"
#include<syntax_analyzer.h>

extern int lines;

extern FILE *yyin;
extern char *yytext;
extern int yylex();

// Mac-only hack.
YYSTYPE yylval;

int main(int argc, const char **argv) {
     if (argc != 2) {
          printf("usage: lexer input_file\n");
          return 0;
     }

     const char *input_file = argv[1];
     yyin = fopen(input_file, "r");
     if (!yyin) {
          fprintf(stderr, "cannot open file: %s\n", input_file);
          return 1;
     }

     int token;
    //  printf("%s\t%s\n", "Token", "Line");
     while ((token = yylex())) {
        //   printf("%s\t%d\n", yytext, lines);
     }
     return 0;
}
