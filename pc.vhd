library IEEE;
use IEEE.std_logic_1164.ALL;

entity pc is
    Port (clk: in std_logic;
          rst: in std_logic;
          addr_in: in std_logic_vector (31 downto 0);
          addr_out: out std_logic_vector (31 downto 0));
end pc;

architecture Behavioral of pc is
signal addr: std_logic_vector(31 downto 0);
begin
process(clk,rst) begin
    if rst = '1' then addr <= x"01000000";
    elsif clk = '1' then addr <= addr_in;
    end if;
end process;
addr_out <= addr;
end Behavioral;
