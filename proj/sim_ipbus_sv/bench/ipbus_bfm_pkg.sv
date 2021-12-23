/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : ipbus_bfm_pkg.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Thu 23 Dec 2021 08:50:31 AM CST
 ************************************************************************/
package ipbus_bfm_pkg;

    parameter IPBUS_TIMEOUT = 8000; // 8us

    typedef enum bit[3:0] {  
        read         = 4'h0,
        write        = 4'h1,
        non_inc_read = 4'h2,
        non_inc_write= 4'h3,
        rmw_bits     = 4'h4,
        rmw_sum      = 4'h5,
        conf_read    = 4'h6,
        conf_write   = 4'h7
    } trans_type;   

    typedef enum bit [3:0] {
        SUCCESS              = 4'h0,
        BAD_HEAD             = 4'h1,
        RESERVED_0x2         = 4'h2,
        RESERVED_0x3         = 4'h3,
        BUS_ERROR_ON_READ    = 4'h4,
        BUS_ERROR_ON_WRITE   = 4'h5,
        BUS_TIMEOUT_ON_READ  = 4'h6,
        BUS_TIMEOUT_ON_WRITE = 4'h7,
        RESERVED_0x8         = 4'h8,
        RESERVED_0x9         = 4'h9,
        RESERVED_0xA         = 4'hA,
        RESERVED_0xB         = 4'hB,
        RESERVED_0xC         = 4'hC,
        RESERVED_0xD         = 4'hD,
        RESERVED_0xE         = 4'hE,
        OUTBOUND_REQUEST     = 4'hF
    } trans_info;      

    typedef struct {
        bit [3:0]   version  ;  // protocol version
        bit [11:0]  trns_id  ;
        bit [7:0]   word_cnt ; // word count
        trans_type  trns_type;
        trans_info  trns_info;
    } header;

    typedef struct {
        header      trns_head;
        bit [31:0]  trns_data[]; 
    } transaction;


    function transaction read_trans(input bit[31:0] base_addr, input bit[3:0] t_size);
        read_trans.trns_head = get_trans_head(t_size,read);
        read_trans.trns_data = new[1];
        read_trans.trns_data[0] = base_addr;
    endfunction

    function transaction non_inc_read_trans(input bit[31:0] base_addr, input bit[3:0] t_size);
        non_inc_read_trans.trns_head = get_trans_head(t_size,non_inc_read);
        non_inc_read_trans.trns_data = new[1];
        non_inc_read_trans.trns_data[0] = base_addr;
    endfunction

    function transaction write_trans(input bit[31:0] base_addr, input bit[3:0] t_size, ref bit[31:0] data[]);
        byte data_size;

        data_size = data.size() + 1;
        write_trans.trns_head = get_trans_head(t_size,write);
        write_trans.trns_data = new[data_size];
        write_trans.trns_data[0] = base_addr;
        foreach(data[idx]) begin
            write_trans.trns_data[idx+1] = data[idx];
        end
    endfunction

    function transaction non_inc_write_trans(input bit[31:0] base_addr, input bit[3:0] t_size, ref bit[31:0] data[]);
        byte data_size;

        data_size = data.size() + 1;
        non_inc_write_trans.trns_head = get_trans_head(t_size,non_inc_write);
        non_inc_write_trans.trns_data = new[data_size];
        non_inc_write_trans.trns_data[0] = base_addr;
        foreach(data[idx]) begin
            non_inc_write_trans.trns_data[idx+1] = data[idx];
        end
    endfunction

    function transaction rmw_bits_trans(input bit[31:0] base_addr, and_term, or_term);
        rmw_bits_trans.trns_head = get_trans_head(4'h1,rmw_bits);
        rmw_bits_trans.trns_data = new[3];
        rmw_bits_trans.trns_data[0] = base_addr;
        rmw_bits_trans.trns_data[1] = and_term;
        rmw_bits_trans.trns_data[2] = or_term;
    endfunction

    function transaction rmw_sum_trans(input bit[31:0] base_addr, add_term);
        rmw_sum_trans.trns_head = get_trans_head(4'h1,rmw_sum);
        rmw_sum_trans.trns_data = new[2];
        rmw_sum_trans.trns_data[0] = base_addr;
        rmw_sum_trans.trns_data[1] = add_term;
    endfunction

    function header get_trans_head(input bit [3:0] t_size, input trans_type t_type);
        get_trans_head.version = 4'h2;
        get_trans_head.trns_id = 12'h0;
        get_trans_head.word_cnt = t_size;
        get_trans_head.trns_type = t_type;
        get_trans_head.trns_info = OUTBOUND_REQUEST;
    endfunction

    function bit[31:0] get_head_code(input header sof);
        get_head_code = {sof.version, sof.trns_id, sof.word_cnt, sof.trns_type, sof.trns_info}; 
    endfunction

    function header get_head_string(input bit[31:0] sof);
        get_head_string.version   = sof[31:28]; 
        get_head_string.trns_id   = sof[27:16]; 
        get_head_string.word_cnt  = sof[15:8] ; 
        get_head_string.trns_type = sof[7:4]  ; 
        get_head_string.trns_info = sof[3:0]  ; 
    endfunction

    function void print_trans(string str, ref transaction trns);
        $display("@%0t %s transaction :",$realtime, str);
        $display("\t version  : %x",trns.trns_head.version);
        $display("\t trns_id  : %x",trns.trns_head.trns_id  );
        $display("\t word_cnt : %x",trns.trns_head.word_cnt );
        $display("\t trns_type: %s",trns.trns_head.trns_type);
        $display("\t trns_info: %s",trns.trns_head.trns_info);
        $display("\t payload  : *******");
        foreach(trns.trns_data[idx]) begin
            $display("\t \t data[%0d] : %x",idx, trns.trns_data[idx]);
        end
        $display("==========================================================");
        $display("\n");
    endfunction


endpackage