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

// #define RETURN_TOKEN(token) printf("%s ", #token);return token   // 不太明白为什么写成这样就可以输出token，#token是什么？
#define RETURN_TOKEN(token) return token

%}

DOT             \.
DIGIT           [0-9]
INT             [\-]?{DIGIT}+
FLOAT           [\-]?{DIGIT}+{DOT}{DIGIT}+
ID              [A-Za-z_]+[A-Za-z0-9_]*
COMMENT         [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]

%%
" "                                     ;
{COMMENT}                               ;
\n                                      lines++;/*printf("\n");*/
";"                                     RETURN_TOKEN(SEMI);
","                                     RETURN_TOKEN(COMMA);
"="                                     RETURN_TOKEN(ASSIGNOP);
"+"                                     RETURN_TOKEN(PLUS);
"-"                                     RETURN_TOKEN(MINUS);
"*"                                     RETURN_TOKEN(STAR);
"/"                                     RETURN_TOKEN(DIV);
"&&"                                    RETURN_TOKEN(AND);
"||"                                    RETURN_TOKEN(OR);
{DOT}                                   RETURN_TOKEN(DOT);
"!"                                     RETURN_TOKEN(NOT);
"("                                     RETURN_TOKEN(LP);
")"                                     RETURN_TOKEN(RP);
"["                                     RETURN_TOKEN(LB);
"]"                                     RETURN_TOKEN(RB);
"{"                                     RETURN_TOKEN(LC);
"}"                                     RETURN_TOKEN(RC);
struct                                  RETURN_TOKEN(STRUCT);
return                                  RETURN_TOKEN(RETURN);
if                                      RETURN_TOKEN(IF);
else                                    RETURN_TOKEN(ELSE);
while                                   RETURN_TOKEN(WHILE);

int  |
float                                   RETURN_TOKEN(TYPE); /*不能写在一行，否则无法识别*/

">"  |
"<"  |
">=" |
"<=" |
"==" |
"!="                                    RETURN_TOKEN(RELOP);

{ID}                                    yylval.string = strdup(yytext); RETURN_TOKEN(ID);
{INT}                                   yylval.number = atoi(yytext); RETURN_TOKEN(INT);
{FLOAT}                                 yylval.floats = (float)atof(yytext); RETURN_TOKEN(FLOAT);

.                                       printf("Error type A at Line %d: Mysterious character \"%s\".\n", lines, yytext);
%%
