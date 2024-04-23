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
    );

    port(
        i_ID_EX_RegRs          : in std_logic_vector(M-1 downto 0);
        i_ID_EX_RegRt          : in std_logic_vector(M-1 downto 0);
        i_EX_MEM_RegWrite      : in std_logic;
        i_MEM_WB_RegWrite      : in std_logic;
        i_EX_MEM_Rd_addr       : in std_logic_vector(M-1 downto 0);
        i_MEM_WB_Rd_addr       : in std_logic_vector(M-1 downto 0);
        o_LSmux                : out std_logic_vector(1 downto 0);    -- 2bits, 00. 01. 10. 11
        o_RSmux                : out std_logic_vector(1 downto 0)     -- 2bits, 00. 01. 10. 11
    );
end forwarding_unit;

architecture behavior of forwarding_unit is

begin
    -- format:
    -- 00, no hazard
    -- 01, mem hazard
    -- 10, ex hazard

    o_LSmux <=  "01" when ((i_MEM_WB_RegWrite = '1' and (i_MEM_WB_Rd_addr /= "00000")) and ( not ((i_EX_MEM_RegWrite = '1') and (i_EX_MEM_Rd_addr /= "00000") and (i_EX_MEM_Rd_addr = i_ID_EX_RegRs))) and (i_MEM_WB_Rd_addr = i_ID_EX_RegRs)) else 
                "10" when ((i_EX_MEM_RegWrite = '1' and (i_EX_MEM_Rd_addr /= "00000")) and (i_EX_MEM_Rd_addr = i_ID_EX_RegRs)) else  -- forward left mux to alu
                "00";

    o_RSmux <=  "01" when ((i_MEM_WB_RegWrite = '1' and (i_MEM_WB_Rd_addr /= "00000")) and ( not ((i_EX_MEM_RegWrite = '1') and (i_EX_MEM_Rd_addr /= "00000") and (i_EX_MEM_Rd_addr = i_ID_EX_RegRt))) and (i_MEM_WB_Rd_addr = i_ID_EX_RegRt)) else
                "10" when ((i_EX_MEM_RegWrite = '1' and (i_EX_MEM_Rd_addr /= "00000")) and (i_EX_MEM_Rd_addr = i_ID_EX_RegRt)) else   -- forward right mux to alu
                "00";


end behavior;