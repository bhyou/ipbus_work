##########################################################################
# Copyright (C) 2021 Sangfor Ltd. All rights reserved.
# File Name   : constrains.tcl
# Author      : bhyou
# mail        : bhyou@foxmail.com
# Created Time: Wed 15 Dec 2021 10:57:50 AM CST
#########################################################################    
#set IPBUS_SRC_DIR "../../src/ipbus-firmware"

set timing_constraints "\
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/ucf/clock_utils.tcl \
  ${IPBUS_SRC_DIR}/boards/kc705/gmii/synth/firmware/ucf/kc705_gmii.tcl\
"

foreach index ${timing_constraints} {
  if {![file exists ${index}]} {
    set xdc_err 1
    puts "Error: not found such file ${index}"
  } else {
    set xdc_err 0
  }
}
