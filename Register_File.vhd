----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/15 20:16:24
-- Design Name: 
-- Module Name: Register_File - Behavioral
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_File is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          
          -- register id that will be read or write
          read_addr_1 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          read_addr_2 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          write_addr  : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          
          -- the data that will be written in registers or read out from registers
          write_data  : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          read_data_1 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
          read_data_2 : out STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
end Register_File;

architecture Behavioral of Register_File is
    
    type register_array is ARRAY (31 DOWNTO 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    constant registers_32_rst : register_array := (
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000",
    "00000000000000000000000000000000", "00000000000000000000000000000000"
    );
    signal registers_32 : register_array := registers_32_rst;
    
begin
    
    -- write data into write_addr of register file
    process(clk, rst) begin
        if (rst = '1') then
            registers_32 <= registers_32_rst;
        elsif (clk'event and clk = '1') then
            if (write_addr /= "00000") then -- R0 should always be 0 and cannot be written in other data
                registers_32(CONV_INTEGER(write_addr)) <= write_data;
            end if;
        end if;
    end process;
    
    -- R0 of registers is special that it is read-only and is always zero
    registers_32(0) <= "00000000000000000000000000000000";
    
    -- write data from read_addr of register file
    read_data_1 <= registers_32(CONV_INTEGER(read_addr_1));
    read_data_2 <= registers_32(CONV_INTEGER(read_addr_2));
    
end Behavioral;
