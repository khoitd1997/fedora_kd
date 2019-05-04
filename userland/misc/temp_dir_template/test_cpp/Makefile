EXEC=test.elf
CC=g++
CFLAGS= -std=c++17 -I. -Wall -fdiagnostics-color=always
# -Werror
LFLAGS=-I.

run: ${EXEC}
	./${EXEC}

#----------------------------------------------
# complete this part
%.o: %.cpp
	@$(CC) -c $< $(CFLAGS)
#----------------------------------------------

#----------------------------------------------
# complete this part
${EXEC}: main.o
	@$(CC) -o ${EXEC} $^ ${LFLAGS}

clean:
	rm -rf ./${EXEC}
	rm -rf ./*.o
