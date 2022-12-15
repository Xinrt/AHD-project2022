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
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

package reg_32_pkg is
    type reg_32 is array(31 DOWNTO 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
end package;

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.reg_32_pkg.all;

entity rf is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          
          -- control signal
          regRW : in STD_LOGIC_VECTOR (1 DOWNTO 0);
          
          -- register id that will be read or write
          r1 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          r2 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          rd  : in STD_LOGIC_VECTOR (4 DOWNTO 0);
          
          -- the data that will be written in registers or read out from registers
          din  : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          dout1 : out STD_LOGIC_VECTOR (31 DOWNTO 0) := "00000000000000000000000000000000";
          dout2 : out STD_LOGIC_VECTOR (31 DOWNTO 0) := "00000000000000000000000000000000";
          
          -- the output register file, including 32 registers
          reg_out : out reg_32
    );
end rf;

architecture Behavioral of rf is
    
    type register_array is ARRAY (31 DOWNTO 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    constant registers_32_rst : reg_32 := (
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
    signal registers_32 : reg_32 := registers_32_rst;
    
begin
    
    process(clk, rst) begin
        
        -- reset
        if (rst = '1') then
            registers_32 <= registers_32_rst;
            dout1 <= "00000000000000000000000000000000";
            dout2 <= "00000000000000000000000000000000";
                
        elsif (clk'event and clk = '1') then
             -- can only write data into write_addr of register file
            if (regRW = "10") then
                if (rd /= "00000") then -- R0 should always be 0 and cannot be written in other data
                    registers_32(CONV_INTEGER(rd)) <= din;
                else
                    registers_32(0) <= "00000000000000000000000000000000"; -- R0 is always zero
                end if;
                dout1 <= "00000000000000000000000000000000";
                dout2 <= "00000000000000000000000000000000";
                            
            -- can only read data from address read_addr of register file
            elsif (regRW = "01") then
                dout1 <= registers_32(CONV_INTEGER(r1));
                dout2 <= registers_32(CONV_INTEGER(r2));
            
            -- cannot read and cannot write
            else 
                dout1 <= "00000000000000000000000000000000";
                dout2 <= "00000000000000000000000000000000";
            end if;
            
        end if;
    end process;
    reg_out <= registers_32;
    
end Behavioral;
