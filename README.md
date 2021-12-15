# **IPbus work**

IPbus_work is a chip test project based on IPbus. The IPbus which is a simple packet-based control protocol is developed by CERN. More details of IPbus see: https://github.com/ipbus.

## **Verification Example**
Note: before running verification example, you must compile UVVM utility library:
 ```bash
  cd src/UVVM/uvvm_util/script/
  vsim -c -do "compile_src.do"
 ```

###  **1. Write/Read-CSR example**
-------------------------------------------------------------
The simple Write/Read-CSR (Control/Status Register) example is from [UVVM_Community_VIPs](https://github.com/UVVM/UVVM_Community_VIPs), it consists of DUT (design under test) included a IPbus's transactor (or called bus master) and 32-bit CSR with a depth of 4, transactor BFM (Bus Function Mode) and top-level design.

In theses example, you can learn how to used transactor BFM to generate stimulus or modify the DUT based yours needs.

The write/read-CSR example can be organized by yourself, or you download in this repository tagged with "verify_ctrlreg".

### **2. Payload example**
-------------------------------------------------------------
Compared with the Write/Read-CSR example, almost only the DUT of payload example is different with that of Write/Read-CSR example. 
In the payload example, the DUT include the following four slaves :
  - 32-bit CSR 
  - 32-bit generic register 
  - 32-bit RAM 
  - 32-bit peephole RAM 

Address space of the slaves:
  - CSR : 0x0000_0000 ~ 0x0000_0001
    * 0x0000_0000 : Status Regsiter (only read)
    * 0x0000_0001 : Control Regsiter (write/read)
  - Reg : 0x0000_0002 ~ 0x0000_0FFF
    * **actual depth is 1**
  - RAM : 0x0000_1000 ~ 0x0000_1FFF
  - PRAM: 0x0000_2000 ~ 0x0000_2FFF


### **3. Other example**
-------------------------------------------------------------
Jadpix Test: https://github.com/habrade/JadePix3_Firmware


## **Vivado Project Example**

### **1. KC705 GMII**
run kc705 gmii demo 
```bash
    $ cd proc/kc705_gmii_demo
    $ make vivado
```
