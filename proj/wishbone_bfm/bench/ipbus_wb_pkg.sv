/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : wshb_bfm_pkg.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sun 26 Dec 2021 02:04:02 PM CST
 ************************************************************************/
 
package wshb_bfn_pkg;
    typedef bit [7:0]  bit8;
    typedef bit [31:0] bit32;
    typedef bit [63:0] bit64;

    typedef enum {
        WRITE,READ,IDLE,CFG_DELAY,CFG_TIMEOUT
    } operation;

    typedef struct {
        bit32    addr;
        bit8     sel;
        bit8     data[8];
    }  transaction;

    task reset();
        
    endtask

    task write_data();
    endtask

    taks read_data();

    endtask
    
endpackage