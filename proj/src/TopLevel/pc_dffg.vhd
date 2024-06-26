-------------------------------------------------------------------------
-- joopixel1
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- n_dffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit edge-triggered
-- flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity pc_dffg is

    generic(
        N           :positive
    );

    port(
        i_CLK        : in std_logic;                            -- Clock input
        i_RST        : in std_logic;                            -- Reset input
        i_STALL      : in std_logic;                            -- Write enable input
        i_FLUSH      : in std_logic;                            -- always keep '0'
        i_D          : in std_logic_vector(N-1 downto 0);       -- Data value input
        o_Q          : out std_logic_vector(N-1 downto 0)       -- Data value output
    );

end pc_dffg;

architecture structure of pc_dffg is

    signal s_WE   : std_logic; 
    signal f_D    : std_logic_vector(N-1 downto 0);    -- flushed D
    signal s_D    : std_logic_vector(N-1 downto 0);    -- Multiplexed input to the FF
    signal s_Q    : std_logic_vector(N-1 downto 0);    -- Output of the FF

begin

  -- The output of the FF is fixed to s_Q
  o_Q <= s_Q;
  
  s_WE <= '0' when (i_STALL = '1') else '1';

  -- Create a multiplexed input to the FF based on s_WE
  f_D <= x"00000000" when (i_FLUSH = '1') else i_D;
  with s_WE select
    s_D <= f_D when '1',
           s_Q when others;
  
  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
      s_Q <= x"00400000"; -- Use "(others => '0')" for N-bit values
    elsif (rising_edge(i_CLK)) then
      s_Q <= s_D;
    end if;

  end process;
  
end structure;
