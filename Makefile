# Simuation options
sim_stop_time = 1ms

# Xilinx options
project    = Main
family     = spartan6
part       = xc6slx9-tqg144
top_module = Main

# Export variables
export

simulate :
	cd build/simu && $(MAKE)

xilinx :
	cd build/xilinx && $(MAKE)

clean:
	cd build/simu && $(MAKE) clean
	cd build/xilinx && $(MAKE) clean
