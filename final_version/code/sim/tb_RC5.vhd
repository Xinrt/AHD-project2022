----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/12/15 02:54:42
-- Design Name: 
-- Module Name: tb_RC5 - Behavioral
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

entity tb_RC5 is
--  Port ( );
end tb_RC5;

architecture Behavioral of tb_RC5 is

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
        
        -- run all of the instruction in current file main.mem(defined in imem component)
        t_en <= '1';
        wait for 24000ns;
        
        -- check whether the contents in registers are same with correct values
        
        -- the first plaintext : 123456 (in hex is 1e240)
        assert (t_reg(21) = x"0001e240") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;

        -- the second plaintext : 777888 (in hex is bdea0)
        assert (t_reg(22) = x"000bdea0") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        -- the first cipher text : 1679031343 (in hex is 6413fc2f)   
        assert (t_reg(23) = x"6413fc2f") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;
        
        -- the second cipher text : 438249255 (in hex is 1a1f2727)   
        assert (t_reg(24) = x"1a1f2727") 
        report "Test failed!"
        severity ERROR;
        wait for 10ns;

        assert false
        report("all tests passed")
        severity FAILURE;
        
    end process;


end Behavioral;
