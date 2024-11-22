SOURCES = $(wildcard [1-9].c)
BINS = $(patsubst %.c, %.exe, $(SOURCES)) 

%.exe : %.c Makefile
	@echo "building $@"
	@gcc -g $< -lpthread -o $@

.PHONY: all
all : $(BINS)
	@

.PHONY: clean
clean:
	@rm *.exe
