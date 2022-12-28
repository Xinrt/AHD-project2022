----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/12/15 02:54:42
-- Design Name: 
-- Module Name: tb_main2_processor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use work.reg_32_pkg.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_main2_processor is
--  Port ( );
end tb_main2_processor;

architecture Behavioral of tb_main2_processor is

    signal t_clk : STD_LOGIC;
    signal t_rst : STD_LOGIC;
    signal t_en  : STD_LOGIC;
    signal t_sw    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal t_reg : reg_32;
    
begin

    processor0 : entity work.processor
    port map(
        clk0 => t_clk,
        rst0 => t_rst,
        en0  => t_en,
        sw   => t_sw,
        regfile => t_reg
    );
    
    clk_run : process
    begin
        t_clk <= '0';
        wait for 5ns;  
        t_clk <= '1';
        wait for 5ns; 
    end process;
    
--    read_file : process
--    begin
--    end process;

    run_processor : process
    begin
        t_en <= '0';
        t_rst <= '0';
        wait for 10ns;
        
        -- check whether the contents in all registers are 0
        assert (t_reg(0) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(1) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(2) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(3) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(4) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(5) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(6) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(7) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(8) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(9) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(10) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(11) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(12) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(13) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(14) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;

        assert (t_reg(15) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(16) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(17) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(18) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(19) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(20) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(21) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(22) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(23) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(24) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(25) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(26) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(27) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(28) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(29) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(30) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(31) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        -- run all of the instruction in current file main.mem(defined in imem component)
        t_en <= '1';
        wait for 2000ns;
        
        -- check whether the contents in registers are same with correct values
        assert (t_reg(0) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(1) = x"ffffff01") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(2) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(3) = x"00000001") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(4) = x"ffffff00") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(5) = x"ffffff03") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(6) = x"00000001") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(7) = x"fffff808") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(8) = x"1fffffe0") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(9) = x"ffffffe0") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(10) = x"ffffff02") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(11) = x"ffffff00") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(12) = x"fffffe02") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(13) = x"00000001") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(14) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;

        assert (t_reg(15) = x"ffffff00") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(16) = x"7fffff80") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(17) = x"ffffff80") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(18) = x"ffffff01") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(19) = x"00000001") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(20) = x"fff01000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(21) = x"00f01050") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(22) = x"00000010") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(23) = x"80000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(24) = x"00000003") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(25) = x"ffffff03") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(26) = x"ffffff03") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(27) = x"00000003") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(28) = x"0000ff03") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(29) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(30) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        assert (t_reg(31) = x"00000000") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;        
        
        assert false
        report("all tests passed")
        severity FAILURE;
        
    end process;


end Behavioral;
