# IPbus work 

IPbus_work is a chip test project based on IPbus. The IPbus which is a simple packet-based control protocol is developed by CERN. More details of IPbus see: https://github.com/ipbus.

## Verification Example
Note: before running verification example, you must compile UVVM utility library:
 ```bash
  cd src/UVVM/uvvm_util/script/
  vsim -c -do "compile_src.do"
 ```
###  1. Write/Read-CSR example
The simple Write/Read-CSR example is from [UVVM_Community_VIPs](https://github.com/UVVM/UVVM_Community_VIPs), it consists of DUT (design under test) included a IPbus's transactor (or called bus master) and 32-bit CSR (Control/Status Register) with a depth of 4, transactor BFM (Bus Function Mode) and top-level design.

In theses example, you can learn how to used transactor BFM to generate stimulus or modify the DUT based yours needs.

The write/read-CSR example can be organized by yourself, or you download in this repository tagged with "verify_ctrlreg".
### 2. Payload example


### 3. Other example
Jadpix Test: https://github.com/habrade/JadePix3_Firmware

 