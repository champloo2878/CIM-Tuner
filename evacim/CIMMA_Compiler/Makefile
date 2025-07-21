# Makefile

# Compiler and flags
CC=gcc
CFLAGS=-fdiagnostics-color=always -g -Wall

# Source files
SOURCES=compiler_count.c hw_config.c instruction_count.c inst_stack.c tensor_stack.c

# Object files
OBJECTS=$(SOURCES:.c=.o)

# Target executable
TARGET=compiler_count

# Default target
all: $(TARGET)

# Linking the target executable from the object files
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@ -lm

# # Compiling source files into object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Cleaning up the compilation products
clean:
	rm -f $(OBJECTS) $(TARGET)
