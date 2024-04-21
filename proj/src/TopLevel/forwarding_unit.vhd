-------------------------------------------------------------------------
-- Fadahunsi Adeife
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- forwarding_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the pipeline forwarding unit.
--
-- 2/29/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.MIPS_types.all;

entity forwarding_unit is
    generic(
        M : integer := SELECT_WIDTH
        N : integer := DATA_WIDTH
    );

    port(
        i_ID_EX_RegRs          : in std_logic_vector(N-1 downto 0);
        i_ID_EX_RegRt          : in std_logic_vector(N-1 downto 0);
        i_EX_MEM_RegRd         : in std_logic_vector(N-1 downto 0);
        i_EX_MEM_wb            : in std_logic;
        i_MEM_WB_wb            : in std_logic;
        i_MEM_WB_RegRd         : in std_logic_vector(N-1 downto 0);
        i_WB_WB_RegRd         : in std_logic_vector(N-1 downto 0);
        i_MEM_Rd_addr          : in std_logic_vector(M-1 downto 0);
        i_WB_Rd_addr           : in std_logic_vector(M-1 downto 0);
        o_Dmem                 : out std_logic;
        o_LSmux                : out std_logic_vector(1 downto 0);    -- 2bits, 00. 01. 10. 11
        o_RSmux                : out std_logic_vector(1 downto 0)     -- 2bits, 00. 01. 10. 11
    );
end forwarding_unit;

architecture behavior of forwarding_unit is
begin
    o_DH <= '1' when ((i_MemRd = '1')  and ((i_EXRegRt = i_IDRegRs) or (i_EXRegRt = i_IDRegRt))) else '0';
    -- format:
    -- 00, no hazard
    -- 01, mem hazard
    -- 10, ex hazard

    o_LSmux <=  "01" when ()
                "10" when (i_EX_MEM_wb = '1' and (not (i_MEM_Rd_addr = "00000")) and (i_EX_MEM_RegRd == i_ID_EX_RegRs)) else  -- forward left mux to alu
                "00";

    o_RSmux <= "10" when (i_EX_MEM_wb = '1' and (not (i_MEM_Rd_addr = "00000")) and (i_EX_MEM_RegRd == i_ID_EX_RegRt)) else   -- forward right mux to alu
                "00";
end behavior;