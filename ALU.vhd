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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          
          -- control signals
          ALU_Control : in STD_LOGIC_VECTOR (3 DOWNTO 0);
        
          -- number inputs that will be calculated
          oprand_1 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          oprand_2 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          
          -- input data from register files (only for branch instructions, they will be compared)
          rs_data_in_1 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          rs_data_in_2 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          
          
          -- output signals, including calculated result, zero flag and positive flag
          data_out  : out STD_LOGIC_VECTOR (31 DOWNTO 0); -- output data
          branch_or_not : out STD_LOGIC                   -- for branch instructions,branch or not
    );
end ALU;

architecture Behavioral of ALU is

    signal data_out_tmp  : STD_LOGIC_VECTOR (31 DOWNTO 0) := "00000000000000000000000000000000";
    signal branch_or_not_tmp : STD_LOGIC := '0';
    
begin
    
    process(clk, rst) begin
        
        -- reset 
        if (rst = '1') then
        data_out_tmp <=  "00000000000000000000000000000000";
                branch_or_not_tmp <= '0';

        
        -- when the ALU run
        elsif (clk'event and clk = '1') then
            
            if (ALU_Control = "0000") then     -- add
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) + SIGNED(oprand_2));
                branch_or_not_tmp <= '0';

                
            elsif (ALU_Control = "0001") then  -- shift left logical 
                CASE oprand_2(4 DOWNTO 0) is
                    WHEN "00000" => data_out_tmp <= oprand_1;
                    WHEN "00001" => data_out_tmp <= oprand_1(30 DOWNTO 0) & '0';
                    WHEN "00010" => data_out_tmp <= oprand_1(29 DOWNTO 0) & "00";
                    WHEN "00011" => data_out_tmp <= oprand_1(28 DOWNTO 0) & "000";
                    WHEN "00100" => data_out_tmp <= oprand_1(27 DOWNTO 0) & "0000";
                    WHEN "00101" => data_out_tmp <= oprand_1(26 DOWNTO 0) & "00000";
                    WHEN "00110" => data_out_tmp <= oprand_1(25 DOWNTO 0) & "000000";
                    WHEN "00111" => data_out_tmp <= oprand_1(24 DOWNTO 0) & "0000000";
                    WHEN "01000" => data_out_tmp <= oprand_1(23 DOWNTO 0) & "00000000";
                    WHEN "01001" => data_out_tmp <= oprand_1(22 DOWNTO 0) & "000000000";
                    WHEN "01010" => data_out_tmp <= oprand_1(21 DOWNTO 0) & "0000000000";
                    WHEN "01011" => data_out_tmp <= oprand_1(20 DOWNTO 0) & "00000000000";
                    WHEN "01100" => data_out_tmp <= oprand_1(19 DOWNTO 0) & "000000000000";
                    WHEN "01101" => data_out_tmp <= oprand_1(18 DOWNTO 0) & "0000000000000";
                    WHEN "01110" => data_out_tmp <= oprand_1(17 DOWNTO 0) & "00000000000000";
                    WHEN "01111" => data_out_tmp <= oprand_1(16 DOWNTO 0) & "000000000000000";
                    WHEN "10000" => data_out_tmp <= oprand_1(15 DOWNTO 0) & "0000000000000000";
                    WHEN "10001" => data_out_tmp <= oprand_1(14 DOWNTO 0) & "00000000000000000";
                    WHEN "10010" => data_out_tmp <= oprand_1(13 DOWNTO 0) & "000000000000000000";
                    WHEN "10011" => data_out_tmp <= oprand_1(12 DOWNTO 0) & "0000000000000000000";
                    WHEN "10100" => data_out_tmp <= oprand_1(11 DOWNTO 0) & "00000000000000000000";
                    WHEN "10101" => data_out_tmp <= oprand_1(10 DOWNTO 0) & "000000000000000000000";
                    WHEN "10110" => data_out_tmp <= oprand_1(9 DOWNTO 0) & "0000000000000000000000";
                    WHEN "10111" => data_out_tmp <= oprand_1(8 DOWNTO 0) & "00000000000000000000000";
                    WHEN "11000" => data_out_tmp <= oprand_1(7 DOWNTO 0) & "000000000000000000000000";
                    WHEN "11001" => data_out_tmp <= oprand_1(6 DOWNTO 0) & "0000000000000000000000000";
                    WHEN "11010" => data_out_tmp <= oprand_1(5 DOWNTO 0) & "00000000000000000000000000";
                    WHEN "11011" => data_out_tmp <= oprand_1(4 DOWNTO 0) & "000000000000000000000000000";
                    WHEN "11100" => data_out_tmp <= oprand_1(3 DOWNTO 0) & "0000000000000000000000000000";
                    WHEN "11101" => data_out_tmp <= oprand_1(2 DOWNTO 0) & "00000000000000000000000000000";
                    WHEN "11110" => data_out_tmp <= oprand_1(1 DOWNTO 0) & "000000000000000000000000000000";
                    WHEN "11111" => data_out_tmp <= oprand_1(0) & "0000000000000000000000000000000";
                END CASE;
                branch_or_not_tmp <= '0';

                
            elsif (ALU_Control = "0010") then  -- set less than (signed)
                if (SIGNED(oprand_1) < SIGNED(oprand_2)) then
                    data_out_tmp <= "00000000000000000000000000000001";
                else
                    data_out_tmp <= "00000000000000000000000000000000";
                end if;
                branch_or_not_tmp <= '0';

                
            elsif (ALU_Control = "0011") then  -- set less than (unsigned)
                if (UNSIGNED(oprand_1) < UNSIGNED(oprand_2)) then
                    data_out_tmp <= "00000000000000000000000000000001";
                else
                    data_out_tmp <= "00000000000000000000000000000000";
                end if;
                branch_or_not_tmp <= '0';


            elsif (ALU_Control = "0100") then  -- XOR
                data_out_tmp <= oprand_1 XOR oprand_2;
                branch_or_not_tmp <= '0';


            elsif (ALU_Control = "0101") then  -- shift right logical
                CASE oprand_2(4 DOWNTO 0) is
                    WHEN "00000" => data_out_tmp <= oprand_1;
                    WHEN "00001" => data_out_tmp <= '0' & oprand_1(31 DOWNTO 1);
                    WHEN "00010" => data_out_tmp <= "00" & oprand_1(31 DOWNTO 2);
                    WHEN "00011" => data_out_tmp <= "000" & oprand_1(31 DOWNTO 3);
                    WHEN "00100" => data_out_tmp <= "0000" & oprand_1(31 DOWNTO 4);
                    WHEN "00101" => data_out_tmp <= "00000" & oprand_1(31 DOWNTO 5);
                    WHEN "00110" => data_out_tmp <= "000000" & oprand_1(31 DOWNTO 6);
                    WHEN "00111" => data_out_tmp <= "0000000" & oprand_1(31 DOWNTO 7);
                    WHEN "01000" => data_out_tmp <= "00000000" & oprand_1(31 DOWNTO 8);
                    WHEN "01001" => data_out_tmp <= "000000000" & oprand_1(31 DOWNTO 9);
                    WHEN "01010" => data_out_tmp <= "0000000000" & oprand_1(31 DOWNTO 10);
                    WHEN "01011" => data_out_tmp <= "00000000000" & oprand_1(31 DOWNTO 11);
                    WHEN "01100" => data_out_tmp <= "000000000000" & oprand_1(31 DOWNTO 12);
                    WHEN "01101" => data_out_tmp <= "0000000000000" & oprand_1(31 DOWNTO 13);
                    WHEN "01110" => data_out_tmp <= "00000000000000" & oprand_1(31 DOWNTO 14);
                    WHEN "01111" => data_out_tmp <= "000000000000000" & oprand_1(31 DOWNTO 15);
                    WHEN "10000" => data_out_tmp <= "0000000000000000" & oprand_1(31 DOWNTO 16);
                    WHEN "10001" => data_out_tmp <= "00000000000000000" & oprand_1(31 DOWNTO 17);
                    WHEN "10010" => data_out_tmp <= "000000000000000000" & oprand_1(31 DOWNTO 18);
                    WHEN "10011" => data_out_tmp <= "0000000000000000000" & oprand_1(31 DOWNTO 19);
                    WHEN "10100" => data_out_tmp <= "00000000000000000000" & oprand_1(31 DOWNTO 20);
                    WHEN "10101" => data_out_tmp <= "000000000000000000000" & oprand_1(31 DOWNTO 21);
                    WHEN "10110" => data_out_tmp <= "0000000000000000000000" & oprand_1(31 DOWNTO 22);
                    WHEN "10111" => data_out_tmp <= "00000000000000000000000" & oprand_1(31 DOWNTO 23);
                    WHEN "11000" => data_out_tmp <= "000000000000000000000000" & oprand_1(31 DOWNTO 24);
                    WHEN "11001" => data_out_tmp <= "0000000000000000000000000" & oprand_1(31 DOWNTO 25);
                    WHEN "11010" => data_out_tmp <= "00000000000000000000000000" & oprand_1(31 DOWNTO 26);
                    WHEN "11011" => data_out_tmp <= "000000000000000000000000000" & oprand_1(31 DOWNTO 27);
                    WHEN "11100" => data_out_tmp <= "0000000000000000000000000000" & oprand_1(31 DOWNTO 28);
                    WHEN "11101" => data_out_tmp <= "00000000000000000000000000000" & oprand_1(31 DOWNTO 29);
                    WHEN "11110" => data_out_tmp <= "000000000000000000000000000000" & oprand_1(31 DOWNTO 30);
                    WHEN "11111" => data_out_tmp <= "0000000000000000000000000000000" & oprand_1(31);
                END CASE;
                branch_or_not_tmp <= '0';

                           
            elsif (ALU_Control = "0110") then  -- OR 
                data_out_tmp <= oprand_1 OR oprand_2;
                branch_or_not_tmp <= '0';


            elsif (ALU_Control = "0111") then  -- AND 
                data_out_tmp <= oprand_1 AND oprand_2;
                branch_or_not_tmp <= '0';

            
            elsif (ALU_Control = "1010") then  -- substract
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) - SIGNED(oprand_2));
                branch_or_not_tmp <= '0';


            elsif (ALU_Control = "1011") then  -- shift right arithmetic
                if (oprand_1(31) = '0') then            
                    CASE oprand_2(4 DOWNTO 0) is
                        WHEN "00000" => data_out_tmp <= oprand_1;
                        WHEN "00001" => data_out_tmp <= '0' & oprand_1(31 DOWNTO 1);
                        WHEN "00010" => data_out_tmp <= "00" & oprand_1(31 DOWNTO 2);
                        WHEN "00011" => data_out_tmp <= "000" & oprand_1(31 DOWNTO 3);
                        WHEN "00100" => data_out_tmp <= "0000" & oprand_1(31 DOWNTO 4);
                        WHEN "00101" => data_out_tmp <= "00000" & oprand_1(31 DOWNTO 5);
                        WHEN "00110" => data_out_tmp <= "000000" & oprand_1(31 DOWNTO 6);
                        WHEN "00111" => data_out_tmp <= "0000000" & oprand_1(31 DOWNTO 7);
                        WHEN "01000" => data_out_tmp <= "00000000" & oprand_1(31 DOWNTO 8);
                        WHEN "01001" => data_out_tmp <= "000000000" & oprand_1(31 DOWNTO 9);
                        WHEN "01010" => data_out_tmp <= "0000000000" & oprand_1(31 DOWNTO 10);
                        WHEN "01011" => data_out_tmp <= "00000000000" & oprand_1(31 DOWNTO 11);
                        WHEN "01100" => data_out_tmp <= "000000000000" & oprand_1(31 DOWNTO 12);
                        WHEN "01101" => data_out_tmp <= "0000000000000" & oprand_1(31 DOWNTO 13);
                        WHEN "01110" => data_out_tmp <= "00000000000000" & oprand_1(31 DOWNTO 14);
                        WHEN "01111" => data_out_tmp <= "000000000000000" & oprand_1(31 DOWNTO 15);
                        WHEN "10000" => data_out_tmp <= "0000000000000000" & oprand_1(31 DOWNTO 16);
                        WHEN "10001" => data_out_tmp <= "00000000000000000" & oprand_1(31 DOWNTO 17);
                        WHEN "10010" => data_out_tmp <= "000000000000000000" & oprand_1(31 DOWNTO 18);
                        WHEN "10011" => data_out_tmp <= "0000000000000000000" & oprand_1(31 DOWNTO 19);
                        WHEN "10100" => data_out_tmp <= "00000000000000000000" & oprand_1(31 DOWNTO 20);
                        WHEN "10101" => data_out_tmp <= "000000000000000000000" & oprand_1(31 DOWNTO 21);
                        WHEN "10110" => data_out_tmp <= "0000000000000000000000" & oprand_1(31 DOWNTO 22);
                        WHEN "10111" => data_out_tmp <= "00000000000000000000000" & oprand_1(31 DOWNTO 23);
                        WHEN "11000" => data_out_tmp <= "000000000000000000000000" & oprand_1(31 DOWNTO 24);
                        WHEN "11001" => data_out_tmp <= "0000000000000000000000000" & oprand_1(31 DOWNTO 25);
                        WHEN "11010" => data_out_tmp <= "00000000000000000000000000" & oprand_1(31 DOWNTO 26);
                        WHEN "11011" => data_out_tmp <= "000000000000000000000000000" & oprand_1(31 DOWNTO 27);
                        WHEN "11100" => data_out_tmp <= "0000000000000000000000000000" & oprand_1(31 DOWNTO 28);
                        WHEN "11101" => data_out_tmp <= "00000000000000000000000000000" & oprand_1(31 DOWNTO 29);
                        WHEN "11110" => data_out_tmp <= "000000000000000000000000000000" & oprand_1(31 DOWNTO 30);
                        WHEN "11111" => data_out_tmp <= "0000000000000000000000000000000" & oprand_1(31);
                    END CASE;
                else
                    CASE oprand_2(4 DOWNTO 0) is
                        WHEN "00000" => data_out_tmp <= oprand_1;
                        WHEN "00001" => data_out_tmp <= '1' & oprand_1(31 DOWNTO 1);
                        WHEN "00010" => data_out_tmp <= "11" & oprand_1(31 DOWNTO 2);
                        WHEN "00011" => data_out_tmp <= "111" & oprand_1(31 DOWNTO 3);
                        WHEN "00100" => data_out_tmp <= "1111" & oprand_1(31 DOWNTO 4);
                        WHEN "00101" => data_out_tmp <= "11111" & oprand_1(31 DOWNTO 5);
                        WHEN "00110" => data_out_tmp <= "111111" & oprand_1(31 DOWNTO 6);
                        WHEN "00111" => data_out_tmp <= "1111111" & oprand_1(31 DOWNTO 7);
                        WHEN "01000" => data_out_tmp <= "11111111" & oprand_1(31 DOWNTO 8);
                        WHEN "01001" => data_out_tmp <= "111111111" & oprand_1(31 DOWNTO 9);
                        WHEN "01010" => data_out_tmp <= "1111111111" & oprand_1(31 DOWNTO 10);
                        WHEN "01011" => data_out_tmp <= "11111111111" & oprand_1(31 DOWNTO 11);
                        WHEN "01100" => data_out_tmp <= "111111111111" & oprand_1(31 DOWNTO 12);
                        WHEN "01101" => data_out_tmp <= "1111111111111" & oprand_1(31 DOWNTO 13);
                        WHEN "01110" => data_out_tmp <= "11111111111111" & oprand_1(31 DOWNTO 14);
                        WHEN "01111" => data_out_tmp <= "111111111111111" & oprand_1(31 DOWNTO 15);
                        WHEN "10000" => data_out_tmp <= "1111111111111111" & oprand_1(31 DOWNTO 16);
                        WHEN "10001" => data_out_tmp <= "11111111111111111" & oprand_1(31 DOWNTO 17);
                        WHEN "10010" => data_out_tmp <= "111111111111111111" & oprand_1(31 DOWNTO 18);
                        WHEN "10011" => data_out_tmp <= "1111111111111111111" & oprand_1(31 DOWNTO 19);
                        WHEN "10100" => data_out_tmp <= "11111111111111111111" & oprand_1(31 DOWNTO 20);
                        WHEN "10101" => data_out_tmp <= "111111111111111111111" & oprand_1(31 DOWNTO 21);
                        WHEN "10110" => data_out_tmp <= "1111111111111111111111" & oprand_1(31 DOWNTO 22);
                        WHEN "10111" => data_out_tmp <= "11111111111111111111111" & oprand_1(31 DOWNTO 23);
                        WHEN "11000" => data_out_tmp <= "111111111111111111111111" & oprand_1(31 DOWNTO 24);
                        WHEN "11001" => data_out_tmp <= "1111111111111111111111111" & oprand_1(31 DOWNTO 25);
                        WHEN "11010" => data_out_tmp <= "11111111111111111111111111" & oprand_1(31 DOWNTO 26);
                        WHEN "11011" => data_out_tmp <= "111111111111111111111111111" & oprand_1(31 DOWNTO 27);
                        WHEN "11100" => data_out_tmp <= "1111111111111111111111111111" & oprand_1(31 DOWNTO 28);
                        WHEN "11101" => data_out_tmp <= "11111111111111111111111111111" & oprand_1(31 DOWNTO 29);
                        WHEN "11110" => data_out_tmp <= "111111111111111111111111111111" & oprand_1(31 DOWNTO 30);
                        WHEN "11111" => data_out_tmp <= "1111111111111111111111111111111" & oprand_1(31);
                    END CASE;                
                end if; 
                branch_or_not_tmp <= '0';
            
            -- following are branch instructions
            elsif (ALU_Control = "1000") then  -- BEQ: branch if data 1 equal to data 2
                if (rs_data_in_1 = rs_data_in_2) then
                    branch_or_not_tmp <= '1';
                else
                    branch_or_not_tmp <= '0';
                end if;
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) + SIGNED(oprand_2));

            elsif (ALU_Control = "1001") then  -- BNE: branch if data 1 not equal to data 2
                if (rs_data_in_1 /= rs_data_in_2) then
                    branch_or_not_tmp <= '1';
                else
                    branch_or_not_tmp <= '0';
                end if;
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) + SIGNED(oprand_2));
                
            elsif (ALU_Control = "1100") then  -- BLT: branch if data 1 less than data 2
                if (SIGNED(rs_data_in_1) < SIGNED(rs_data_in_2)) then
                    branch_or_not_tmp <= '1';
                else
                    branch_or_not_tmp <= '0';
                end if;
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) + SIGNED(oprand_2));
                

            elsif (ALU_Control = "1101") then  -- BGE: branch if data 1 greater than or equal to data 2
                if (SIGNED(rs_data_in_1) >= SIGNED(rs_data_in_2)) then
                    branch_or_not_tmp <= '1';
                else
                    branch_or_not_tmp <= '0';
                end if;
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) + SIGNED(oprand_2));
                

            elsif (ALU_Control = "1110") then  -- BLTU: branch if unsigned data 1 less than unsigned data 2
                if (UNSIGNED(rs_data_in_1) < UNSIGNED(rs_data_in_2)) then
                    branch_or_not_tmp <= '1';
                else
                    branch_or_not_tmp <= '0';
                end if;
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) + SIGNED(oprand_2));
                

            elsif (ALU_Control = "1111") then  -- BGEU: branch if unsigned data 1 greater than or equal to data 2
                if (UNSIGNED(rs_data_in_1) >= UNSIGNED(rs_data_in_2)) then
                    branch_or_not_tmp <= '1';
                else
                    branch_or_not_tmp <= '0';
                end if;
                data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(oprand_1) + SIGNED(oprand_2));
                
            else 
                data_out_tmp <= "00000000000000000000000000000000";
                branch_or_not_tmp <= '0';
                
            end if;
            
                    
        end if;
    
    end process;    
    
    data_out  <= data_out_tmp;
    branch_or_not <= branch_or_not_tmp;

end Behavioral;
