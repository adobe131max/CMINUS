#ifndef __SYNTAXTREE_H__
#define __SYNTAXTREE_H__

#include <stdio.h>

#define SYNTAX_TREE_NODE_NAME_MAX 30
#define SYNTAX_TREE_NODE_ID_MAX 30

enum Value_type_t { NON_TYPE, INT_TYPE, FLOAT_TYPE, STRING_TYPE };

struct _syntax_tree_node {
	struct _syntax_tree_node * parent;
	struct _syntax_tree_node * children[10];
	int children_num;
	char name[SYNTAX_TREE_NODE_NAME_MAX];
    int line;
    enum Value_type_t value_type;
    int int_value;
    float float_value;
    char str_value[SYNTAX_TREE_NODE_ID_MAX];
};
typedef struct _syntax_tree_node syntax_tree_node;

syntax_tree_node * new_anon_syntax_tree_node();

syntax_tree_node * new_syntax_tree_node(const char * name, int line);

syntax_tree_node * new_syntax_tree_node_id(const char * name, int line, const char * id);

syntax_tree_node * new_syntax_tree_node_int(const char * name, int line, int val);

syntax_tree_node * new_syntax_tree_node_float(const char * name, int line, float val);

int syntax_tree_add_child(syntax_tree_node * parent, syntax_tree_node * child);

void del_syntax_tree_node(syntax_tree_node * node, int recursive);

struct _syntax_tree {
	syntax_tree_node * root;
};
typedef struct _syntax_tree syntax_tree;

syntax_tree* new_syntax_tree();

void del_syntax_tree(syntax_tree * tree);

void print_syntax_tree(FILE * fout, syntax_tree * tree);

#endif /* SyntaxTree.h */
