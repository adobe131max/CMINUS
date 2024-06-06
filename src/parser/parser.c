#include "syntax_tree.h"

extern syntax_tree *parse(const char*, int* flex_error);
extern void print_e(const char* s);

int main(int argc, char *argv[])
{
    syntax_tree *tree = NULL;
    const char *input = NULL;

    if (argc == 2) {
        input = argv[1];
    } else if(argc >= 3) {
        printf("usage: %s <cminus_file>\n", argv[0]);
        return 1;
    }

    // Call the syntax analyzer.
    int error_ = 0;
    tree = parse(input, &error_);
    if (error_ == 0) {
        print_syntax_tree(stdout, tree);
    } else if (error_ == 2) {
        print_e("syntax error");
    }
    del_syntax_tree(tree);
    return 0;
}
