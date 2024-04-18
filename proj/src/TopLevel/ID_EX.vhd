-------------------------------------------------------------------------
-- Fadahunsi Adeife
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ID_EX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the decode to execute
-- register for the pipelined processor.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.MIPS_types.all;

entity ID_EX is

    generic(
        N           : positive;
        M           : positive
    );

    port(
        i_CLK           : in std_logic;
        i_RST           : in std_logic;
        i_STALL         : in std_logic;
        i_FLUSH         : in std_logic;
        i_Reg1Out       : in std_logic_vector(N-1 downto 0);
        i_Reg2Out       : in std_logic_vector(N-1 downto 0);
        i_Shamt         : in std_logic_vector(N-1 downto 0);
        i_ZeroExt       : in std_logic_vector(N-1 downto 0);
        i_SignExt       : in std_logic_vector(N-1 downto 0);
        i_PCInc         : in std_logic_vector(N-1 downto 0);
        i_RegWrAddr     : in std_logic_vector(M-1 downto 0);
        i_EXControl     : in ex_control_t;
        i_MEMControl    : in mem_control_t;
        i_WBControl     : in wb_control_t;
        o_Reg1Out       : out std_logic_vector(N-1 downto 0);
        o_Reg2Out       : out std_logic_vector(N-1 downto 0);
        o_Shamt         : out std_logic_vector(N-1 downto 0);
        o_ZeroExt       : out std_logic_vector(N-1 downto 0);
        o_SignExt       : out std_logic_vector(N-1 downto 0);
        o_PCInc         : out std_logic_vector(N-1 downto 0);
        o_RegWrAddr     : out std_logic_vector(M-1 downto 0);
        o_EXControl     : out ex_control_t;
        o_MEMControl    : out mem_control_t;
        o_WBControl     : out wb_control_t
    ); 
end ID_EX;

architecture structure of ID_EX is

    constant zero_alu_control   : alu_control_t                 := (
        allow_ovfl          => '0',
        alu_select          => "1111"
    );
    constant zero_ex_control : ex_control_t                           := (
        alu_control         => zero_alu_control,
        alu_input1_sel      => '0',
        alu_input2_sel      => "00"
    );
    constant zero_mem_control : mem_control_t                           := (
        mem_wr              => '0',
        mem_rd              => '0',
        partial_mem_sel     => "00"
    );
    constant zero_wb_control : wb_control_t                           := (
        halt                => '0',
        reg_wr              => '0',
        reg_wr_sel          => "00"
    );

    signal s_WE                 : std_logic;
    signal s_Reg1Out            : std_logic_vector(N-1 downto 0);
    signal s_Reg2Out            : std_logic_vector(N-1 downto 0);
    signal s_Shamt              : std_logic_vector(N-1 downto 0);
    signal s_ZeroExt            : std_logic_vector(N-1 downto 0);
    signal s_SignExt            : std_logic_vector(N-1 downto 0);
    signal s_PCInc              : std_logic_vector(N-1 downto 0);
    signal s_RegWrAddr          : std_logic_vector(M-1 downto 0);
    signal s_EXControl          : ex_control_t;
    signal s_MEMControl         : mem_control_t;
    signal s_WBControl          : wb_control_t;

    component n_dffg
        generic(
            N           :positive   := N
        );

        port(
            i_CLK        : in std_logic;                          
            i_RST        : in std_logic;                         
            i_WE         : in std_logic;                         
            i_D          : in std_logic_vector(N-1 downto 0);   
            o_Q          : out std_logic_vector(N-1 downto 0)      
        );
    end component;

    component ex_dffg
        port(
            i_CLK        : in std_logic;                            -- Clock input
            i_RST        : in std_logic;                            -- Reset input
            i_WE         : in std_logic;                            -- Write enable input
            i_D          : in ex_control_t;                         -- Data value input
            o_Q          : out ex_control_t                         -- Data value output
        );
    end component;

    component mem_dffg
        port(
            i_CLK        : in std_logic;                            -- Clock input
            i_RST        : in std_logic;                            -- Reset input
            i_WE         : in std_logic;                            -- Write enable input
            i_D          : in mem_control_t;                       -- Data value input
            o_Q          : out mem_control_t                       -- Data value output
        );
    end component;

    component wb_dffg
        port(
            i_CLK        : in std_logic;                            -- Clock input
            i_RST        : in std_logic;                            -- Reset input
            i_WE         : in std_logic;                            -- Write enable input
            i_D          : in wb_control_t;                        -- Data value input
            o_Q          : out wb_control_t                        -- Data value output
        );
    end component;

begin

    s_WE <= '0' when (i_STALL = '1') else '1';

    -- Reg1Out flip-flop
    s_Reg1Out <= (others => '0') when i_FLUSH = '1' else i_Reg1Out;
    Reg1Out_dffg: n_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_Reg1Out,
        o_Q => o_Reg1Out
    );

    -- Reg2Out flip-flop
    s_Reg2Out <= (others => '0') when i_FLUSH = '1' else i_Reg2Out;
    Reg2Out_dffg: n_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_Reg2Out,
        o_Q => o_Reg2Out
    );
        
    -- ShamOut flip-flop
    s_Shamt <= (others => '0') when i_FLUSH = '1' else i_Shamt;
    ShamOut_dffg: n_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_Shamt,
        o_Q => o_Shamt
    );

    -- ZeroExt flip-flop
    s_ZeroExt <= (others => '0') when i_FLUSH = '1' else i_ZeroExt;
    ZeroExt_dffg: n_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_ZeroExt,
        o_Q => o_ZeroExt
    );

    -- SignExt flip-flop
    s_SignExt <= (others => '0') when i_FLUSH = '1' else i_SignExt;
    SignExt_dffg: n_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_SignExt,
        o_Q => o_SignExt
    );

    -- PCInc flip-flop
    s_PCInc <= (others => '0') when i_FLUSH = '1' else i_PCInc;
    PCInc_dffg: n_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_PCInc,
        o_Q => o_PCInc
    );

    -- RegWrAddr flip-flop
    s_RegWrAddr <= "00000" when i_FLUSH = '1' else i_RegWrAddr;
    RegWrAddr_dffg: n_dffg
    generic map(
        N => M
    )
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_RegWrAddr,
        o_Q => o_RegWrAddr
    );

    -- Instantiate flip-flops for control signals

    -- EXControl flip-flop
    s_EXControl <= zero_ex_control when i_FLUSH = '1' else i_EXControl;
    EXControl_dffg: ex_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_EXControl,
        o_Q => o_EXControl
    );

    -- MEMControl flip-flop
    s_MEMControl <= zero_mem_control when i_FLUSH = '1' else i_MEMControl;
    MEMControl_dffg: mem_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_MEMControl,
        o_Q => o_MEMControl
    );

    -- WBControl flip-flop
    s_WBControl <= zero_wb_control when i_FLUSH = '1' else i_WBControl;
    WBControl_dffg: wb_dffg
    port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_D => s_WBControl,
        o_Q => o_WBControl
    );

end structure;
