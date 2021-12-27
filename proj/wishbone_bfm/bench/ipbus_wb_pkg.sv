/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : ipbus_wb_pkg.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Sun 26 Dec 2021 02:04:02 PM CST
 ************************************************************************/
 
package ipbus_wb_pkg;
    parameter TIMEOUT = 4000; // 4us
    typedef bit [7:0]  bit8;
    typedef bit [31:0] bit32;

    typedef enum {
        WRITE,READ,IDLE
    } operation;

    typedef struct {
        bit32    addr;
        bit32    data;
    }  transaction;

endpackage