# output: a.out 
# 	./preprocessor.out input.c
a.out: y.tab.c
	gcc y.tab.c lex.yy.c -ll -lfl -o preprocessor.out
y.tab.c: lex.yy.c
	yacc -d preprocessor.y 
lex.yy.c: preprocessor.l
	lex preprocessor.l
clean:
	rm lex.yy.c y.tab.c y.tab.h *.out
lex: lex.yy.c
yacc: y.tab.c
