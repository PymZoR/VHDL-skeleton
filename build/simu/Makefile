# Sources directories
SDIR   = ../../src
TDIR   = ../../test

CC     = ghdl
CFLAGS = --ieee=synopsys -fexplicit

SIMU   = gtkwave
SFLAGS = --stop-time=$(sim_stop_time) --assert-level=error

SRC    = $(wildcard $(SDIR)/*.vhd)
OBJ    = $(notdir $(SRC:.vhd=.o))

all : $(test_target)

$(test_target) : $(OBJ) $(test_target).o
	$(CC) -e $(CFLAGS) -o $@.out $@
	./$@.out $(SFLAGS) --vcd=$@.vcd

%.o : $(SDIR)/%.vhd
	$(CC) -a $(CFLAGS) $<

$(test_target).o : $(TDIR)/$(test_target).vhd
	$(CC) -a $(CFLAGS) $<

$(TDIR)/%.o : $(TDIR)/%.vhd
	$(CC) -a $(CFLAGS) $<

.SECONDARY : $(OBJ)

.PHONY : clean

clean :
	rm -f *.o *.cf *.out
