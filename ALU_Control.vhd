----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/15 20:17:43
-- Design Name: 
-- Module Name: ALU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_Control is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          
          -- control signals
          ALUOP       : in STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
          funct7_bit2 : in STD_LOGIC                     := '0';
          funct3      : in STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
          
          -- output ALU Control Code
          ALU_Control : out STD_LOGIC_VECTOR (3 DOWNTO 0)
                    
    );
end ALU_Control;

architecture Behavioral of ALU_Control is
    
    signal ALU_Control_tmp : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    
begin
    
    process(clk, rst) begin
        if (rst = '1') then
            ALU_Control_tmp <= "0000"; -- reset ALU Control signal
        
        elsif (clk'event and clk = '1') then
            
            -- load/store instruction or LUI/AUIPC/JAL/JALR instruction
            if (ALUOP = "00") then
                ALU_Control_tmp <= "0000"; -- ALU use add function
            
            -- Branch instruction
            elsif (ALUOP = "01") then
                ALU_Control_tmp <= '1' & funct3; -- ALU use substract & compare function
                -- 1000 is BEQ
                -- 1001 is BNE
                -- 1100 is BLT
                -- 1101 is BGE 
                -- 1110 is BLTU 
                -- 1111 is BGEU
                
            -- I-type instruction or R-type instruction
            elsif (ALUOP = "10") then
                if (funct7_bit2 = '0') then
                    ALU_Control_tmp <= funct7_bit2 & funct3; -- ALU Control code will be decided by funct7 and funct3
                    -- 0000 is add 
                    -- 0001 is shift left logical 
                    -- 0010 is set less than (signed) 
                    -- 0011 is set less than (unsigned) 
                    -- 0100 is XOR
                    -- 0101 is shift right logical 
                    -- 0110 is OR 
                    -- 0111 is AND
                    
                elsif (funct7_bit2 = '1') then
                    if (funct3 = "000") then
                         ALU_Control_tmp <= "1010";
                    elsif (funct3 = "101") then
                         ALU_Control_tmp <= "1011";     
                    -- 1010 is substract 
                    -- 1011 is shift right arithmetic
                    
                    else ALU_Control_tmp <= "0000";
                    end if;
                
                end if;
            
            else ALU_Control_tmp <= "0000";
    
            end if;
                    
        end if;
    
    end process;    
    
    ALU_Control <= ALU_Control_tmp;

end Behavioral;
