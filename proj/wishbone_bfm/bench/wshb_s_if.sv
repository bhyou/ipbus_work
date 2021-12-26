/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : wshb_s_if.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sun 26 Dec 2021 02:01:57 PM CST
 ************************************************************************/
 
interface wshb_s_if #(
    parameter DWIDTH=64,
    parameter AWIDTH=32
    )(input bit clk);

    parameter SELWIDTH = $clog2(DWIDTH);

    logic  [DWIDTH-1:0]   wb_dat_i;
    logic  [DWIDTH-1:0]   wb_dat_o;
    logic  [AWIDTH-1:0]   wb_adr_o;
    logic                 wb_cyc_o;
    logic  [SELWIDTH-1:0] wb_sel_o;
    logic                 wb_stb_o;
    logic                 wb_we_o ;
    logic                 wb_ack_i;
    logic                 wb_err_i;
    logic                 wb_rty_i;

    clocking mcb @(posedge clk);
        input   wb_dat_o;
        input   wb_adr_o;
        input   wb_cyc_o;
        input   wb_sel_o;
        input   wb_stb_o;
        input   wb_we_o ;
        output  wb_ack_i;
        output  wb_err_i;
        output  wb_rty_i;
        output  wb_dat_i;
    endclocking

endinterface

