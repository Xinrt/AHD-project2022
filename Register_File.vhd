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
          
          -- control signal
          read_or_write : in STD_LOGIC_VECTOR (1 DOWNTO 0);
          
          -- register id that will be read or write
          read_addr_1 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          read_addr_2 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          write_addr  : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          
          -- the data that will be written in registers or read out from registers
          write_data  : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          read_data_1 : out STD_LOGIC_VECTOR (31 DOWNTO 0) := "00000000000000000000000000000000";
          read_data_2 : out STD_LOGIC_VECTOR (31 DOWNTO 0) := "00000000000000000000000000000000"
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
    
    process(clk, rst) begin
        
        -- reset
        if (rst = '1') then
            registers_32 <= registers_32_rst;
            read_data_1 <= "00000000000000000000000000000000";
            read_data_2 <= "00000000000000000000000000000000";
                
        elsif (clk'event and clk = '1') then
             -- write data into write_addr of register file
            if (read_or_write(0) = '1') then
                if (write_addr /= "00000") then -- R0 should always be 0 and cannot be written in other data
                    registers_32(CONV_INTEGER(write_addr)) <= write_data;
                else
                    registers_32(0) <= "00000000000000000000000000000000"; -- R0 is always zero
                end if;
            end if;
            
            -- read data from read_addr of register file
            if (read_or_write(1) = '1') then
                report ("1!!");
                read_data_1 <= registers_32(CONV_INTEGER(read_addr_1));
                read_data_2 <= registers_32(CONV_INTEGER(read_addr_2));
            else 
                report ("0!!");

                read_data_1 <= "00000000000000000000000000000000";
                read_data_2 <= "00000000000000000000000000000000";
            end if;
            
        end if;
    end process;
    
end Behavioral;
