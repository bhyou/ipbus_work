##########################################################################
# Copyright (C) 2021 Sangfor Ltd. All rights reserved.
# File Name   : Makefile
# Author      : bhyou
# mail        : bhyou@foxmail.com
# Created Time: Sat 18 Dec 2021 04:22:17 PM CST
#########################################################################
include ${HOME}/Library/SCRIPTS/VCSMX/VCSMX.mk

topDesign = ipbus_bfm_tb
vhdlFileList = no
vlogFileList = no

FIRMWARE_PRJ=../../../src/ipbus-firmware
CORE_DIR=$(FIRMWARE_PRJ)/components/ipbus_core/firmware/hdl
SLAVE_DIR=$(FIRMWARE_PRJ)/components/ipbus_slaves/firmware/hdl
UTIL_DIR=$(FIRMWARE_PRJ)/components/ipbus_util/firmware/hdl

VHDL_DUT_SRC += $(CORE_DIR)/ipbus_trans_decl.vhd
VHDL_DUT_SRC += $(CORE_DIR)/ipbus_package.vhd
VHDL_DUT_SRC += $(CORE_DIR)/transactor_if.vhd
VHDL_DUT_SRC += $(CORE_DIR)/transactor_sm.vhd
VHDL_DUT_SRC += $(CORE_DIR)/transactor_cfg.vhd
VHDL_DUT_SRC += $(CORE_DIR)/transactor.vhd
VHDL_DUT_SRC += $(UTIL_DIR)/ipbus_decode_ipbus_example.vhd 
VHDL_DUT_SRC += $(SLAVE_DIR)/ipbus_reg_types.vhd
VHDL_DUT_SRC += $(CORE_DIR)/ipbus_fabric_sel.vhd
VHDL_DUT_SRC += $(SLAVE_DIR)/ipbus_ctrlreg_v.vhd 
VHDL_DUT_SRC += $(SLAVE_DIR)/ipbus_reg_v.vhd 
VHDL_DUT_SRC += $(SLAVE_DIR)/ipbus_ram.vhd 
VHDL_DUT_SRC += $(SLAVE_DIR)/ipbus_peephole_ram.vhd
VHDL_DUT_SRC += $(UTIL_DIR)/ipbus_example.vhd 
VHDL_DUT_SRC += $(UTIL_DIR)/payload_example.vhd

VLOG_TB_SRC += ../bench/ipbus_bfm_pkg.sv
VLOG_TB_SRC += ../bench/ipbus_bfm_if.sv
VLOG_TB_SRC += ../bench/ipbus_transactor_wrapper.sv
VLOG_TB_SRC += ../bench/ipbus_bfm_tb.sv

