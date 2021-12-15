##########################################################################
# Copyright (C) 2021 Sangfor Ltd. All rights reserved.
# File Name   : src_files.tcl
# Author      : bhyou
# mail        : bhyou@foxmail.com
# Created Time: Wed 15 Dec 2021 10:57:29 AM CST
#########################################################################
#set IPBUS_SRC_DIR "../../src/ipbus-firmware"

set hdl_pkg " \
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/ipbus_package.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_slaves/firmware/hdl/ipbus_reg_types.vhd \
"
set slaves_hdl "\
  ${IPBUS_SRC_DIR}/components/ipbus_slaves/firmware/hdl/ipbus_peephole_ram.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_slaves/firmware/hdl/ipbus_ram.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_slaves/firmware/hdl/ipbus_reg_v.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_slaves/firmware/hdl/ipbus_ctrlreg_v.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/hdl/ipbus_decode_ipbus_example.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/ipbus_fabric_sel.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/hdl/ipbus_example.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/hdl/payload_example.vhd \
"
set eth_mac "\
  ${IPBUS_SRC_DIR}/components/ipbus_eth/firmware/hdl/emac_hostbus_decl.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_eth/firmware/hdl/eth_7s_gmii.vhd \
"
set ipbus_core_hdl "\
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/ipbus_trans_decl.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/transactor_cfg.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/transactor_sm.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/transactor_if.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/transactor.vhd \
"
set ipbus_udp_hdl "\
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_txtransactor_if_simple.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_tx_mux.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_status_buffer.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_rxtransactor_if_simple.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_rxram_shim.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_rxram_mux.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_rarp_block.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_packet_parser.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_ipaddr_block.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_dualportram_tx.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_dualportram_rx.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_dualportram.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_do_rx_reset.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_clock_crossing_if.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_byte_sum.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_build_status.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_build_resend.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_build_ping.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_build_payload.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_build_arp.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_buffer_selector.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_transport_udp/firmware/hdl/udp_if_flat.vhd \
"
set arch_hdl "\
  ${IPBUS_SRC_DIR}/components/ipbus_core/firmware/hdl/trans_arb.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/hdl/masters/ipbus_ctrl.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/hdl/led_stretcher.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/hdl/ipbus_clock_div.vhd \
  ${IPBUS_SRC_DIR}/components/ipbus_util/firmware/hdl/clocks/clocks_7s_extphy.vhd \
  ${IPBUS_SRC_DIR}/boards/kc705/gmii/synth/firmware/hdl/kc705_gmii_infra.vhd \
  ${IPBUS_SRC_DIR}/boards/kc705/gmii/synth/firmware/hdl/top_kc705_gmii.vhd\
"
set xilinx_ips "\
  ${IPBUS_SRC_DIR}/components/ipbus_eth/firmware/cgn/mac_fifo_axi4.xci \
  ${IPBUS_SRC_DIR}/components/ipbus_eth/firmware/cgn/temac_gbe_v9_0_gmii.xci\
"


set src_file_list [concat ${hdl_pkg} ${slaves_hdl} ${eth_mac} ${ipbus_core_hdl} ${arch_hdl}\
                          ${ipbus_udp_hdl} ${arch_hdl}]

foreach index ${src_file_list} {
  if {![file exists ${index}]} {
    set src_err 1
    puts "Error: not found such file ${index}"
  } else {
    set src_err 0
  } 
}

foreach index ${xilinx_ips} {
  if {![file exists ${index}]} {
    set ips_err 1
    puts "Error: not found such file ${index}"
  } else {
    set ips_err 0
  }
}