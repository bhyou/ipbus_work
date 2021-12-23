/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : ipbus_transactor_wrapper.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 17 Dec 2021 08:43:00 AM CST
 ************************************************************************/
module ipbus_transactor_wrapper #(parameter ADDRWID = 16)(
    ipbus_bfm_if.dut  ipb_trns
);
    wire ipbud_clk, ipbus_rst;
    assign ipbus_clk = ipb_trns.clk;
    assign ipbus_rst = ipb_trns.rst;

    // IPbus bus interface VHDL
    wire [65:0]  ipb_out;
    assign ipb_trns.ipb_addr   =  ipb_out[65:34];
    assign ipb_trns.ipb_wdata  =  ipb_out[33:2];
    assign ipb_trns.ipb_strobe =  ipb_out[1]   ;
    assign ipb_trns.ipb_write  =  ipb_out[0]   ;

    wire [33:0] ipb_in ;
    assign ipb_in[33:2] = ipb_trns.ipb_rdata;
    assign ipb_in[1]    = ipb_trns.ipb_ack  ;
    assign ipb_in[0]    = ipb_trns.ipb_err  ;

    // Bus arbiter signals
    wire ipb_req, ipb_grant;
    assign ipb_trns.ipb_req = ipb_req; 
    assign ipb_grant = ipb_trns.ipb_grant;

    // Interface to packet buffers
    wire [33:0]  trans_in;
    assign trans_in[33]   = ipb_trns.pkt_rdy;
    assign trans_in[32:1] = ipb_trns.pkt_rdata;
    assign trans_in[0]    = ipb_trns.pkt_busy;

    wire [ADDRWID*2+33:0] trans_out;
    assign ipb_trns.pkt_raddr = trans_out[ADDRWID+34 +: ADDRWID];
    assign ipb_trns.pkt_done  = trans_out[ADDRWID+33];
    assign ipb_trns.pkt_we    = trans_out[ADDRWID+32];
    assign ipb_trns.pkt_waddr = trans_out[32 +: ADDRWID];
    assign ipb_trns.pkt_wdata = trans_out[31:0];

    wire [127:0]  cfg_in, cfg_out;
    assign cfg_in  = ipb_trns.cfg_in;
    assign ipb_trns.cfg_out = cfg_out; 

    transactor trans_0 (
        .clk            (ipbus_clk),
        .rst            (ipbus_rst),
        .ipb_out        (ipb_out  ),
        .ipb_in         (ipb_in   ),
        .ipb_req        (ipb_req  ),
        .ipb_grant      (ipb_grant),
        .trans_in       (trans_in ),
        .trans_out      (trans_out),
        .cfg_vector_in  (cfg_in   ),
        .cfg_vector_out (cfg_out  )
    );

endmodule