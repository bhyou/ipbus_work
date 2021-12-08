--========================================================================================================================
-- Copyright (c) 2017 by Bitvis AS.  All rights reserved.

-- You should have received a copy of the license file containing the MIT License (see LICENSE.TXT), if not,
-- contact Bitvis AS <support@bitvis.no>.
--========================================================================================================================
-- Copyright (c) 2019 by Michał Kruszewski. All rights reserved.
--
-- All IPbus Bus Functional Model files are provided with the same MIT License as the rest of the UVVM infrastrucutre.
--=======================================================================================================================
-- UVVM AND ANY PART THEREOF ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
-- WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
-- OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH UVVM OR THE USE OR OTHER DEALINGS IN UVVM.
--========================================================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library ipbus;
use work.ipbus.all;
use work.ipbus_trans_decl.all;
use work.ipbus_reg_types.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library work;
use work.ipbus_bfm_pkg.all;

entity ipbus_bfm_tb is
  generic (
    NUM_IPBUS_CTRL_REGISTERS : positive := 4;
    NUM_IPBUS_STAT_REGISTERS : positive := 4
  );
end entity;

architecture behavioral of ipbus_bfm_tb is

  constant IPB_CLK_PERIOD : time := C_IPBUS_USUAL_CLK_PERIOD; -- 31.25 MHz
  constant SYS_CLK_PERIOD : time := 5 ns;                     -- 200 MHz

  signal ipb_clk : std_logic := '0';
  signal ipb_rst : std_logic := '0';

	signal ipbus_transactor_inputs  : t_ipbus_transactor_inputs := C_IPBUS_TRANSACTOR_INPUTS_DEFAULT;
	signal ipbus_transactor_outputs : t_ipbus_transactor_outputs ;

	signal sys_clk : std_logic := '0';
	signal sys_rst : std_logic := '0';

  -- declare signal for payload example
  signal nuke, userled : std_logic ;
  signal soft_rst      : std_logic ;

  --===============================================================================================
  -- Examples showing how to define IPbus transaction signals.
  --
  -- Note that the direction of ranges for transaction bodyy is "to"!
  --
  -- Unfortunately user has to explicitly define length of the bodyy.
  -- Length of the bodyy always equals to the length of the data user sends + 1.
  -- If you know how to define request transaction signals in more
  -- user friendly way please submit an issue on github!
  -- In case of insufficient bodyy length you will get some error at runtime.
  --===============================================================================================

  -- the ranges of read transaction boddy is fixed to 0
  -- read transaction: base_address + length (<4)

  -- testing for slave0 (control/status registers with a depth of 1)
	constant C_WRITE_SLV0_CR_DATA : t_ipbus_slv_array(0 to 0)
					:= (0 => X"12345678");
  signal write_slv0_request_transaction : t_ipbus_transaction(bodyy(0 to 1))
         := ipbus_write_transaction(X"00000000", 1, C_WRITE_SLV0_CR_DATA);

  signal read_slv0_request_transaction : t_ipbus_transaction(bodyy(0 to 0))
         := ipbus_read_transaction(X"00000000", 2);

  -- testing for slave1
	-- The slave1's address is from X"00000002" to X"00000FFF", 
	-- however, the actual depth of it is 1.
  constant C_WRITE_SLV1_DATA : t_ipbus_slv_array(0 to 3)
           := (0 => X"00001234", 1 => X"00012345", 2 => X"00123456", 3 => X"01234567");
  signal write_slv1_request_transaction : t_ipbus_transaction(bodyy(0 to 4))
         := ipbus_write_transaction(X"00000002", 1, C_WRITE_SLV1_DATA);  

	signal read_slv1_request_transaction : t_ipbus_transaction(bodyy(0 to 0))
					:= ipbus_read_transaction(X"00000002",1);

  -- testing for slave2 1kword RAM X"00001000" ~ X"00001FFF"
  constant C_WRITE_SLV2_HEAD_DATA : t_ipbus_slv_array(0 to 3)
           := (0 => X"01020304", 1 => X"02030405", 2 => X"03040506", 3 => X"04050607");
  signal write_slv2_head_request_transaction : t_ipbus_transaction(bodyy(0 to 4))
         := ipbus_write_transaction(X"00001000", 4, C_WRITE_SLV2_HEAD_DATA);

  constant C_WRITE_SLV2_TAIL_DATA : t_ipbus_slv_array(0 to 3)
           := (0 => X"0F0E0D0C", 1 => X"0E0D0C0B", 2 => X"0D0C0B0A", 3 => X"0C0B0A09");
  signal write_slv2_tail_request_transaction : t_ipbus_transaction(bodyy(0 to 4))
         := ipbus_write_transaction(X"00001FFC", 4, C_WRITE_SLV2_TAIL_DATA);

	signal read_slv2_head_request_transaction : t_ipbus_transaction(bodyy(0 to 0))
					:= ipbus_read_transaction(X"00001000",3);
	signal read_slv2_tail_request_transaction : t_ipbus_transaction(bodyy(0 to 0))
					:= ipbus_read_transaction(X"00001FFC",3);

  -- testing for slave3 peephole RAM: X"00002000" ~ X"00001FFF"
  constant C_WRITE_SLV3_DATA : t_ipbus_slv_array(0 to 1)
           := (0 => X"00000064", 1 => X"12345678");   -- address : X"64" data: X"12345678"
  signal write_slv3_request_transaction : t_ipbus_transaction(bodyy(0 to 2))
         := ipbus_write_transaction(X"00002000", 2, C_WRITE_SLV3_DATA);

	-- others operation testing
  signal non_inc_read_slv2_request_transaction : t_ipbus_transaction(bodyy(0 to 0))
         := ipbus_non_inc_read_transaction(X"00001001", 3);

  signal non_inc_write_slv1_request_transaction : t_ipbus_transaction(bodyy(0 to 4))
         := ipbus_non_inc_write_transaction(X"00000002", 4, C_WRITE_SLV1_DATA);

  signal rmw_bits_slv1_request_transaction : t_ipbus_transaction(bodyy(0 to 2))
         := ipbus_rmw_bits_transaction(X"00000002", X"FFFF0000", X"0000ABCD");

  signal rmw_sum_slv1_request_transaction : t_ipbus_transaction(bodyy(0 to 1))
         := ipbus_rmw_sum_transaction(X"00000002", X"00000002");

  signal response_transaction : t_ipbus_transaction(bodyy(0 to 2));

