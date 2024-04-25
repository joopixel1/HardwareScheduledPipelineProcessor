-------------------------------------------------------------------------
-- joopixel1
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_alu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the adder subtractor unit.
--              
-- 01/03/2020 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.MIPS_types.all;

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_pip_reg is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_pip_reg;

architecture mixed of tb_pip_reg is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component IF_ID 
  generic(
      N          :positive       := DATA_WIDTH;
      M           : positive      := SELECT_WIDTH
  );    

  port(
      i_CLK           : in std_logic;
      i_RST           : in std_logic;
      i_STALL         : in std_logic;
      i_FLUSH         : in std_logic;
      i_PCInc         : in std_logic_vector(N-1 downto 0);
      i_Inst          : in std_logic_vector(N-1 downto 0);
      o_PCInc         : out std_logic_vector(N-1 downto 0);
      o_Inst          : out std_logic_vector(N-1 downto 0)
  ); 
end component;


-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal if_id_stall   : std_logic;
signal if_id_flush   : std_logic;
signal id_ex_stall   : std_logic;
signal id_ex_flush   : std_logic;
signal ex_mem_stall   : std_logic;
signal ex_mem_flush   : std_logic;
signal mem_wb_stall   : std_logic;
signal mem_wb_flush   : std_logic;
signal if_PCInc      : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of PCInc
signal if_Inst       : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of Inst
signal id_PCInc      : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of PCInc
signal id_Inst       : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of Inst
signal ex_PCInc      : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of PCInc
signal ex_Inst       : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of Inst
signal mem_PCInc     : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of PCInc
signal mem_Inst      : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of Inst
signal wb_PCInc      : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of PCInc
signal wb_Inst       : std_logic_vector(DATA_WIDTH-1 downto 0); -- Assuming DATA_WIDTH is the width of Inst


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: IF_ID
  port map(
    i_CLK           => CLK,
    i_RST           => reset,
    i_STALL         => if_id_stall,
    i_FLUSH         => if_id_flush,
    i_PCInc         => if_PCInc,
    i_Inst          => if_Inst,
    o_PCInc         => id_PCInc,
    o_Inst          => id_Inst
  ); 

  DUT1: IF_ID
  port map(
    i_CLK           => CLK,
    i_RST           => reset,
    i_STALL         => id_ex_stall,
    i_FLUSH         => id_ex_flush,
    i_PCInc         => id_PCInc,
    i_Inst          => id_Inst,
    o_PCInc         => ex_PCInc,
    o_Inst          => ex_Inst
  ); 

  DUT2: IF_ID
  port map(
    i_CLK           => CLK,
    i_RST           => reset,
    i_STALL         => ex_mem_stall,
    i_FLUSH         => ex_mem_flush,
    i_PCInc         => ex_PCInc,
    i_Inst          => ex_Inst,
    o_PCInc         => mem_PCInc,
    o_Inst          => mem_Inst
  ); 

  DUT3: IF_ID
  port map(
    i_CLK           => CLK,
    i_RST           => reset,
    i_STALL         => mem_wb_stall,
    i_FLUSH         => mem_wb_flush,
    i_PCInc         => mem_PCInc,
    i_Inst          => mem_Inst,
    o_PCInc         => wb_PCInc,
    o_Inst          => wb_Inst
  ); 
  
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- TODO: add test cases as needed (at least 3 more for this lab)

      -- Test case for addition
  if_PCInc <= x"00000001";  -- Input 1 (e.g., 1)
  if_Inst <= x"00000001";  -- Input 2 (e.g., 2)
  wait for gCLK_HPER * 2;
  -- Check outputs here for addition operation

  -- Test case for subtraction
  if_PCInc <= x"00000002";  -- Input 1 (e.g., 1)
  wait for gCLK_HPER * 2;
  -- Check outputs here for subtraction operation

  -- Test case for AND operation
  if_PCInc <= x"00000003";  -- Input 1 (e.g., 1)
  wait for gCLK_HPER * 2;
  -- Check outputs here for AND operation

  -- Test case for OR operation
  if_PCInc <= x"00000004";  -- Input 1 (e.g., 1)
  wait for gCLK_HPER * 2;
  wait for gCLK_HPER * 2;
  wait for gCLK_HPER * 2;
  -- Check outputs here for OR operation

  -- Test case for addition
  if_PCInc <= x"00000005";  -- Input 1 (e.g., 1)
  if_Inst <= x"00000005";  -- Input 2 (e.g., 2)
  wait for gCLK_HPER * 2;
  -- Check outputs here for addition operation

  -- Test case for subtraction
  if_PCInc <= x"00000006";  -- Input 1 (e.g., 1)
  if_Inst <= x"00000006";  -- Input 2 (e.g., 2)
  wait for gCLK_HPER * 2;
  -- Check outputs here for subtraction operation

  -- Test case for subtraction
  if_PCInc <= x"00000006";  -- Input 1 (e.g., 1)
  if_Inst <= x"00000006";  -- Input 2 (e.g., 2)
  id_ex_stall <= '1';
  ex_mem_flush <= '1';
  wait for gCLK_HPER * 2;
  -- Check outputs here for subtraction operation


    wait;
  end process;

end mixed;