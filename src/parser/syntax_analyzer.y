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
extern int error;
extern char * yytext;

// Global syntax tree
syntax_tree *gt;

// Error reporting
void yyerror(const char* s);
void print_e(const char* s);

// Helper functions written for you with love
syntax_tree_node *node(const char *node_name, int children_num, ...);
%}

// 数据类型定义
%union {
    syntax_tree_node *          node;
}

// 终结符
// 重新token定义类型
%token <node> ID
%token <node> INT
%token <node> FLOAT
%token <node> SEMI
%token <node> COMMA
%token <node> ASSIGNOP
%token <node> RELOP
%token <node> PLUS
%token <node> MINUS
%token <node> UMINUS
%token <node> STAR
%token <node> DIV
%token <node> AND
%token <node> OR
%token <node> DOT
%token <node> NOT
%token <node> LP
%token <node> LB
%token <node> LC
%token <node> RP
%token <node> RB
%token <node> RC
%token <node> TYPE
%token <node> STRUCT
%token <node> RETURN
%token <node> IF
%token <node> ELSE
%token <node> WHILE

// 非终结符
%type <node> Program
%type <node> ExtDefList
%type <node> ExtDef
%type <node> Specifier
%type <node> ExtDecList
%type <node> StructSpecifier
%type <node> OptTag
%type <node> Tag
%type <node> VarDec
%type <node> DefList
%type <node> FunDec
%type <node> CompSt
%type <node> VarList
%type <node> ParamDec
%type <node> StmtList
%type <node> Stmt
%type <node> Def
%type <node> DecList
%type <node> Dec
%type <node> Exp
%type <node> Args

// 结合性与优先级
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right UMINUS NOT
%left LP RP LB RB DOT

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
        $$ = node("ExtDef", 3, $1, $2, $3);
    }
    | Specifier SEMI {
        $$ = node("ExtDef", 2, $1, $2);
    }
    | Specifier FunDec CompSt {
        $$ = node("ExtDef", 3, $1, $2, $3);
    };

ExtDecList:
    VarDec {
        $$ = node("ExtDecList", 1, $1);
    }
    | VarDec COMMA ExtDecList {
        $$ = node("ExtDecList", 3, $1, $2, $3);
    };

Specifier:
    TYPE {
        $$ = node("Specifier", 1, $1);
    } 
    | StructSpecifier {
        $$ = node("Specifier", 1, $1);
    };

StructSpecifier:
    STRUCT OptTag LC DefList RC {
        $$ = node("StructSpecifier", 5, $1, $2, $3, $4, $5);
    }
    | STRUCT Tag {
        $$ = node("StructSpecifier", 2, $1, $2);
    };

OptTag:
    ID {
        $$ = node("OptTag", 1, $1);
    }
    | {
        $$ = NULL;
    };

Tag:
    ID {
        $$ = node("Tag", 1, $1);
    };

VarDec:
    ID {
        $$ = node("VarDec", 1, $1);
    } 
    | VarDec LB INT RB {
        $$ = node("VarDec", 4, $1, $2, $3, $4);
    };

FunDec:
    ID LP VarList RP {
        $$ = node("FunDec", 4, $1, $2, $3, $4);
    }
    | ID LP RP {
        $$ = node("FunDec", 3, $1, $2, $3);
    };

VarList:
    ParamDec COMMA VarList {
        $$ = node("VarList", 3, $1, $2, $3);
    }
    | ParamDec {
        $$ = node("VarList", 1, $1);
    };

ParamDec:
    Specifier VarDec {
        $$ = node("Param", 2, $1, $2);
    };

CompSt:
    LC DefList StmtList RC {
        $$ = node("CompSt", 4, $1, $2, $3, $4);
    };

StmtList:
    Stmt StmtList {
        $$ = node("StmtList", 2, $1, $2);
    }
    | {
        $$ = NULL;
    };

