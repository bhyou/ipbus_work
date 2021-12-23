# IPbus BFM with SystemVerilog
Thanks *Kruszewski, Michał* very much for sharing the [vip_ipbus](https://github.com/UVVM/UVVM_Community_VIPs/tree/master/vip_ipbus).

## run example
  * **dependency**: the `include ${HOME}/Library/SCRIPTS/VCSMX/VCSMX.mk` in sim/Makefile is provided at [VCS.mk](https://github.com/bhyou/ASIC-Scripts/blob/main/VCSMX/VCSMX.mk)
  ```
  $ cd sim
  $ make mixcom && ./simv
  ```
## How to Use?
  1. Declaring two transaction type variable in `ipbus_bfm_tb.sv`, one is request, another is respone. If you want writes data, a dynamic array should be declared to store write data.
  2. Using a function which returns a transaction type value. All available functions is listed in follow. 
  3. Calling the task named `ipbus_transact` to drive ipbus bfm interface. Then the ipbus_transact task returns a respone that is transaction type. 
<table>
  <tr>
    <th> Function  </th>
    <th> Request </th>
    <th> Response </th>
  </tr>
  <tr>
    <td> read_trans(base_addr,read_size) </td>
    <td> read data from base_addr to (base_addr + read_size -1) </td>
    <td> return data from base_addr to (base_addr + read_size -1) </td>
  </tr>
  <tr>
    <td> non_read_trans(base_addr,read_size) </td>
    <td> read data from base_addr, useful to reading from a FIFO </td>
    <td> returns data from base_addr with read_size times  </td>
  </tr>

  <tr>
    <td rowspan="2"> write_trans(base_addr, write_size, write_data) </td>
    <td> the parameter of write_data is a dynamic array </td>
    <td> returns the result of write  </td>
  </tr>
  <tr>
    <td> such as, write write_data[i] to (base_addr + i), i < write_size </td>
    <td> ----  </td>
  </tr>

  <tr>
    <td> non_inc_write_trans(base_addr, write_size, write_data) </td>
    <td> similiar with write_trans, expect the write address is not change. </td>
    <td> returns the result of write  </td>
  </tr>
  <tr>
    <td rowspan="2"> rmw_bits_trans(base_addr, and_term, or_term) </td>
    <td> The RMW(Read/Modify/Write) transaction is useful for seting or clearing bits. </td>
    <td> Content of base_addr as read  before the modify/write. </td>
  </tr>
  <tr>
    <td> BASE_ADDR's DATA = ((BASE_ADDR's DATA) & AND_TERM) | OR_TERM </td>
    <td> Returns the data from base_addr  </td>
  </tr>
  <tr>
    <td rowspan="2"> rmw_sum_trans(base_addr, add_term) </td>
    <td> The RMW(Read/Modify/Write) transaction is useful for adding values to register or subtracting. </td>
    <td> Content of base_addr as read before the summation.  </td>
  </tr>
  <tr>
    <td> BASE_ADDR's DATA = (BASE_ADDR's DATA) + ADD_TERM </td>
    <td> returns the result of write  </td>
  </tr>
</table>


## **Reference**
[1]. Kruszewski, Michał. "IPbus bus functional model in universal VHDL verification methodology." Photonics Applications in Astronomy, Communications, Industry, and High-Energy Physics Experiments 2019. Vol. 11176. International Society for Optics and Photonics, 2019.

[2]. [IPbus protocol V2.0](http://ohm.bu.edu/~chill90/ipbus/ipbus_protocol_v2_0.pdf)

