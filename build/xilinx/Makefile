#   variable	description
#   ----------  -------------

#   libdir	     path to library directory
#   libs	     library modules used
#   vfiles	     all local .vhd files
#   xilinx_cores all local .xco files

#   optfile      (optional) xst extra opttions file to put in .scr
#   map_opts     (optional) options to give to map
#   par_opts     (optional) options to give to par
#   intstyle     (optional) intstyle option to all tools
#
#   files 		description
#   ----------  	------------
#   $(top_module).ucf	ucf file
#
# Library modules should have a modules.mk in their root directory,
# namely $(libdir)/<libname>/module.mk, that simply adds to the vfiles
# and xilinx_cores variable.
#
# all the .xco files listed in xilinx_cores will be generated with core, with
# the resulting .vhd and .ngc files placed back in the same directory as
# the .xco file.
#
# TODO: .xco files are device dependant, should use a template based system


coregen_work_dir ?= ./coregen-tmp
map_opts ?= -timing -ol high -detail -pr b -register_duplication -w
par_opts ?= -ol high
xil_env ?= . $(ise_dir)/settings64.sh

vfiles  = $(wildcard ../../src/*.vhd)
libmks  = $(patsubst %,$(libdir)/%/module.mk,$(libs))
mkfiles = Makefile $(libmks)
include $(libmks)

corengcs = $(foreach core,$(xilinx_cores),$(core:.xco=.ngc))
local_corengcs = $(foreach ngc,$(corengcs),$(notdir $(ngc)))
vfiles += $(foreach core,$(xilinx_cores),$(core:.xco=.vhd))

SHELL := /bin/bash

.PHONY: default xilinx_cores clean twr etwr
default: $(top_module).bit $(top_module).mcs
xilinx_cores: $(corengcs)
twr: $(top_module).twr
etwr: $(top_module)_err.twr

define cp_template
$(2): $(1)
	cp $(1) $(2)
endef
$(foreach ngc,$(corengcs),$(eval $(call cp_template,$(ngc),$(notdir $(ngc)))))

%.ngc %.vhd: %.xco
	@echo "=== rebuilding $@"
	if [ -d $(coregen_work_dir) ]; then \
		rm -rf $(coregen_work_dir)/*; \
	else \
		mkdir -p $(coregen_work_dir); \
	fi
	cd $(coregen_work_dir); \
	$(xil_env); \
	coregen -b $$OLDPWD/$<; \
	cd -
	xcodir=`dirname $<`; \
	basename=`basename $< .xco`; \
	if [ ! -r $(coregen_work_dir/$$basename.ngc) ]; then \
		echo "'$@' wasn't created."; \
		exit 1; \
	else \
		cp $(coregen_work_dir)/$$basename.vhd $(coregen_work_dir)/$$basename.ngc $$xcodir; \
	fi

date = $(shell date +%F-%H-%M)

programming_files: $(top_module).bit $(top_module).mcs
	mkdir -p $@/$(date)
	mkdir -p $@/latest
	for x in .bit .mcs .cfi; do cp $(top_module)$$x $@/$(date)/$(top_module)$$x; cp $(top_module)$$x $@/latest/$(top_module)$$x; done
	$(xil_env); xst -help | head -1 | sed 's/^/#/' | cat - $(top_module).scr > $@/$(date)/$(top_module).scr

$(top_module).mcs: $(top_module).bit
	$(xil_env); \
	promgen -w -s $(flashsize) -p mcs -o $@ -u 0 $^

$(top_module).bit: $(top_module)_par.ncd
	$(xil_env); \
	bitgen $(intstyle) -g DriveDone:yes -g StartupClk:Cclk -w $(top_module)_par.ncd $(top_module).bit


$(top_module)_par.ncd: $(top_module).ncd
	$(xil_env); \
	if par $(intstyle) $(par_opts) -w $(top_module).ncd $(top_module)_par.ncd; then \
		:; \
	else \
		$(MAKE) etwr; \
	fi

$(top_module).ncd: $(top_module).ngd
	if [ -r $(top_module)_par.ncd ]; then \
		cp $(top_module)_par.ncd smartguide.ncd; \
		smartguide="-smartguide smartguide.ncd"; \
	else \
		smartguide=""; \
	fi; \
	$(xil_env); \
	map $(intstyle) $(map_opts) $$smartguide $<

$(top_module).ngd: $(top_module).ngc $(top_module).ucf
	$(xil_env); ngdbuild $(intstyle) $(top_module).ngc

$(top_module).ngc: $(vfiles) $(local_corengcs) $(top_module).scr $(top_module).prj
	$(xil_env); xst $(intstyle) -ifn $(top_module).scr

$(top_module).prj: $(vfiles) $(mkfiles)
	for src in $(vfiles); do echo "vhdl work $$src" >> $(top_module).tmpprj; done
	sort -u $(top_module).tmpprj > $(top_module).prj
	rm -f $(top_module).tmpprj

optfile += $(wildcard $(top_module).opt)

$(top_module).scr: $(optfile) $(mkfiles) ./xilinx.opt
	echo "run" > $@
	echo "-p $(part)" >> $@
	echo "-top $(top_module)" >> $@
	echo "-ifn $(top_module).prj" >> $@
	echo "-ofn $(top_module).ngc" >> $@
	cat ./xilinx.opt $(optfile) >> $@

$(top_module).post_map.twr: $(top_module).ncd
	$(xil_env); trce -e 10 $< $(top_module).pcf -o $@

$(top_module).twr: $(top_module)_par.ncd
	$(xil_env); trce $< $(top_module).pcf -o $(top_module).twr

$(top_module)_err.twr: $(top_module)_par.ncd
	$(xil_env); trce -e 10 $< $(top_module).pcf -o $(top_module)_err.twr

clean:
	rm -rf *.log *.xml *.ncd *.xst *.xpi *.xise *.ut *.unroutes *.twx *.twr *.syr \
	*.stx *.srp *.scr *.ptwx *.psr *.prm *.prj *.pcf *.par *.pad *.ngr *.ngm \
	*.ngd *.xrpt *.ngc *.mrp *.map *.lso *.gise *.drc *.cmd_log *.html \
	*.cfi *.bld *.bgn *.unroutes *.grf *.txt *.csv *.lst *.xwbt \
	_ngo/ _xmsgs/ xlnx_auto_0_xdb/ xst/
