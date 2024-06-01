%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

int lines = 1;

void pass_node(char *text){
     yylval.node = new_syntax_tree_node(text);
}
%}

DOT             \.
LETTER          [a-zA-Z]
DIGIT           [0-9]
INT             [\-]?{DIGIT}+
FLOAT           [\-]?{DIGIT}+{DOT}{DIGIT}+
ID              [A-Za-z_]+[A-Za-z0-9_]*
COMMENT         [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]
COMMENT_BEGIN   "/*"
COMMENT_END     "*/"

%%
" "                             ;
{COMMENT}                       ;
\n                              lines++;
";"                             return SEMI;
","                             return COMMA;
"="                             return ASSIGNOP;
"<"                             return LT;
"<="                            return LE;
">"                             return GT;
">="                            return GE;
"=="                            return EQ;
"!="                            return NE;
"&&"                            return AND;
"||"                            return OR;
{DOT}                           return DOT;
"!"                             return NOT;
"("                             return LBRA;
")"                             return RBRA;
"["                             return LMBRA;
"]"                             return RMBRA;
"{"                             return LLBRA;
"}"                             return RLBRA;

"+" |
"-" |
"*" |                            
"/"                             return yytext[0];

int                             return INT_T;
float                           return FLOAT_T;
struct                          return STRUCT;
return                          return RETURN;
if                              return IF;
else                            return ELSE;
while                           return WHILE;

{ID}                            yylval.string = strdup(yytext); return ID;
{INT}                           yylval.number = atoi(yytext); return INT;
{FLOAT}                         yylval.floats = (float)atof(yytext); return FLOAT;

.                               printf("Error type A at Line %d: Mysterious character \"%s\".\n", lines, yytext); return ERROR;
%%
