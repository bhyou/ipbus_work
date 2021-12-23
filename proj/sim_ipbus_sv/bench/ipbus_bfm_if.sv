/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : ipbus_bfm_if.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sat 18 Dec 2021 10:28:02 AM CST
 ************************************************************************/
interface ipbus_bfm_if #(ADDRWID=16)(
    input logic clk,
    input logic rst
);
    import ipbus_bfm_pkg::*;
    // ipbus bus signals
    logic [31:0]       ipb_addr;
    logic [31:0]       ipb_wdata;
    logic              ipb_strobe;
    logic              ipb_write;
    logic [31:0]       ipb_rdata;
    logic              ipb_ack  ;
    logic              ipb_err  ;
    // Busarbiter signals
    logic              ipb_req;
    logic              ipb_grant;
    // Interface to packet buffers
    logic               pkt_rdy;
    logic [31:0]        pkt_rdata;
    logic               pkt_busy;
    logic [ADDRWID-1:0] pkt_raddr;
    logic               pkt_done;
    logic               pkt_we;
    logic [ADDRWID-1:0] pkt_waddr;
    logic [31:0]        pkt_wdata;

    logic [127:0]       cfg_in;
    logic [127:0]       cfg_out;

    clocking mcb@(posedge clk);
        default input #1 output #1; 
        input ipb_addr, ipb_wdata, ipb_strobe, ipb_write;
        output  ipb_rdata, ipb_ack, ipb_err;
        input pkt_raddr, pkt_done, pkt_we, pkt_waddr, pkt_wdata;
        output  pkt_rdy, pkt_rdata, pkt_busy;
        input ipb_req, cfg_out;
        output  ipb_grant, cfg_in;
    endclocking 

    modport dut (
        input  clk, rst,
        output ipb_addr, ipb_wdata, ipb_strobe, ipb_write,
        input  ipb_rdata, ipb_ack, ipb_err,
        output pkt_raddr, pkt_done, pkt_we, pkt_waddr, pkt_wdata,
        input  pkt_rdy, pkt_rdata, pkt_busy,
        output ipb_req, cfg_out,
        input  ipb_grant, cfg_in
    );

    modport tb(
        input clk, rst, clocking mcb,
        import ipbus_transact,
        import init
    );

    task init();
        ipb_grant <= 1'b1;

        pkt_rdy   <= 1'b0  ;
        pkt_rdata <= 32'h0 ;
        pkt_busy  <= 1'b0  ;
        cfg_in    <= 128'h0;
    endtask

    task ipbus_transact(ref transaction trns, output transaction respone_trns);
        bit [15:0] t_size;   // transaction size : packet_length + header + address +  payload
        bit [15:0] read_addr;
        time      start_t;
        time      stop_t;

        t_size  = 1 + trns.trns_data.size();
        respone_trns.trns_data = new[trns.trns_head.word_cnt];

        print_trans("Send Request",trns);

        mcb.pkt_rdy <= 1'b1;
        mcb.pkt_rdata <= {16'h1,t_size};

        fork
            begin
                #IPBUS_TIMEOUT;  //8us
                $error("Waiting for read address change!");
            end 
            wait(mcb.pkt_raddr==2);
        join_any

        mcb.pkt_rdata <= get_head_code(trns.trns_head);
        repeat(2) @(mcb);  

        while(!mcb.pkt_done) begin
            read_addr = pkt_raddr;
            @(mcb);  
            mcb.pkt_rdata <= trns.trns_data[read_addr-3];


            if(mcb.pkt_we) begin
                if(mcb.pkt_waddr==2) begin
                    respone_trns.trns_head = get_head_string(mcb.pkt_wdata);
                end else if(mcb.pkt_waddr > 2) begin
                //    $display("waddr : %x, \t wdata : %x", mcb.pkt_waddr, mcb.pkt_wdata);
                    respone_trns.trns_data[mcb.pkt_waddr-3] = mcb.pkt_wdata;
                end
            end
        end

        mcb.pkt_rdy <= 1'b0;
        @(mcb);
    endtask

endinterface //ipbus_bfm_if 
