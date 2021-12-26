/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : wshb_m_if.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sun 26 Dec 2021 01:50:54 PM CST
 ************************************************************************/
 
interface wshb_m_if #(
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
        output wb_dat_o;
        output wb_adr_o;
        output wb_cyc_o;
        output wb_sel_o;
        output wb_stb_o;
        output wb_we_o;
        input  wb_ack_i;
        input  wb_err_i;
        input  wb_rty_i;
        input  wb_dat_i;
    endclocking

endinterface
