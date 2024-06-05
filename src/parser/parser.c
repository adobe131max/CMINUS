#include "syntax_tree.h"

extern syntax_tree *parse(const char*, int* flex_error);

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
    int flex_error = 0;
    tree = parse(input, &flex_error);
    if (flex_error == 0) {
        print_syntax_tree(stdout, tree);
    }
    del_syntax_tree(tree);
    return 0;
}
