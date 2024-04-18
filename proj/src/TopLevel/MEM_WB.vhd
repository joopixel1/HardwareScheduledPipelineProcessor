-------------------------------------------------------------------------
-- Fadahunsi Adeife
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- IF_ID.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the memory to writeback
-- register for the pipelined processor.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.MIPS_types.all;

entity MEM_WB is

    generic(
        N           : positive;
        M           : positive
    );


    port (
        i_CLK           : in std_logic;
        i_RST           : in std_logic;
        i_STALL         : in std_logic;
        i_FLUSH         : in std_logic;
        i_ALUOut        : in std_logic_vector(N-1 downto 0);
        i_DMEMOut       : in std_logic_vector(N-1 downto 0);
        i_PartialMemOut : in std_logic_vector(N-1 downto 0);
        i_RegWrAddr     : in std_logic_vector(M-1 downto 0);
        i_PCInc         : in std_logic_vector(N-1 downto 0);
        i_WBControl     : in wb_control_t;
        o_ALUOut        : out std_logic_vector(N-1 downto 0);
        o_DmemOut       : out std_logic_vector(N-1 downto 0);
        o_PartialMemOut : out std_logic_vector(N-1 downto 0);
        o_RegWrAddr     : out std_logic_vector(M-1 downto 0);
        o_PCInc         : out std_logic_vector(N-1 downto 0);
        o_WBControl     : out wb_control_t
    );
end entity MEM_WB;

architecture behavior of MEM_WB is
    
    constant zero_wb_control : wb_control_t                           := (
        halt                => '0',
        reg_wr              => '0',
        reg_wr_sel          => "00"
    );

    signal s_WE      : std_logic_vector(N-1 downto 0); 

    component n_dffg
        generic (
            N  : positive := N
        );
        port (
            i_CLK : in std_logic;
            i_RST : in std_logic;
            i_WE  : in std_logic;
            i_D   : in std_logic_vector(N-1 downto 0);
            o_Q   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component wb_dffg
        port (
            i_CLK   : in std_logic;
            i_RST   : in std_logic;
            i_WE    : in std_logic;
            i_D     : in wb_control_t;
            o_Q     : out wb_control_t
        );
    end component;

begin

    s_WE <= '0' when (i_STALL = '1') else '1';

    -- Instantiate D flip-flops for each input
    ALUOut_dffg: n_dffg
    port map (
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => s_WE,
        i_D   => x"00000000" when (i_FLUSH = '1') else i_ALUOut,
        o_Q   => o_ALUOut
    );

    DMEMOut_dffg: n_dffg
    port map (
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => s_WE,
        i_D   => x"00000000" when (i_FLUSH = '1') else i_DMEMOut,
        o_Q   => o_DmemOut
    );

    PartialMemOut_dffg: n_dffg
    port map (
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => s_WE,
        i_D   => x"00000000" when (i_FLUSH = '1') else i_PartialMemOut,
        o_Q   => o_PartialMemOut
    );

    PCInc_dffg: n_dffg
    port map (
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => s_WE,
        i_D   => x"00000000" when (i_FLUSH = '1') else i_PCInc,
        o_Q   => o_PCInc
    );

    RegWrAddr_dffg: n_dffg
    generic map(
        N       => M
    )
    port map (
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => s_WE,
        i_D   => "00000" when (i_FLUSH = '1') else i_RegWrAddr,
        o_Q   => o_RegWrAddr
    );

    -- Instantiate flip-flop for WB control signal
    WBControl_dffg: wb_dffg
    port map (
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => s_WE,
        i_D   => zero_wb_control when (i_FLUSH = '1') else i_WBControl,
        o_Q   => o_WBControl
    );

end architecture behavior;
