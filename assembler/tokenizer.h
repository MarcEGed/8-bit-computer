#ifndef TOKENIZER_H
#define TOKENIZER_H

#define MAX_TOKENS 16
#define MAX_TOKEN_LEN 32

typedef struct {
    char tokens[MAX_TOKENS][MAX_TOKEN_LEN];
    int count;
} TokenList;

TokenList tokenize_line(const char *line);
void print_tokenlist(const TokenList *list);

#endif
