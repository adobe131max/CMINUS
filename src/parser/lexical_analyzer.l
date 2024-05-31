%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

int lines;
int pos_start;
int pos_end;

void pass_node(char *text){
     yylval.node = new_syntax_tree_node(text);
}

/*****************声明和选项设置  end*****************/
%}


%%
" "     { pos_end++; }
"("     { pos_start = pos_end; pos_end++; return LBRACE; }
")"     { pos_start = pos_end; pos_end++; return RBRACE; }
\+      { pos_start = pos_end; pos_end++; pass_node(yytext); return ADD; }
.       { pos_start = pos_end; pos_end++; return ERROR; }
%%
