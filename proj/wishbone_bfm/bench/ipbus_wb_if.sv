/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : wshb_m_if.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sun 26 Dec 2021 01:50:54 PM CST
 ************************************************************************/
 
interface ipb_if #(
    parameter DWIDTH=32,
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
        default input #1ns output #1ns;
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

    task reset();
    endtask

    task wb_bus_cycle();
        mcb.wb_cyc_o <= 1'b1;
        mcb.wb_stb_o <= 1'b1;
        mcb.wb_adr_o <= addr;
        mcb.wb_sel_o <= sel;
        mcb.wb_dat_o <= data;
        if(trns_type == WRITE) begin
            mcb.wb_we_o <= 1'b1;
        end else begin
            mcb.wb_we_o <= 1'b0;
        end

        //wait for slave response

        do begin
            do begin
                @mcb;
                ack_cnt++;
            end while((mcb.wb_ack_i !== 1'b1) && (mcb.wb_err_i !== 1'b1') &&
                     (mcb.wb_rty_i !== 1'b1) && (ack_cnt != ack_timeout));
            //check error signal
            if(mcb.wb_err_i) begin
                $error("transaction error detected at sim time %d",$time());
            end

            // check acknowledge timeout
            if((mcb.wb_ack_i)&&(!mcb.wb_rty_i)) begin
                $error("transaction timeout detected at sim time %d",$time());
            end
            retry_cnt++;
        end while((mcb.wb_rty_i==1'b1)&&(retry_cnt!=max_retry));
        //check retry signal
        if(mcb.wb_rty_i) begin
           $error("unexpected transaction Retey Detected at sim time %0t",$time()); 
        end

        //Get Data
        out_data = mcb.wb_dat_i;
        mcb.wb_cyc_o <= 1'b0;
    endtask

endinterface
