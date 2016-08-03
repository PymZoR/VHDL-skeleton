# Sources directories
SDIR   = ../../src
TDIR   = ../../test

CC     = ghdl
CFLAGS = --ieee=synopsys -fexplicit

SIMU   = gtkwave
SFLAGS = --stop-time=$(sim_stop_time) --assert-level=error

SRC    = $(wildcard $(SDIR)/*.vhd)
OBJ    = $(notdir $(SRC:.vhd=.o))

# Build MainTest by default
all : MainTest

# Any test can be built
% : $(OBJ) ./%.o
	$(CC) -e $(CFLAGS) -o $@.out $@
	./$@.out $(SFLAGS) --vcd=$@.vcd

%.o : $(SDIR)/%.vhd
	$(CC) -a $(CFLAGS) $<

# Trick : `./` is the testBench .o flag to trigger this rule
./%.o : $(TDIR)/%.vhd
	$(CC) -a $(CFLAGS) $<

$(TDIR)/%.o : $(TDIR)/%.vhd
	$(CC) -a $(CFLAGS) $<

.SECONDARY : $(OBJ)

.PHONY : clean makeDir

clean :
	rm -f *.o *.cf *.out
