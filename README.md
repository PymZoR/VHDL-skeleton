# VHDL-skeleton
Basic project structure for VHDL projects.

## Folder structure
```
├── Makefile (Exports all targets)
├── build
│   ├── simu   (Simulation output)
│   │   ├── MainTest.vcd (MainTest output)
│   │   └── Makefile
│   └── xilinx (XST working directory)
|    |  ├── Main.ucf     (Constraints file)
|    |  ├── xilinx.opt   (XST options)
|    |  ├── Main.bit     (XST output)
|    |  ├── Main.mcs     (XST output)
|    |  └── Makefile
├── src
    └── Main.vhd (Top module)
└── test
    └── MainTest.vhd (Top module testbench)
```

## Dependencies

### Testbench simulation
* GHDL
* GTKWave

### Xilinx FPGAs
* Xilinx ISE  

Make sure the `ise_dir` variable of the [root Makefile](/Makefile#18) correctly point to your Xilinx ISE installation path.  
## Usage
First, clone the base structure  
`$ git clone https://github.com/PymZoR/VHDL-skeleton`

Copy your sources files in the `src` directory, and your test files in the `test` directory.

### Testing the design
`$ make simulate [test_target=testName] [sim_stop_time=X]&& gtkwave build/[testName].vcd`  

By default, `test_target` is `MainTest`, and the `sim_stop_time` is `1ms`. It can be changed in the [root Makefile](/Makefile)

### Building with Xilinx ISE
Set your top module name, FPGA family / part, and flash size in the [root Makefile](/Makefile). You're good to go !  

`$ make xilinx`

## Features / TODO
- [x] One makefile to rule 'em all
- [ ] Support external libraries
- [x] GHDL
- [ ] Flash with iMPACT
- [x] Xilinx
- [ ] Altera
- [ ] Other FPGA vendor

## Sources
Thanks to excamera for the original [minimal Makefile for Xilinx WebPack](http://excamera.com/sphinx/fpga-makefile.html).

## Contributing
If you have made a makefile for an other FPGA vendor, or have any suggestions regarding the current ones, feel free to open an issue and/or a pull request.
