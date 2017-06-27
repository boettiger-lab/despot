# -----------------------
# Compiler/linker options
# -----------------------

CXX = g++
LDFLAGS = -O3 -Wall -Wno-sign-compare $(GPROF)

# -----------
# Directories
# -----------

DESPOTHOME = ../..
SRCDIR = src
INCDIR = $(DESPOTHOME)/include
LIBDIR = $(DESPOTHOME)/build

# -----
# Files
# -----

SOURCES = $(shell find -L $(SRCDIR) -name '*.cpp')
BIN = pomdpx

# -------
# Targets
# -------

.PHONY: all clean

all:
	@cd $(DESPOTHOME) && make
	$(CXX) $(LDFLAGS) $(SOURCES) -I $(INCDIR) $(LIBDIR)/*.o -o $(BIN)

install:
	$(CXX) $(LDFLAGS) $(SOURCES) -I $(INCDIR) $(LIBDIR)/*.o -o $(BIN)
	mkdir ../../../bin
	mv pomdpx ../../../bin/
	
clean:
	rm -f $(BIN)
