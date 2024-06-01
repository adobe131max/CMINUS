%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "syntax_tree.h"

// external functions from lex
extern int yylex();
extern int yyparse();
extern int yyrestart();
extern FILE * yyin;

// external variables from lexical_analyzer module
extern int lines;
extern char * yytext;

// Global syntax tree
syntax_tree *gt;

// Error reporting
void yyerror(const char *s);

// Helper functions written for you with love
syntax_tree_node *node(const char *node_name, int children_num, ...);
%}

// 终结符
%token  SEMI
        COMMA
        ASSIGNOP
        RELOP
        PLUS
        MINUS
        start
        DIV
        AND
        OR
        DOT
        NOT
        LP
        LB
        LC
        RP
        RB
        RC
        TYPE
        STRUCT
        RETURN
        IF
        ELSE
        WHILE

// 数据类型定义
%union {
    syntax_tree_node *          node;
    char *                      string;
    int                         number;
    float                       floats;
}

// 重新token定义类型
%token <node>   ID
%token <number> INT
%token <floats> FLOAT
%token <node>   ERROR

// 非终结符
%type <node> Program
%type <node> ExtDefList
%type <node> ExtDef
%type <node> Specifier
%type <node> ExtDecList
%type <node> FunDec
%type <node> CompSt
%type <node> VarDec
%type <node> DefList

// 结合性与优先级
%left '+' '-'
%left '*' '/'

// 定义文法开始符号
%start Program

%%

Program:
    ExtDefList {
        $$ = node("Program", 1, $1);
        gt->root = $$;
    };

ExtDefList:
    ExtDef ExtDefList {
        $$ = node("ExtDefList", 2, $1, $2);
    }
    | {
        $$ = NULL;
    };

ExtDef:
    Specifier ExtDecList SEMI {

    }
    | Specifier SEMI {

    }
    | Specifier FunDec CompSt {

    };

ExtDecList:
    VarDec {

    }
    | VarDec COMMA ExtDecList {

    };

Specifier:
    TYPE {

    } 
    | StructSpecifier {

    };

StructSpecifier:
    STRUCT OptTag LC DefList RC {

    }
    | STRUCT Tag {

    };

OptTag:
    ID {

    }
    | {

    };

Tag:
    ID {

    };

%%

// 语法错误处理
void yyerror(const char * s) {
    fprintf(stderr, "Error type B at Line %d: %s.\n", lines, s);
}

/// Parse input from file `input_path`, and prints the parsing results
/// to stdout.  If input_path is NULL, read from stdin.
///
/// This function initializes essential states before running yyparse().
syntax_tree *parse(const char *input_path) {
    if (input_path != NULL) {
        if (!(yyin = fopen(input_path, "r"))) {
            fprintf(stderr, "[ERR] Open input file %s failed.\n", input_path);
            exit(1);
        }
    } else {
        yyin = stdin;
    }

    lines = 1;
    gt = new_syntax_tree();
    yyrestart(yyin);
    yyparse();
    return gt;
}

// A helper function to quickly construct a tree node.
syntax_tree_node *node(const char *name, int children_num, ...) {
    syntax_tree_node *p = new_syntax_tree_node(name);
    syntax_tree_node *child;
    if (children_num == 0) {
        child = new_syntax_tree_node("epsilon");
        syntax_tree_add_child(p, child);
    } else {
        va_list ap;
        va_start(ap, children_num);
        for (int i = 0; i < children_num; ++i) {
            child = va_arg(ap, syntax_tree_node *);
            syntax_tree_add_child(p, child);
        }
        va_end(ap);
    }
    return p;
}
