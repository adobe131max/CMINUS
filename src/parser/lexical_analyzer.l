%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

int lines = 1;
int error = 0;

void pass_node(char *text, int line){
     yylval.node = new_syntax_tree_node(text, line);
}

void pass_id_node(char *text, int line, char *id){
     yylval.node = new_syntax_tree_node_id(text, line, id);
}

void pass_int_node(char *text, int line, int val){
     yylval.node = new_syntax_tree_node_int(text, line, val);
}

void pass_float_node(char *text, int line, float val){
     yylval.node = new_syntax_tree_node_float(text, line, val);
}

#define RETURN_TOKEN(token) /*printf("%s ", #token);*/pass_node(#token, lines);return token
#define RETURN_ID(token)    /*printf("%s ", #token);*/pass_id_node(#token, lines, yytext);return token
#define RETURN_INT(token)   /*printf("%s ", #token);*/pass_int_node(#token, lines, atoi(yytext));return token
#define RETURN_FLOAT(token) /*printf("%s ", #token);*/pass_float_node(#token, lines, atof(yytext));return token

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

int                                 pass_node("TYPE: int", lines);return TYPE;/*要求返回TYPE，但我觉得词法返回INT和FLOAT更好*/
float                               pass_node("TYPE: float", lines);return TYPE;/*规则就是这么输出*/

">"  |
"<"  |
">=" |
"<=" |
"==" |
"!="                                RETURN_TOKEN(RELOP);

{ID}                                RETURN_ID(ID);

0           |
[1-9][0-9]* |
0[0-7]+     |
0[xX][0-9a-fA-F]+                   RETURN_INT(INT);
     
[0-9]+\.[0-9]+          |
\.[0-9]+[eE][+-]?[0-9]+ |
[0-9]+\.[0-9]*[eE][+-]?[0-9]+       RETURN_FLOAT(FLOAT);

\/\/[^\n]*  |
\/\*([^*]|\*+[^*/])*\*+\/           ;/*comment*/

0[0-9]+ |
0[xX][0-9a-xA-X]+                   error=1;printf("Error type A at Line %d: invalid int \"%s\".\n", lines, yytext);pass_int_node("INT", lines, 0);return INT;/*捕获错误的数字，而不是识别成两个int*/

[0-9]*\. |
\.[0-9]* |
[0-9]+\.[0-9]*[eE]                  error=1;printf("Error type A at Line %d: invalid float \"%s\".\n", lines, yytext);pass_float_node("FLOAT", lines, 0.0);return FLOAT;

"*/"                                error=1;printf("Error type A at Line %d: invalid comment \"%s\".\n", lines, yytext);

.                                   error=1;printf("Error type A at Line %d: Mysterious character \"%s\".\n", lines, yytext);
%%
