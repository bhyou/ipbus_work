/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : ipbus_bfm_tb.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sat 18 Dec 2021 02:45:47 PM CST
 ************************************************************************/

import ipbus_bfm_pkg::*;
module ipbus_bfm_tb;

    parameter ADDRWID = 16;
    parameter IPB_CLK_PERIOD = 20;

    reg  ipbus_clk;
    reg  ipbus_rst;

    transaction ram_trans;
    transaction respone_trns;
    bit [31:0]  wr_data [];

    ipbus_bfm_if #(ADDRWID) trans_if (
        .clk (ipbus_clk),
        .rst (ipbus_rst)
    );

    // Instantiate the IPbus transactor wrapper. It is necessary.
    //=============================================================
    ipbus_transactor_wrapper transactor_0 (trans_if);

    // IPbus Connection 
    wire [65:0]  ipbus_out;
    assign  ipbus_out[65:34] = trans_if.ipb_addr  ;
    assign  ipbus_out[33:2]  = trans_if.ipb_wdata ;
    assign  ipbus_out[1]     = trans_if.ipb_strobe;
    assign  ipbus_out[0]     = trans_if.ipb_write ;

    wire [33:0] ipbus_in ;
    assign trans_if.ipb_rdata = ipbus_in[33:2];
    assign trans_if.ipb_ack   = ipbus_in[1]   ;
    assign trans_if.ipb_err   = ipbus_in[0]   ;
    //=============================================================

    // Instantiate ipbus_ram
    ipbus_ram #(
        .ADDR_WIDTH(4)
    ) RAM_256 (
        .clk       (ipbus_clk),
        .reset     (ipbus_rst),
        .ipbus_in  (ipbus_out),
        .ipbus_out (ipbus_in)
    );

    initial begin
        $timeformat(-9,3,"ns",10);
        ipbus_clk = 0;
        forever #(IPB_CLK_PERIOD/2) ipbus_clk = ~ ipbus_clk;
    end

    initial begin
        
    end

    initial begin
        ipbus_rst = 1;
        trans_if.init();

        repeat(3) @(negedge ipbus_clk);
        ipbus_rst = 0;


        wr_data = new [4];
        wr_data = {32'h12345678,32'h4567_89AB,32'h789A_BCDE,32'hBCDE_F012};
        // write ram
        ram_trans = write_trans(32'h0000_000C,4,wr_data);
        trans_if.ipbus_transact(ram_trans,respone_trns);

        // read ram
        ram_trans = read_trans(32'h0000_000C,4);
        trans_if.ipbus_transact(ram_trans,respone_trns);
        print_trans("Get respone", respone_trns);

        // non-inc write ram
        ram_trans = non_inc_write_trans(32'h0000_0001, 4, wr_data);
        trans_if.ipbus_transact(ram_trans,respone_trns);

        // non-inc read ram
        ram_trans = non_inc_read_trans(32'h0000_0001,3);
        trans_if.ipbus_transact(ram_trans,respone_trns);
        print_trans("Get respone", respone_trns);

        // read-modify-write bits
        ram_trans = rmw_bits_trans(32'h0000_000F,32'h0000_FFFF, 32'hFF00_0000);
        trans_if.ipbus_transact(ram_trans,respone_trns);
        print_trans("Get respone", respone_trns);

        // read-modify-write sum
        ram_trans = rmw_sum_trans(32'h0000_000C,32'h0000_0003);
        trans_if.ipbus_transact(ram_trans,respone_trns);
        print_trans("Get respone", respone_trns);
        $finish();
    end
    
endmodule