-------------------------------------------------------------------------
-- joopixel1
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- HDU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the hazard detection unit.
--
-- 2/29/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.MIPS_types.all;

entity HDU is
    generic(
        M : integer := SELECT_WIDTH
    );

    port(
        i_MemRd         : in std_logic;
        i_EXRegRt       : in std_logic_vector(M-1 downto 0);
        i_IDRegRs       : in std_logic_vector(M-1 downto 0);
        i_IDRegRt       : in std_logic_vector(M-1 downto 0);
        i_PCSel         : in std_logic_vector(1 downto 0);
        o_DH            : out std_logic;
        o_CH            : out std_logic;
        o_BH            : out std_logic
    );
end HDU;

architecture behavior of HDU is
begin
    o_DH <= '1' when ((i_MemRd = '1')  and ((i_EXRegRt = i_IDRegRs) or (i_EXRegRt = i_IDRegRt))) else '0';
    o_CH <= '1' when (i_PCSel = "01") else '0';
    o_BH <= '1' when (i_PCSel = "10" or i_PCSel = "11") else '0';
end behavior;
