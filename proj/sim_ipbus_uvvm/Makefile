.PHONY: clean com default 
VSTD=-2008

#XILINX_LIB_PATH=../../xilinx_sim_libs/2020.2
UVVM_UTIL_DIR=../../src/UVVM/uvvm_util/sim/uvvm_util
FIRMWARE_PRJ=../../src/ipbus-firmware

## ipbus core file directory
CORE_DIR=$(FIRMWARE_PRJ)/components/ipbus_core/firmware/hdl

# ipbus slave file directory
SLAVE_DIR=$(FIRMWARE_PRJ)/components/ipbus_slaves/firmware/hdl

# ipbus util file directory
UTIL_DIR=$(FIRMWARE_PRJ)/components/ipbus_util/firmware/hdl

## ipbus core files
ipbus_core_pkg += $(CORE_DIR)/ipbus_trans_decl.vhd
ipbus_core_pkg += $(CORE_DIR)/ipbus_package.vhd
ipbus_core_hdl += $(CORE_DIR)/transactor_if.vhd
ipbus_core_hdl += $(CORE_DIR)/transactor_sm.vhd
ipbus_core_hdl += $(CORE_DIR)/transactor_cfg.vhd
ipbus_core_hdl += $(CORE_DIR)/transactor.vhd

## ipbus slave files
ipbus_slave_pkg += $(UTIL_DIR)/ipbus_decode_ipbus_example.vhd 
ipbus_slave_pkg += $(SLAVE_DIR)/ipbus_reg_types.vhd
ipbus_slave_hdl += $(CORE_DIR)/ipbus_fabric_sel.vhd
ipbus_slave_hdl += $(SLAVE_DIR)/ipbus_ctrlreg_v.vhd 
ipbus_slave_hdl += $(SLAVE_DIR)/ipbus_reg_v.vhd 
ipbus_slave_hdl += $(SLAVE_DIR)/ipbus_ram.vhd 
ipbus_slave_hdl += $(SLAVE_DIR)/ipbus_peephole_ram.vhd
ipbus_slave_hdl += $(UTIL_DIR)/ipbus_example.vhd 
ipbus_slave_hdl += $(UTIL_DIR)/payload_example.vhd

bench_file += ./tb_vip_uvvm/ipbus_bfm_pkg.vhd
bench_file += ./tb_vip_uvvm/ipbus_transactor_wrapper.vhd
bench_file += ./tb_vip_uvvm/ipbus_bfm_tb.vhd


default: com
com: map_uvvm_util com_ipbus com_slave com_bench

#map_unisim:
#	@vmap UNISIM $(XILINX_LIB_PATH)/unisim 

map_uvvm_util:
	@vmap uvvm_util $(UVVM_UTIL_DIR)

# compile ipbus core
com_ipbus: 
	@vcom -work work $(VSTD) $(ipbus_core_pkg) $(ipbus_core_hdl)

# compile slaves
com_slave: 
	@vcom -work work $(VSTD) $(ipbus_slave_pkg) $(ipbus_slave_hdl)

# compile testbench
com_bench: 
	@vcom -work work $(VSTD) $(bench_file)

sim: com
	@vsim -fsmdebug -voptargs=+acc -t 1ps  work.ipbus_bfm_tb  

clean:
	rm -rf work 
dclean:
	rm -rf work transcript _Alert.txt _Log.txt
