###################################################################
# Project Configuration: 
# 
# Specify the name of the design (project) and the Quartus II
# Settings File (.qsf)
###################################################################

PROJECT = Example-Project
TOP_LEVEL_ENTITY = top_level
ASSIGNMENT_FILES = $(PROJECT).qpf $(PROJECT).qsf

###################################################################
# Part, Family, Boardfile DE1 or DE2
BOARD = DE2
include $(BOARD).mk
###################################################################

###################################################################
# Setup your sources here
SRCS = $(wildcard ../fpga/*.sv) \
  $(wildcard ../fpga/*.v) \
  $(wildcard ../fpga/*.vhdl) \
  $(wildcard ../fpga/*.vhd) \
  $(wildcard ../fpga/*.qsys)

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and database
# program: program your device with the compiled design
###################################################################

all: $(PROJECT).svf

clean:
	$(RM) -rf *.rpt *.chg smart.log *.htm *.eqn *.pin *.sof *.pof db incremental_db *.summary *.smsg *.jdi *.qpf *.qsf *.svf *.qws

###################################################################
# Executable Configuration
#
# QUARTUS_PATH: If empty then system path is searched.
#               If set then requires trailling slash.
#               Commented out so it may be set from environment.
###################################################################

# QUARTUS_PATH = /opt/altera/13.0sp1/quartus/bin/

QUARTUS_MAP  = $(QUARTUS_PATH)quartus_map
QUARTUS_FIT  = $(QUARTUS_PATH)quartus_fit
QUARTUS_ASM  = $(QUARTUS_PATH)quartus_asm
QUARTUS_STA  = $(QUARTUS_PATH)quartus_sta
QUARTUS_SH   = $(QUARTUS_PATH)quartus_sh
QUARTUS_PGM  = $(QUARTUS_PATH)quartus_pgm
QUARTUS_CPF  = $(QUARTUS_PATH)quartus_cpf

ifeq ($(shell uname -m),x86_64)
QUARTUS_ARGS = --64bit
endif

MAP_ARGS = $(QUARTUS_ARGS) --read_settings_files=on $(addprefix --source=,$(SRCS))
FIT_ARGS = $(QUARTUS_ARGS) --part=$(PART) --read_settings_files=on
ASM_ARGS = $(QUARTUS_ARGS)
STA_ARGS = $(QUARTUS_ARGS)
SH_ARGS  = $(QUARTUS_ARGS)
PGM_ARGS = $(QUARTUS_ARGS) --no_banner --mode=jtag 
CPF_ARGS = $(QUARTUS_ARGS) -c -q 10MHz -g 3.3V -n p

###################################################################
# Target implementations
###################################################################

$(PROJECT).sof: $(SOURCE_FILES) 
	$(QUARTUS_SH) $(SH_ARGS) --prepare -f $(FAMILY) -t $(TOP_LEVEL_ENTITY) $(PROJECT)
	-cat $(BOARD)Pins >> $(PROJECT).qsf
	$(QUARTUS_SH) $(SH_ARGS) --determine_smart_action $(PROJECT) > smart.log
	$(QUARTUS_MAP) $(MAP_ARGS) $(PROJECT)
	$(QUARTUS_FIT) $(FIT_ARGS) $(PROJECT)
	$(QUARTUS_ASM) $(ASM_ARGS) $(PROJECT)
	$(QUARTUS_STA) $(STA_ARGS) $(PROJECT) 

$(PROJECT).pof: $(PROJECT).sof
	# No extra commands required, built together.

$(PROJECT).svf: $(PROJECT).sof
	$(QUARTUS_CPF) $(CPF_ARGS) $(PROJECT).sof $(PROJECT).svf

###################################################################
# Programming the device
###################################################################

program: $(PROJECT).sof
	$(QUARTUS_PGM) $(PGM_ARGS) -o "P;$(PROJECT).sof"

program-pof: $(PROJECT).pof
	$(QUARTUS_PGM) $(PGM_ARGS) -o "BVP;$(PROJECT).pof"

program-svf: $(PROJECT).svf
	openocd -f openocd-$(BOARD).cfg -c "svf $(PROJECT).svf" -c exit
