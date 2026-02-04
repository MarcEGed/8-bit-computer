#include "tokenizer.h"
#include <ctype.h>
#include <string.h>
#include <stdio.h>

TokenList tokenize_line(const char *line) {
    TokenList list = { .count = 0 };
    int i = 0, j = 0;

    while (*line) {
        if (isspace(*line)){
            if (j > 0) {
                list.tokens[list.count][j] = '\0';
                list.count++;
                j = 0;
            }
        } else {
            if (j < MAX_TOKEN_LEN - 1)
                list.tokens[list.count][j++] = *line;
        }
        line++;
    }

    if (j > 0) {
        list.tokens[list.count][j] = '\0';
        list.count++;
    }

    return list;
}

void print_tokenlist(const TokenList *list) {
    printf("Tokens (%d):\n", list->count);
    for (int i = 0; i < list->count; i++) {
        printf("  [%d] \"%s\"\n", i, list->tokens[i]);
    }
}