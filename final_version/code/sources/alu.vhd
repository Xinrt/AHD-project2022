library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity alu is
    Port (
          -- control signals
          control : in STD_LOGIC_VECTOR (3 DOWNTO 0);
        
          -- number inputs that will be calculated
          operand1 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          operand2 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          
          -- input data from register files (only for branch instructions, they will be compared)
          din1 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          din2 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
          
          
          -- output signals, including calculated result, zero flag and positive flag
          dout  : out STD_LOGIC_VECTOR (31 DOWNTO 0); -- output data
          brout : out STD_LOGIC                   -- for branch instructions,branch or not
    );
end alu;

architecture Behavioral of alu is

    signal data_out_tmp  : STD_LOGIC_VECTOR (31 DOWNTO 0) := "00000000000000000000000000000000";
    signal branch_or_not_tmp : STD_LOGIC := '0';
    
begin
process(control, operand1, operand2, din1, din2) begin
    if (control = "0000") then     -- add
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) + SIGNED(operand2));
        branch_or_not_tmp <= '0';

        
    elsif (control = "0001") then  -- shift left logical 
        CASE operand2(4 DOWNTO 0) is
            WHEN "00000" => data_out_tmp <= operand1;
            WHEN "00001" => data_out_tmp <= operand1(30 DOWNTO 0) & '0';
            WHEN "00010" => data_out_tmp <= operand1(29 DOWNTO 0) & "00";
            WHEN "00011" => data_out_tmp <= operand1(28 DOWNTO 0) & "000";
            WHEN "00100" => data_out_tmp <= operand1(27 DOWNTO 0) & "0000";
            WHEN "00101" => data_out_tmp <= operand1(26 DOWNTO 0) & "00000";
            WHEN "00110" => data_out_tmp <= operand1(25 DOWNTO 0) & "000000";
            WHEN "00111" => data_out_tmp <= operand1(24 DOWNTO 0) & "0000000";
            WHEN "01000" => data_out_tmp <= operand1(23 DOWNTO 0) & "00000000";
            WHEN "01001" => data_out_tmp <= operand1(22 DOWNTO 0) & "000000000";
            WHEN "01010" => data_out_tmp <= operand1(21 DOWNTO 0) & "0000000000";
            WHEN "01011" => data_out_tmp <= operand1(20 DOWNTO 0) & "00000000000";
            WHEN "01100" => data_out_tmp <= operand1(19 DOWNTO 0) & "000000000000";
            WHEN "01101" => data_out_tmp <= operand1(18 DOWNTO 0) & "0000000000000";
            WHEN "01110" => data_out_tmp <= operand1(17 DOWNTO 0) & "00000000000000";
            WHEN "01111" => data_out_tmp <= operand1(16 DOWNTO 0) & "000000000000000";
            WHEN "10000" => data_out_tmp <= operand1(15 DOWNTO 0) & "0000000000000000";
            WHEN "10001" => data_out_tmp <= operand1(14 DOWNTO 0) & "00000000000000000";
            WHEN "10010" => data_out_tmp <= operand1(13 DOWNTO 0) & "000000000000000000";
            WHEN "10011" => data_out_tmp <= operand1(12 DOWNTO 0) & "0000000000000000000";
            WHEN "10100" => data_out_tmp <= operand1(11 DOWNTO 0) & "00000000000000000000";
            WHEN "10101" => data_out_tmp <= operand1(10 DOWNTO 0) & "000000000000000000000";
            WHEN "10110" => data_out_tmp <= operand1(9 DOWNTO 0) & "0000000000000000000000";
            WHEN "10111" => data_out_tmp <= operand1(8 DOWNTO 0) & "00000000000000000000000";
            WHEN "11000" => data_out_tmp <= operand1(7 DOWNTO 0) & "000000000000000000000000";
            WHEN "11001" => data_out_tmp <= operand1(6 DOWNTO 0) & "0000000000000000000000000";
            WHEN "11010" => data_out_tmp <= operand1(5 DOWNTO 0) & "00000000000000000000000000";
            WHEN "11011" => data_out_tmp <= operand1(4 DOWNTO 0) & "000000000000000000000000000";
            WHEN "11100" => data_out_tmp <= operand1(3 DOWNTO 0) & "0000000000000000000000000000";
            WHEN "11101" => data_out_tmp <= operand1(2 DOWNTO 0) & "00000000000000000000000000000";
            WHEN "11110" => data_out_tmp <= operand1(1 DOWNTO 0) & "000000000000000000000000000000";
            WHEN "11111" => data_out_tmp <= operand1(0) & "0000000000000000000000000000000";
            WHEN OTHERS => data_out_tmp <= operand1;
        END CASE;
        branch_or_not_tmp <= '0';

        
    elsif (control = "0010") then  -- set less than (signed)
        if (SIGNED(operand1) < SIGNED(operand2)) then
            data_out_tmp <= "00000000000000000000000000000001";
        else
            data_out_tmp <= "00000000000000000000000000000000";
        end if;
        branch_or_not_tmp <= '0';

        
    elsif (control = "0011") then  -- set less than (unsigned)
        if (UNSIGNED(operand1) < UNSIGNED(operand2)) then
            data_out_tmp <= "00000000000000000000000000000001";
        else
            data_out_tmp <= "00000000000000000000000000000000";
        end if;
        branch_or_not_tmp <= '0';


    elsif (control = "0100") then  -- XOR
        data_out_tmp <= operand1 XOR operand2;
        branch_or_not_tmp <= '0';


    elsif (control = "0101") then  -- shift right logical
        CASE operand2(4 DOWNTO 0) is
            WHEN "00000" => data_out_tmp <= operand1;
            WHEN "00001" => data_out_tmp <= '0' & operand1(31 DOWNTO 1);
            WHEN "00010" => data_out_tmp <= "00" & operand1(31 DOWNTO 2);
            WHEN "00011" => data_out_tmp <= "000" & operand1(31 DOWNTO 3);
            WHEN "00100" => data_out_tmp <= "0000" & operand1(31 DOWNTO 4);
            WHEN "00101" => data_out_tmp <= "00000" & operand1(31 DOWNTO 5);
            WHEN "00110" => data_out_tmp <= "000000" & operand1(31 DOWNTO 6);
            WHEN "00111" => data_out_tmp <= "0000000" & operand1(31 DOWNTO 7);
            WHEN "01000" => data_out_tmp <= "00000000" & operand1(31 DOWNTO 8);
            WHEN "01001" => data_out_tmp <= "000000000" & operand1(31 DOWNTO 9);
            WHEN "01010" => data_out_tmp <= "0000000000" & operand1(31 DOWNTO 10);
            WHEN "01011" => data_out_tmp <= "00000000000" & operand1(31 DOWNTO 11);
            WHEN "01100" => data_out_tmp <= "000000000000" & operand1(31 DOWNTO 12);
            WHEN "01101" => data_out_tmp <= "0000000000000" & operand1(31 DOWNTO 13);
            WHEN "01110" => data_out_tmp <= "00000000000000" & operand1(31 DOWNTO 14);
            WHEN "01111" => data_out_tmp <= "000000000000000" & operand1(31 DOWNTO 15);
            WHEN "10000" => data_out_tmp <= "0000000000000000" & operand1(31 DOWNTO 16);
            WHEN "10001" => data_out_tmp <= "00000000000000000" & operand1(31 DOWNTO 17);
            WHEN "10010" => data_out_tmp <= "000000000000000000" & operand1(31 DOWNTO 18);
            WHEN "10011" => data_out_tmp <= "0000000000000000000" & operand1(31 DOWNTO 19);
            WHEN "10100" => data_out_tmp <= "00000000000000000000" & operand1(31 DOWNTO 20);
            WHEN "10101" => data_out_tmp <= "000000000000000000000" & operand1(31 DOWNTO 21);
            WHEN "10110" => data_out_tmp <= "0000000000000000000000" & operand1(31 DOWNTO 22);
            WHEN "10111" => data_out_tmp <= "00000000000000000000000" & operand1(31 DOWNTO 23);
            WHEN "11000" => data_out_tmp <= "000000000000000000000000" & operand1(31 DOWNTO 24);
            WHEN "11001" => data_out_tmp <= "0000000000000000000000000" & operand1(31 DOWNTO 25);
            WHEN "11010" => data_out_tmp <= "00000000000000000000000000" & operand1(31 DOWNTO 26);
            WHEN "11011" => data_out_tmp <= "000000000000000000000000000" & operand1(31 DOWNTO 27);
            WHEN "11100" => data_out_tmp <= "0000000000000000000000000000" & operand1(31 DOWNTO 28);
            WHEN "11101" => data_out_tmp <= "00000000000000000000000000000" & operand1(31 DOWNTO 29);
            WHEN "11110" => data_out_tmp <= "000000000000000000000000000000" & operand1(31 DOWNTO 30);
            WHEN "11111" => data_out_tmp <= "0000000000000000000000000000000" & operand1(31);
            WHEN OTHERS => data_out_tmp <= operand1;
        END CASE;
        branch_or_not_tmp <= '0';

                   
    elsif (control = "0110") then  -- OR 
        data_out_tmp <= operand1 OR operand2;
        branch_or_not_tmp <= '0';


    elsif (control = "0111") then  -- AND 
        data_out_tmp <= operand1 AND operand2;
        branch_or_not_tmp <= '0';

    
    elsif (control = "1010") then  -- substract
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) - SIGNED(operand2));
        branch_or_not_tmp <= '0';


    elsif (control = "1011") then  -- shift right arithmetic
        if (operand1(31) = '0') then            
            CASE operand2(4 DOWNTO 0) is
                WHEN "00000" => data_out_tmp <= operand1;
                WHEN "00001" => data_out_tmp <= '0' & operand1(31 DOWNTO 1);
                WHEN "00010" => data_out_tmp <= "00" & operand1(31 DOWNTO 2);
                WHEN "00011" => data_out_tmp <= "000" & operand1(31 DOWNTO 3);
                WHEN "00100" => data_out_tmp <= "0000" & operand1(31 DOWNTO 4);
                WHEN "00101" => data_out_tmp <= "00000" & operand1(31 DOWNTO 5);
                WHEN "00110" => data_out_tmp <= "000000" & operand1(31 DOWNTO 6);
                WHEN "00111" => data_out_tmp <= "0000000" & operand1(31 DOWNTO 7);
                WHEN "01000" => data_out_tmp <= "00000000" & operand1(31 DOWNTO 8);
                WHEN "01001" => data_out_tmp <= "000000000" & operand1(31 DOWNTO 9);
                WHEN "01010" => data_out_tmp <= "0000000000" & operand1(31 DOWNTO 10);
                WHEN "01011" => data_out_tmp <= "00000000000" & operand1(31 DOWNTO 11);
                WHEN "01100" => data_out_tmp <= "000000000000" & operand1(31 DOWNTO 12);
                WHEN "01101" => data_out_tmp <= "0000000000000" & operand1(31 DOWNTO 13);
                WHEN "01110" => data_out_tmp <= "00000000000000" & operand1(31 DOWNTO 14);
                WHEN "01111" => data_out_tmp <= "000000000000000" & operand1(31 DOWNTO 15);
                WHEN "10000" => data_out_tmp <= "0000000000000000" & operand1(31 DOWNTO 16);
                WHEN "10001" => data_out_tmp <= "00000000000000000" & operand1(31 DOWNTO 17);
                WHEN "10010" => data_out_tmp <= "000000000000000000" & operand1(31 DOWNTO 18);
                WHEN "10011" => data_out_tmp <= "0000000000000000000" & operand1(31 DOWNTO 19);
                WHEN "10100" => data_out_tmp <= "00000000000000000000" & operand1(31 DOWNTO 20);
                WHEN "10101" => data_out_tmp <= "000000000000000000000" & operand1(31 DOWNTO 21);
                WHEN "10110" => data_out_tmp <= "0000000000000000000000" & operand1(31 DOWNTO 22);
                WHEN "10111" => data_out_tmp <= "00000000000000000000000" & operand1(31 DOWNTO 23);
                WHEN "11000" => data_out_tmp <= "000000000000000000000000" & operand1(31 DOWNTO 24);
                WHEN "11001" => data_out_tmp <= "0000000000000000000000000" & operand1(31 DOWNTO 25);
                WHEN "11010" => data_out_tmp <= "00000000000000000000000000" & operand1(31 DOWNTO 26);
                WHEN "11011" => data_out_tmp <= "000000000000000000000000000" & operand1(31 DOWNTO 27);
                WHEN "11100" => data_out_tmp <= "0000000000000000000000000000" & operand1(31 DOWNTO 28);
                WHEN "11101" => data_out_tmp <= "00000000000000000000000000000" & operand1(31 DOWNTO 29);
                WHEN "11110" => data_out_tmp <= "000000000000000000000000000000" & operand1(31 DOWNTO 30);
                WHEN "11111" => data_out_tmp <= "0000000000000000000000000000000" & operand1(31);
                WHEN OTHERS => data_out_tmp <= operand1;
            END CASE;
        else
            CASE operand2(4 DOWNTO 0) is
                WHEN "00000" => data_out_tmp <= operand1;
                WHEN "00001" => data_out_tmp <= '1' & operand1(31 DOWNTO 1);
                WHEN "00010" => data_out_tmp <= "11" & operand1(31 DOWNTO 2);
                WHEN "00011" => data_out_tmp <= "111" & operand1(31 DOWNTO 3);
                WHEN "00100" => data_out_tmp <= "1111" & operand1(31 DOWNTO 4);
                WHEN "00101" => data_out_tmp <= "11111" & operand1(31 DOWNTO 5);
                WHEN "00110" => data_out_tmp <= "111111" & operand1(31 DOWNTO 6);
                WHEN "00111" => data_out_tmp <= "1111111" & operand1(31 DOWNTO 7);
                WHEN "01000" => data_out_tmp <= "11111111" & operand1(31 DOWNTO 8);
                WHEN "01001" => data_out_tmp <= "111111111" & operand1(31 DOWNTO 9);
                WHEN "01010" => data_out_tmp <= "1111111111" & operand1(31 DOWNTO 10);
                WHEN "01011" => data_out_tmp <= "11111111111" & operand1(31 DOWNTO 11);
                WHEN "01100" => data_out_tmp <= "111111111111" & operand1(31 DOWNTO 12);
                WHEN "01101" => data_out_tmp <= "1111111111111" & operand1(31 DOWNTO 13);
                WHEN "01110" => data_out_tmp <= "11111111111111" & operand1(31 DOWNTO 14);
                WHEN "01111" => data_out_tmp <= "111111111111111" & operand1(31 DOWNTO 15);
                WHEN "10000" => data_out_tmp <= "1111111111111111" & operand1(31 DOWNTO 16);
                WHEN "10001" => data_out_tmp <= "11111111111111111" & operand1(31 DOWNTO 17);
                WHEN "10010" => data_out_tmp <= "111111111111111111" & operand1(31 DOWNTO 18);
                WHEN "10011" => data_out_tmp <= "1111111111111111111" & operand1(31 DOWNTO 19);
                WHEN "10100" => data_out_tmp <= "11111111111111111111" & operand1(31 DOWNTO 20);
                WHEN "10101" => data_out_tmp <= "111111111111111111111" & operand1(31 DOWNTO 21);
                WHEN "10110" => data_out_tmp <= "1111111111111111111111" & operand1(31 DOWNTO 22);
                WHEN "10111" => data_out_tmp <= "11111111111111111111111" & operand1(31 DOWNTO 23);
                WHEN "11000" => data_out_tmp <= "111111111111111111111111" & operand1(31 DOWNTO 24);
                WHEN "11001" => data_out_tmp <= "1111111111111111111111111" & operand1(31 DOWNTO 25);
                WHEN "11010" => data_out_tmp <= "11111111111111111111111111" & operand1(31 DOWNTO 26);
                WHEN "11011" => data_out_tmp <= "111111111111111111111111111" & operand1(31 DOWNTO 27);
                WHEN "11100" => data_out_tmp <= "1111111111111111111111111111" & operand1(31 DOWNTO 28);
                WHEN "11101" => data_out_tmp <= "11111111111111111111111111111" & operand1(31 DOWNTO 29);
                WHEN "11110" => data_out_tmp <= "111111111111111111111111111111" & operand1(31 DOWNTO 30);
                WHEN "11111" => data_out_tmp <= "1111111111111111111111111111111" & operand1(31);
                WHEN OTHERS => data_out_tmp <= operand1;
            END CASE;                
        end if; 
        branch_or_not_tmp <= '0';
    
    -- following are branch instructions
    elsif (control = "1000") then  -- BEQ: branch if data 1 equal to data 2
        if (din1 = din2) then
            branch_or_not_tmp <= '1';
        else
            branch_or_not_tmp <= '0';
        end if;
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) + SIGNED(operand2));

    elsif (control = "1001") then  -- BNE: branch if data 1 not equal to data 2
        if (din1 /= din2) then
            branch_or_not_tmp <= '1';
        else
            branch_or_not_tmp <= '0';
        end if;
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) + SIGNED(operand2));
        
    elsif (control = "1100") then  -- BLT: branch if data 1 less than data 2
        if (SIGNED(din1) < SIGNED(din2)) then
            branch_or_not_tmp <= '1';
        else
            branch_or_not_tmp <= '0';
        end if;
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) + SIGNED(operand2));
        

    elsif (control = "1101") then  -- BGE: branch if data 1 greater than or equal to data 2
        if (SIGNED(din1) >= SIGNED(din2)) then
            branch_or_not_tmp <= '1';
        else
            branch_or_not_tmp <= '0';
        end if;
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) + SIGNED(operand2));
        

    elsif (control = "1110") then  -- BLTU: branch if unsigned data 1 less than unsigned data 2
        if (UNSIGNED(din1) < UNSIGNED(din2)) then
            branch_or_not_tmp <= '1';
        else
            branch_or_not_tmp <= '0';
        end if;
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) + SIGNED(operand2));
        

    elsif (control = "1111") then  -- BGEU: branch if unsigned data 1 greater than or equal to data 2
        if (UNSIGNED(din1) >= UNSIGNED(din2)) then
            branch_or_not_tmp <= '1';
        else
            branch_or_not_tmp <= '0';
        end if;
        data_out_tmp <= STD_LOGIC_VECTOR(SIGNED(operand1) + SIGNED(operand2));
        
--    else
--        data_out_tmp <= "00000000000000000000000000000000";
--        branch_or_not_tmp <= '0';       
    end if;
end process;
dout  <= data_out_tmp;
brout <= branch_or_not_tmp;
end Behavioral;