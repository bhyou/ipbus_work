##########################################################################
# Copyright (C) 2021 Sangfor Ltd. All rights reserved.
# File Name   : Makefile
# Author      : bhyou
# mail        : bhyou@foxmail.com
# Created Time: Mon 27 Dec 2021 08:18:02 PM CST
#########################################################################

include ${HOME}/Library/SCRIPTS/VCSMX/VCSMX.mk

topDesign = ipbus_ram_tb

FIRMWARE_PRJ=../../../src/ipbus-firmware
CORE_DIR=$(FIRMWARE_PRJ)/components/ipbus_core/firmware/hdl
SLAVE_DIR=$(FIRMWARE_PRJ)/components/ipbus_slaves/firmware/hdl

VHDL_DUT_SRC += $(CORE_DIR)/ipbus_package.vhd
VHDL_DUT_SRC += $(SLAVE_DIR)/ipbus_ram.vhd 
VLOG_TB_SRC += ../bench/ipbus_wb_pkg.sv
VLOG_TB_SRC += ../bench/ipbus_wb_if.sv
VLOG_TB_SRC += ../bench/ipbus_ram_tb.sv

 
