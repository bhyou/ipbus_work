/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : ipbus_wb_if.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sun 26 Dec 2021 01:50:54 PM CST
 ************************************************************************/
import ipbus_wb_pkg::*;

interface ipb_if #(
    parameter DWIDTH=32,
    parameter AWIDTH=32
    )(input bit clk);

    parameter SELWIDTH = $clog2(DWIDTH);

    logic  [DWIDTH-1:0]   rdata;
    logic  [DWIDTH-1:0]   wdata;
    logic  [AWIDTH-1:0]   addr;
    logic                 strobe;
    logic                 write;
    logic                 ack;
    logic                 error;

    //master clocking block
    clocking mcb @(posedge clk);
        default input #1ns output #1ns;
        output   wdata;
        output   addr;
        output   strobe;
        output   write;
        input    ack;
        input    rdata;
        input    error; 
    endclocking

    // slave clocking block
    clocking scb @(posedge clk);
        default input #1ns output #1ns;
        input   wdata;
        input   addr;
        input   strobe;
        input   write;
        output  ack;
        output  rdata;
        output  error; 
    endclocking

    modport master (
        input clk, clocking mcb
    );
    modport slave (
        input clk, clocking scb
    );

    task reset_operation();
        mcb.wdata <= 0;
        mcb.addr <= 0;
        mcb.strobe <= 0;
        mcb.write <= 0;
    endtask

    task write_operation(input bit32 addr, wrdata);
        @mcb;
        mcb.wdata <= wrdata;
        mcb.addr <= addr;
        mcb.strobe <= 1'b1;
        mcb.write <= 1'b1;
        fork
           begin
               #TIMEOUT;
               $display("IPbus Wishbone interface timeout!");  
           end
           do begin
                @mcb;
            end while((mcb.ack==1'b0) && (mcb.error==1'b0));
        join_any
        $display("Write data: 0x%8x to addr: %0d",wrdata, addr);
        mcb.strobe <= 1'b0;
    endtask

    task read_operation(input bit32 addr, output bit32 rddata);
        @mcb;
        mcb.addr <= addr;
        mcb.strobe <= 1'b1;
        mcb.write <= 1'b0;
        fork
           begin
               #TIMEOUT;
               $display("IPbus Wishbone interface timeout!");  
           end
           do begin
                @mcb;
                if(mcb.ack) rddata = rdata;
            end while((mcb.ack==1'b0) && (mcb.error==1'b0));
        join_any
        $display("Read data: 0x%8x from addr: %0d",rddata, addr);
        mcb.strobe <= 1'b0;
    endtask
endinterface
