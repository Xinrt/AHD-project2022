library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alucontrol is
    Port (
          -- control signals
          ALUOp       : in STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
          func7bit2 : in STD_LOGIC                     := '0';
          func3      : in STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
          
          -- output ALU Control Code
          cout : out STD_LOGIC_VECTOR (3 DOWNTO 0)
                    
    );
end alucontrol;

architecture Behavioral of alucontrol is
    
    signal ALU_Control_tmp : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    
begin
process(ALUOp, func7bit2, func3) begin
    -- load/store instruction or LUI/AUIPC/JAL/JALR instruction
    if (ALUOp = "00") then
        ALU_Control_tmp <= "0000"; -- ALU use add function
    
    -- Branch instruction
    elsif (ALUOp = "01") then
        ALU_Control_tmp <= '1' & func3; -- ALU use substract & compare function
        -- 1000 is BEQ
        -- 1001 is BNE
        -- 1100 is BLT
        -- 1101 is BGE 
        -- 1110 is BLTU 
        -- 1111 is BGEU
        
    -- R-type instruction
    elsif (ALUOp = "10") then
        if (func7bit2 = '0') then
            ALU_Control_tmp <= func7bit2 & func3; -- ALU Control code will be decided by funct7 and funct3
            -- 0000 is add 
            -- 0001 is shift left logical 
            -- 0010 is set less than (signed) 
            -- 0011 is set less than (unsigned) 
            -- 0100 is XOR
            -- 0101 is shift right logical 
            -- 0110 is OR 
            -- 0111 is AND
            
        elsif (func7bit2 = '1') then
            if (func3 = "000") then
                 ALU_Control_tmp <= "1010";
            elsif (func3 = "101") then
                 ALU_Control_tmp <= "1011";     
            -- 1010 is substract 
            -- 1011 is shift right arithmetic
            
            else ALU_Control_tmp <= "0000";
            end if;
        
        end if;
    
    elsif (ALUOP = "11") then
        ALU_Control_tmp <= '0' & func3; -- ALU Control code will be decided by funct7 and funct3
        -- 0000 is add 
        -- 0010 is set less than (signed) 
        -- 0011 is set less than (unsigned) 
        -- 0100 is XOR
        -- 0110 is OR 
        -- 0111 is AND
             
    else ALU_Control_tmp <= "0000";

    end if;
end process;
cout <= ALU_Control_tmp;
end Behavioral;
