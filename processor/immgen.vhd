library IEEE;
use IEEE.std_logic_1164.ALL;

entity immgen is
  Port (instr: in std_logic_vector (31 downto 0);   --32-bit instruction
        immout: out std_logic_vector (31 downto 0) --32-bit signed immediate value
        );
end immgen;

architecture Behavioral of immgen is
constant pos: std_logic_vector (26 downto 0):= x"000000" & b"000";
constant neg: std_logic_vector (26 downto 0):= x"ffffff" & b"111";
signal imm: std_logic_vector (31 downto 0);

begin
process(instr) begin
    if instr(6 downto 0) = b"1100111" or instr(6 downto 0) = b"0000011" then   --I-type(JALR and load)
        if instr(31) = '0' then imm <= pos(19 downto 0) & instr(31 downto 20);
        else imm <= neg(19 downto 0) & instr(31 downto 20);
        end if;
    elsif instr(6 downto 0) = b"0010011" then  --I-type(ALU with immediate)
        if instr(14 downto 12) = b"001" or instr(14 downto 12) = b"101" then
            imm <= pos & instr(24 downto 20);
        elsif instr(31) = '0' or instr(14 downto 12) = b"011" then
            imm <= pos(19 downto 0) & instr(31 downto 20);
        else imm <= neg(19 downto 0) & instr(31 downto 20);
        end if;
    elsif instr(6 downto 0) = b"0100011" then   --S-type
        if instr(31) = '0' then imm <= pos(19 downto 0) & instr(31 downto 25) &
            instr(11 downto 7);
        else imm <= neg(19 downto 0) & instr(31 downto 25)&instr(11 downto 7);
        end if;
    elsif instr(6 downto 0) = b"1100011" then   --B-type
        if instr(31) = '0' then imm <= pos(18 downto 0) &
            instr(31)&instr(7)&instr(30 downto 25)&instr(11 downto 8) & '0';
        else imm <= neg(18 downto 0) &
            instr(31)&instr(7)&instr(30 downto 25)&instr(11 downto 8) & '0';
        end if;
    elsif instr(6 downto 0) = b"0110111" or instr(6 downto 0) = b"0010111" then --U-type
        imm <= instr(31 downto 12) & pos(11 downto 0);
    elsif instr(6 downto 0) = b"1101111" then   --J-type
        if instr(31) = '0' then imm <= pos(10 downto 0) &
            instr(31)&instr(19 downto 12)&instr(20)&instr(30 downto 21) & '0';
        else imm <= neg(10 downto 0) &
            instr(31)&instr(19 downto 12)&instr(20)&instr(30 downto 21) & '0';
        end if;
    else imm <= x"00000000";    --default
    end if;
end process;
immout <= imm;
end Behavioral;
