CC=gcc
CFLAGS=-I.
LDFLAGS=
EXEC=hello

all: $(EXEC)

hello: main.o
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -rf *.o

mrproper: clean
	rm -rf $(EXEC)
