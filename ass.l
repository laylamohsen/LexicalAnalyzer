%{
#include <stdio.h>
#include <string.h>
int line_count = 1;

%}

KEYWORD     (else|if|int|return|void|while)
SPECIAL_SYMBOL ("*"|"/"|"<"|"<="|">"|">="|"=="|"!="|"="|";"|","|"("|")"|"["|"]"|"{"|"}"|"/*"|"*/")
NON_ALPHA      ("`"|"!"|"@"|"#"|"%"|"$"|"?"|":"|"*"|"^"|"~"|"/")
DIGIT        [0-9]
LETTER       [a-zA-Z]
DOT          "."
HASH         "#"
DOLLAR_SIGN  "$"
UNDER_SCORE  "_"
EXP          "E"
exp          "e"
PLUS_OP      "+"
HYPHEN       "-"
COMMENT       "/*"([^*]|"*"+[^*/])*"*"+"/"
ECOMMENT      "/"([^*]|("*"+[^*/]))*


%%
{ECOMMENT} {printf("ERROR (1) Unclosed comment in line %d\n", line_count);}
{COMMENT} {printf("COMMENT: %s\n", yytext);}
{KEYWORD} { printf("KEYWORD: %s\n", yytext); }
{SPECIAL_SYMBOL} { printf("SPECIAL SYMBOL: %s\n", yytext); }
{LETTER}({LETTER}|{DIGIT})*(({DOT}|{HASH}|{DOLLAR_SIGN}|{UNDER_SCORE})?({LETTER}|{DIGIT}+))? {  printf("ID: %s\n", yytext); }
({DIGIT}+|{DIGIT}+{DOT}{DIGIT}*)(({EXP}|{exp})({PLUS_OP}|{HYPHEN})?{DIGIT}+)?              { printf("NUM: %s\n", yytext); }
{LETTER}({LETTER}|{DIGIT})*(({DOT}|{HASH}|{DOLLAR_SIGN}|{UNDER_SCORE}|{NON_ALPHA})[^a-zA-Z0-9])* {printf("ERROR (3) Wrong identfier in line %d : %s\n", line_count , yytext); }
({DIGIT}+|{DIGIT}+{DOT}{DIGIT}*)(({EXP}|{exp})({PLUS_OP}|{HYPHEN})[^0-9])* {printf("ERROR (4) Wrong number in line %d : %s\n", line_count , yytext) ;line_count++ ;}
{NON_ALPHA}         { printf("ERROR (2) Charcter is not in the alphabet in line %d : %s\n", line_count ,yytext);}
\n          { line_count++; } // Increment line count and character count on encountering a newline

%%
int main() {
    char input[10000];
    printf("Enter input: ");
    scanf("%s" , input);
    yyin = fopen (input , "r"); // Pass the input to the lexer
    if (yyin == NULL) {
        printf("Error opening the file. Please check the file path.\n");
        return 1;
    }
    yylex();
    printf("Total lines: %d\n", line_count );
    return 0;
}

int yywrap()
{
 return 1;
}
