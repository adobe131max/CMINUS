%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

int lines;

void pass_node(char *text){
     yylval.node = new_syntax_tree_node(text);
}

/*****************声明和选项设置  end*****************/
%}

%%
" "                             ;
\n                              lines++;
";"                             return SEMI;
","                             return COMMA;
"="                             return ASSIGNOP;
"("                             return LBRACE;
")"                             return RBRACE;
int | float                     return TYPE;
[A-Za-z_]+[A-Za-z0-9_]*         pass_node(yytext); return ID;
void                            return VOID;
return                          return RETURN;
\+                              pass_node(yytext); return ADD;
.                               return ERROR;
%%