begin

  ipb_clk <= not ipb_clk after IPB_CLK_PERIOD/2;
  sys_clk <= not sys_clk after SYS_CLK_PERIOD/2;

  payload_inst : entity work.payload
    port map(
      ipb_clk => ipb_clk,
      ipb_rst => ipb_rst,
      ipb_in => ipbus_transactor_outputs.ipb_out,
      ipb_out => ipbus_transactor_inputs.ipb_in,
      clk => sys_clk,
      rst => sys_rst,
      nuke => nuke,
      soft_rst => soft_rst,
      userled => userled
    );

  -- Instantiate the IPbus transactor wrapper. It is necessary.
  ipbus_transactor_wrapper_0 : entity work.ipbus_transactor_wrapper
      port map (
          clk => ipb_clk,
          rst => ipb_rst,
          ipbus_transactor_inputs => ipbus_transactor_inputs,
          ipbus_transactor_outputs => ipbus_transactor_outputs
      );

  main: process
  begin
    wait for 2*IPB_CLK_PERIOD;

    gen_pulse(ipb_rst, 2 * IPB_CLK_PERIOD, "Reset pulse");
    wait for 2*IPB_CLK_PERIOD;

		-- transaction for slave 0
    ipbus_transact(write_slv0_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    ipbus_transact(read_slv0_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    check_value(response_transaction.bodyy(0), X"12345678", FAILURE,
                "Checking slave 0 read transaction.");
    check_value(response_transaction.bodyy(1), X"abcdfedc", FAILURE,
                "Checking slave 0 read transaction.");

		-- transaction for slave 1
    ipbus_transact(write_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    ipbus_transact(read_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    check_value(response_transaction.bodyy(0), C_WRITE_SLV1_DATA(0), FAILURE,
                "Checking slave 1 read transaction.");

		-- transaction for slave 2
    ipbus_transact(write_slv2_head_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    ipbus_transact(read_slv2_head_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    check_value(response_transaction.bodyy(0), C_WRITE_SLV2_HEAD_DATA(0), FAILURE,
                "Checking slave2-head ead transaction.");
    check_value(response_transaction.bodyy(1), C_WRITE_SLV2_HEAD_DATA(1), FAILURE,
                "Checking slave2-head read transaction.");
    check_value(response_transaction.bodyy(2), C_WRITE_SLV2_HEAD_DATA(2), FAILURE,
                "Checking slave2-head read transaction.");

    ipbus_transact(write_slv2_tail_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    ipbus_transact(read_slv2_tail_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    check_value(response_transaction.bodyy(0), C_WRITE_SLV2_TAIL_DATA(0), FAILURE,
                "Checking slave2-tail read transaction.");
    check_value(response_transaction.bodyy(1), C_WRITE_SLV2_TAIL_DATA(1), FAILURE,
                "Checking slave2-tail read transaction.");
    check_value(response_transaction.bodyy(2), C_WRITE_SLV2_TAIL_DATA(2), FAILURE,
                "Checking slave2-tail read transaction.");

		-- transaction for slave 3
    ipbus_transact(write_slv3_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);

		-- testing for other operations
    ipbus_transact(non_inc_read_slv2_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    check_value(response_transaction.bodyy(0), C_WRITE_SLV2_HEAD_DATA(1), FAILURE,
                "Checking non-incrementing read transaction.");
    check_value(response_transaction.bodyy(0), C_WRITE_SLV2_HEAD_DATA(1), FAILURE,
                "Checking non-incrementing read transaction.");
    check_value(response_transaction.bodyy(0), C_WRITE_SLV2_HEAD_DATA(1), FAILURE,
                "Checking non-incrementing read transaction.");

    ipbus_transact(non_inc_write_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    ipbus_transact(read_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    check_value(response_transaction.bodyy(0), C_WRITE_SLV1_DATA(3), FAILURE,
                "Checking non-incrementing read transaction.");


    ipbus_transact(rmw_bits_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    ipbus_transact(read_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
		-- (01234567 & FFFF0000) | 0000ABCD --> 0123ABCD
    check_value(response_transaction.bodyy(0), X"0123ABCD", FAILURE,  
                "Checking read/modify/write bits transaction.");

    ipbus_transact(rmw_sum_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
    ipbus_transact(read_slv1_request_transaction,
                   response_transaction,
                   ipbus_transactor_inputs,
                   ipbus_transactor_outputs,
                   ipb_clk);
		--  0x0123ABCD + 2 = 0x0123ABCF
    check_value(response_transaction.bodyy(0), X"0123ABCF", FAILURE,
                "Checking read/modify/write sum transaction.");

    wait for 5*IPB_CLK_PERIOD;
    std.env.stop;
  end process;

end behavioral;
