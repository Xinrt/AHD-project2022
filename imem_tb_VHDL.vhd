----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/12/14 23:51:38
-- Design Name: 
-- Module Name: imem_tb_VHDL - Behavioral
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
use ieee.numeric_std.all;
package imm_pkg is
    type instr_rom is array(0 to 512-1) of std_logic_vector(31 downto 0);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.imm_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity imem_tb_VHDL is
--  Port ( );
end imem_tb_VHDL;

architecture Behavioral of imem_tb_VHDL is
file file_pointer: text;
signal t_clk: std_logic;
signal t_rst: std_logic;
signal t_imemR: std_logic;
signal t_addr: std_logic_vector(31 downto 0);
signal t_instru_out: std_logic_vector(31 downto 0);
signal t_rom_words_in: instr_rom;

begin
imem: entity work.imem port map(
    clk => t_clk,
    rst => t_rst,
    imemR => t_imemR,
    addr => t_addr,
    rom_words_in => t_rom_words_in,
    instr => t_instru_out
);

process
 -- Read a *.hex file
    impure function instr_rom_readfile(FileName : STRING) return
    instr_rom is
    file FileHandle : TEXT open READ_MODE is FileName;
    variable CurrentLine : LINE;
    variable CurrentWord : std_logic_vector(31 downto 0);
    variable Result : instr_rom := (others => (others => 'X'));
    begin
    for i in 0 to 512 - 1 loop
    exit when endfile(FileHandle);
    readline(FileHandle, CurrentLine);
    hread(CurrentLine, CurrentWord);
    Result(i) := CurrentWord;
    end loop;
    return Result;
    end function;
begin
    


t_rom_words_in <= instr_rom_readfile("main.mem");
t_clk <= '0';
wait for 5ns;
t_rst <= '0';    
t_addr <= x"01000000";
wait for 5ns;
t_clk <= '1';

assert(t_instru_out/=x"00100093") report "test case error - wrong output" severity FAILURE;

report "All test cases passed successfully";
std.env.stop;
end process;

end Behavioral;
