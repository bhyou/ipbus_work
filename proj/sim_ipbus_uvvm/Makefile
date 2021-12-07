VSTD=-2008

XILINX_LIB_PATH=/home/EDAtools/Mentor/QuestaSim/2018_10.7c/xilinx_sim_libs/2020.2
UVVM_UTIL_DIR=/home/bhyou/Library/UVVM/uvvm_util/sim/uvvm_util

FIRMWARE_PRJ=/home/bhyou/chip_test/ipbus_work/src/ipbus-firmware

## ipbus core file directory
CORE_DIR=${FIRMWARE_PRJ}/components/ipbus_core/firmware/hdl

# ipbus slave file directory
SLAVE_DIR=${FIRMWARE_PRJ}/components/ipbus_slaves/firmware/hdl

# ipbus util file directory
UTIL_DIR=${FIRMWARE_PRJ}/components/ipbus_util/firmware/hdl

## ipbus core files
ipbus_core_pkg += ${CORE_DIR}/ipbus_trans_decl.vhd
ipbus_core_pkg += ${CORE_DIR}/ipbus_package.vhd
ipbus_core_hdl += ${CORE_DIR}/transactor_if.vhd
ipbus_core_hdl += ${CORE_DIR}/transactor_sm.vhd
ipbus_core_hdl += ${CORE_DIR}/transactor_cfg.vhd
ipbus_core_hdl += ${CORE_DIR}/transactor.vhd

## ipbus slave files
ipbus_slave_pkg += ${UTIL_DIR}/ipbus_decode_ipbus_example.vhd 
ipbus_slave_pkg += ${SLAVE_DIR}/ipbus_reg_types.vhd
ipbus_slave_hdl += ${CORE_DIR}/ipbus_fabric_sel.vhd
ipbus_slave_hdl += ${SLAVE_DIR}/ipbus_ctrlreg_v.vhd 
ipbus_slave_hdl += ${SLAVE_DIR}/ipbus_reg_v.vhd 
ipbus_slave_hdl += ${SLAVE_DIR}/ipbus_ram.vhd 
ipbus_slave_hdl += ${SLAVE_DIR}/ipbus_peephole_ram.vhd
ipbus_slave_hdl += ${UTIL_DIR}/ipbus_example.vhd 
ipbus_slave_hdl += ${UTIL_DIR}/payload_example.vhd


#bench_file += ${FIRMWARE_PRJ}/boards/sim/firmware/hdl/sim_udp_infra.vhd 
#bench_file += ${FIRMWARE_PRJ}/boards/sim/firmware/hdl/top_sim_udp.vhd 
#bench_file += ${FIRMWARE_PRJ}/components/ipbus_util/firmware/sim_hdl/clock_sim.vhd 
#bench_file += ${FIRMWARE_PRJ}/components/modelsim_fli/transport_udp/firmware/hdl/ipbus_udp_ram_buf.vhd 
#bench_file += ${FIRMWARE_PRJ}/components/modelsim_fli/transport_udp/firmware/sim/ipbus_sim_udp.vhd 

bench_file += ./tb_vip_uvvm/ipbus_bfm_pkg.vhd
bench_file += ./tb_vip_uvvm/ipbus_transactor_wrapper.vhd
bench_file += ./tb_vip_uvvm/ipbus_bfm_tb.vhd

all: com
com: map_unisim map_uvvm_util com_ipbus com_slave com_bench

map_unisim:
	@vmap UNISIM ${XILINX_LIB_PATH}/unisim 

map_uvvm_util:
	@vmap uvvm_util ${UVVM_UTIL_DIR}

# compile ipbus core
com_ipbus: 
	@vcom -work work ${VSTD} ${ipbus_core_pkg} ${ipbus_core_hdl}

# compile slaves
com_slave: 
	@vcom -work work ${VSTD} ${ipbus_slave_pkg} ${ipbus_slave_hdl}

# compile testbench
com_bench: 
	@vcom -work work ${VSTD} ${bench_file}

sim: com
#	@vsim -fsmdebug -voptargs=+acc -t 1ps -L fifo_generator_v13_2_5  work.ipbus_bfm_tb  -do add_wave.do
	@vsim -fsmdebug -voptargs=+acc -t 1ps  work.ipbus_bfm_tb  

sim_nogui: com
	vsim -voptargs=+acc -t 1ps -c -L fifo_generator_v13_2_5 -L unisim work.ipbus_bfm_tb -do add_wave.do



#ipcores:
#	#vmap -modelsimini ${XILINX_LIB_PATH}/modelsim.ini
#	vmap fifo_generator_v13_2_5 ${XILINX_LIB_PATH}/fifo_generator_v13_2_5
#	vcom -work work ${FIRMWARE_IPCORE_DIR}/fifo_generator_0/synth/*.vhd
#	vcom -work work ${FIRMWARE_IPCORE_DIR}/fwft_fifo_32_2048/synth/*.vhd
#	vcom -work work ${FIRMWARE_IPCORE_DIR}/fwft_fifo_32_512/synth/*.vhd
#
#
#comp_ipbus_lib:
#	vcom -work work ${VSTD} ${IPBUS_SRCS_CORE_FILE}
#	vcom -work work ${VSTD} ${IPBUS_SRCS_SLV_FILE}
#	vlog -work work ${OPEN_CORES_SPI_FILE}
#
#
#
#comp_logic: map_unisim comp_ipbus_lib ipcores
#	vlog -work work ${LOGIC_SRC_DIR}/dac70004/DAC_refresh.v
#	vcom -work work ${VSTD} ${LOGIC_SRC_FILE}
#	vcom -work work ${VSTD} ${READOUT_SRCS}
#
#comp_tb: map_uvvm_util comp_logic comp_ipbus_lib
#	vcom -work work ${VSTD} ${TB_SRCS}
#
#pre_config: map_unisim map_uvvm_util comp_ipbus_lib ipcores comp_logic comp_tb 
#
.PHONY: clean
clean:
	rm -rf work 
realclean:
	rm -rf work transcript _Alert.txt _Log.txt