Stmt:
    Exp SEMI {
        $$ = node("Stmt", 2, $1, $2);
    }
    | CompSt {
        $$ = node("Stmt", 1, $1);
    }
    | RETURN Exp SEMI {
        $$ = node("Stmt", 3, $1, $2, $3);
    }
    | IF LP Exp RP Stmt {
        $$ = node("Stmt", 5, $1, $2, $3, $4, $5);
    }
    | IF LP Exp RP Stmt ELSE Stmt {
        $$ = node("Stmt", 7, $1, $2, $3, $4, $5, $6, $7);
    }
    | WHILE LP Exp RP Stmt {
        $$ = node("Stmt", 5, $1, $2, $3, $4, $5);
    }
    | IF LP Exp RP error Stmt {
        print_e("Missing \";\"");
    };

DefList:
    Def DefList {
        $$ = node("DefList", 2, $1, $2);
    }
    | {
        $$ = NULL;
    };

Def:
    Specifier DecList SEMI {
        $$ = node("Def", 3, $1, $2, $3);
    };

DecList:
    Dec {
        $$ = node("DecList", 1, $1);
    }
    | Dec COMMA DecList {
        $$ = node("DecList", 3, $1, $2, $3);
    };

Dec:
    VarDec {
        $$ = node("Dec", 1, $1);
    }
    | VarDec ASSIGNOP Exp {
        $$ = node("Dec", 3, $1, $2, $3);
    };

Exp:
    Exp ASSIGNOP Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp AND Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp OR Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp RELOP Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp PLUS Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp MINUS Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp STAR Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp DIV Exp {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | LP Exp RP {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | MINUS Exp %prec UMINUS {  // %prec UMINUS: 使用UMINUS的优先级与结合性
        $$ = node("Exp", 2, $1, $2);
    }
    | NOT Exp {
        $$ = node("Exp", 2, $1, $2);
    }
    | ID LP Args RP {
        $$ = node("Exp", 4, $1, $2, $3, $4);
    }
    | ID LP RP {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | Exp LB Exp RB {
        $$ = node("Exp", 4, $1, $2, $3, $4);
    }
    | Exp DOT ID {
        $$ = node("Exp", 3, $1, $2, $3);
    }
    | ID {
        $$ = node("Exp", 1, $1);
    }
    | INT {
        $$ = node("Exp", 1, $1);
    }
    | FLOAT {
        $$ = node("Exp", 1, $1);
    }
    | Exp LB Exp error RB {
        print_e("Missing \"]\"");
    }

Args:
    Exp COMMA Args {
        $$ = node("Args", 3, $1, $2, $3);
    }
    | Exp {
        $$ = node("Args", 1, $1);
    };

%%

// 语法错误处理
void yyerror(const char * s) {
    error = 2;
    /* fprintf(stderr, "Error type B at Line %d: %s.\n", lines, s); */
}

void print_e(const char* s) {
    error = 3;
    fprintf(stderr, "Error type B at Line %d: %s.\n", lines, s);
}

/// Parse input from file `input_path`, and prints the parsing results
/// to stdout.  If input_path is NULL, read from stdin.
///
/// This function initializes essential states before running yyparse().
syntax_tree *parse(const char *input_path, int* error_) {
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
    *error_ = error;
    return gt;
}

// A helper function to quickly construct a tree node.
syntax_tree_node *node(const char *name, int children_num, ...) {
    syntax_tree_node *p = new_syntax_tree_node(name, 0);
    syntax_tree_node *child;
    if (children_num == 0) {
        child = new_syntax_tree_node("epsilon", 0);
        syntax_tree_add_child(p, child);
    } else {
        va_list ap;
        va_start(ap, children_num);
        int line = 0x7fffffff;
        for (int i = 0; i < children_num; ++i) {
            child = va_arg(ap, syntax_tree_node *);
            if (child && child->line < line) {
                line = child->line;
            }
            syntax_tree_add_child(p, child);
        }
        p->line = line;
        va_end(ap);
    }
    return p;
}
