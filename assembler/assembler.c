#include "parser.h"
#include "tokenizer.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LEN 256

static FILE *asm_file = NULL;

//open ASM file
int open_asm_file(const char *filename) {
    asm_file = fopen(filename, "r");
    if (!asm_file) {
        perror("Failed to open input file");
        return 0;
    }
    return 1;
}

char *trim(char *s) {
    while (isspace(*s)) s++;       //skip leading spaces
    if (*s == 0) return s;         //empty string

    char *end = s + strlen(s) - 1;
    while (end > s && isspace(*end)) end--; //remove trailing spaces
    end[1] = '\0';
    return s;
}

//read next line and strip newline
char *read_next_line(void) {
    static char buffer[MAX_LINE_LEN];
    if (!asm_file) return NULL;

    if (!fgets(buffer, sizeof(buffer), asm_file)) {
        return NULL;  //EOF
    }

    buffer[strcspn(buffer, "\r\n")] = 0; //strip newline
    return buffer;
}

//close ASM file
void close_asm_file(void) {
    if (asm_file) {
        fclose(asm_file);
        asm_file = NULL;
    }
}

int main(int argc, char *argv[]) {
    int binary_mode = 0;
    const char *infile = NULL;

    if (argc == 2) {
        infile = argv[1];
    } else if (argc == 3 && strcmp(argv[1], "-b") == 0) {
        binary_mode = 1;
        infile = argv[2];
    } else {
        printf("Usage: %s [-b] program.asm\n", argv[0]);
        return 1;
    }

    set_output_mode(binary_mode);

    if (!open_asm_file(infile)) return 1;

    char outname[256];
    strncpy(outname, infile, sizeof(outname));
    outname[sizeof(outname)-1] = '\0';

    char *dot = strrchr(outname, '.');
    if (dot) strcpy(dot, binary_mode ? ".bin.txt" : ".hex.txt");
    else strcat(outname, binary_mode ? ".bin.txt" : ".hex.txt");

    FILE *out = fopen(outname, "w");
    if (!out) {
        perror("Failed to open output file");
        close_asm_file();
        return 1;
    }

    char *line;
    while ((line = read_next_line()) != NULL) {
        line = trim(line);               //remove leading/trailing spaces 

        char *sc = strchr(line, ';');    //strip inline comment
        if (sc) *sc = '\0';

        line = trim(line);               //trim again after removing comment

        if (line[0] == '\0') continue;   //skip empty lines

        TokenList tokens = tokenize_line(line);
        parse_tokens_to_file(&tokens, out);
    }

    fclose(out);
    close_asm_file();

    printf("Assembled output written to: %s\n", outname);
    return 0;
}