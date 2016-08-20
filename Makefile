# Simuation options
test_target   = MainTest
sim_stop_time = 1ms

# Xilinx options
# variable	  description
# ----------  -------------
# top_module   Top level moduleof the project
# family       FPGA device family
# part         FPGA part name
# flashsize    Size of flash for mcs file
# ise_dir       Xilinx ISE directory. Format : /[your_path]/Xilinx/14.7/ISE_DS

top_module = Main
family     = spartan6
part       = xc6slx9-tqg144
flashsize  = 8192
ise_dir     = /vagrant/opt/Xilinx/14.7/ISE_DS

# Export variables
export

# Targets
simulate :
	cd build/simu && $(MAKE)

xilinx :
	cd build/xilinx && $(MAKE)

.PHONY : clean

clean:
	cd build/simu && $(MAKE) clean
	cd build/xilinx && $(MAKE) clean
