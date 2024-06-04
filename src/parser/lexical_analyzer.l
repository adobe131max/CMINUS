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
ID              [A-Za-z_]+[A-Za-z0-9_]*

%%
" "                                 ;
\n                                  lines++;/*printf("\n");*/
";"                                 RETURN_TOKEN(SEMI);
","                                 RETURN_TOKEN(COMMA);
"="                                 RETURN_TOKEN(ASSIGNOP);
"+"                                 RETURN_TOKEN(PLUS);
"-"                                 RETURN_TOKEN(MINUS);
"*"                                 RETURN_TOKEN(STAR);
"/"                                 RETURN_TOKEN(DIV);
"&&"                                RETURN_TOKEN(AND);
"||"                                RETURN_TOKEN(OR);
{DOT}                               RETURN_TOKEN(DOT);
"!"                                 RETURN_TOKEN(NOT);
"("                                 RETURN_TOKEN(LP);
")"                                 RETURN_TOKEN(RP);
"["                                 RETURN_TOKEN(LB);
"]"                                 RETURN_TOKEN(RB);
"{"                                 RETURN_TOKEN(LC);
"}"                                 RETURN_TOKEN(RC);
struct                              RETURN_TOKEN(STRUCT);
return                              RETURN_TOKEN(RETURN);
if                                  RETURN_TOKEN(IF);
else                                RETURN_TOKEN(ELSE);
while                               RETURN_TOKEN(WHILE);

int  |
float                               RETURN_TOKEN(TYPE);

">"  |
"<"  |
">=" |
"<=" |
"==" |
"!="                                RETURN_TOKEN(RELOP);

{ID}                                yylval.string = strdup(yytext); RETURN_TOKEN(ID);

0           |
[1-9][0-9]* |
0[0-7]+     |
0[xX][0-9a-fA-F]+                   yylval.number = atoi(yytext); RETURN_TOKEN(INT);
     
[0-9]+\.[0-9]+          |
\.[0-9]+[eE][+-]?[0-9]+ |
[0-9]+\.[0-9]*[eE][+-]?[0-9]+       yylval.floats = (float)atof(yytext); RETURN_TOKEN(FLOAT);

\/\/[^\n]*  |
\/\*([^*]|\*+[^*/])*\*+\/           ;/*comment*/

0[0-9]+ |
0[xX][0-9a-xA-X]+                   printf("Error type A at Line %d: invalid int \"%s\".\n", lines, yytext);/*捕获错误的数字，而不是识别成两个int*/

[0-9]*\. |
\.[0-9]* |
[0-9]+\.[0-9]*[eE]                  printf("Error type A at Line %d: invalid float \"%s\".\n", lines, yytext);

"*/"                                printf("Error type A at Line %d: invalid comment \"%s\".\n", lines, yytext);

.                                   printf("Error type A at Line %d: Mysterious character \"%s\".\n", lines, yytext);
%%
