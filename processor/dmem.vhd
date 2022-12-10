----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/16 17:05:19
-- Design Name: 
-- Module Name: dmem - Behavioral
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
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Instruction Memory Size (4KB or 1024 Words)

entity dmem is
  Port ( 
    clk: in std_logic;    -- clock signal
    rst: in std_logic;    -- asynchronous reset signal
    dmemRW: in std_logic_vector(1 downto 0);        -- dmemRead/Write 00 01 10
    w_en: in std_logic_vector(3 downto 0);          -- write enable
    addr: in std_logic_vector(31 downto 0);         -- input address
    din: in std_logic_vector(31 downto 0);          -- input data
    dout: out std_logic_vector(31 downto 0);        -- output data
    outofbound: out std_logic                       -- address out of bound signal
  );
end dmem;

architecture Behavioral of dmem is
-- Data Memory Size (4KB or 1024 Words)
-- RAM_LENGTH_WORDS = 1024
type ram is array(0 to 1024-1) of std_logic_vector(31 downto 0);
signal ram_words: ram :=  (x"00000000", others => (others =>'0'));
signal addr_word: std_logic_vector(31 downto 0) := x"00000000";   -- 32-bit word addressed pc address input
signal addr0: std_logic_vector(31 downto 0) := x"80000000";
signal data_out: std_logic_vector(31 downto 0);
signal ram_word: ram;       -- store the written input
signal bound: std_logic;

begin
-- RAM_LENGTH_BITS = 4096 = 2^12 
-- Address Translation divide by 4
-- RAM_ADDR_BITS = 12
addr_word(12-3 downto 0) <= addr(12-1 downto 2);
 
process(clk, rst) 
variable temp: ram:=  (others => (others =>'0')); 
begin
    if (rst = '1') then       -- resets
        report "reset ";
        data_out <= x"00000001";
        bound <= '0';
    elsif (clk'event and clk = '1') then           
        -- size of word addressed addresses is 1024
        if (addr_word < 1024) then
        -- 0x00100000 = 100000000000000000000 (21 bits)
        -- if the 21st bit of the address input is 1
        -- implement special read-only memory-mapped values at addresses 0x00100000, 0x00100004, 0x00100008
        -- read
            if (addr(20)='1' and dmemRW = "01") then
                
                if(to_integer(unsigned(addr_word)) = 0) then
                    data_out <= x"11987251";       -- N number of Qing Xiang
                elsif(to_integer(unsigned(addr_word)) = 1) then
                    data_out <= x"18790475";       -- N number of Xiao Ding
                elsif(to_integer(unsigned(addr_word)) = 2) then
                    data_out <= x"10257233";       -- N number of Xinran Tang
                end if;
           
        
            else 
            -- write
            -- using 4 interleaved sets of 8-bit (1 byte) wide memories
                if(dmemRW = "10") then
                    if(w_en(0)='1') then
                        temp(to_integer(unsigned(addr_word)))(7 downto 0) := din(7 downto 0); end if;
                    if(w_en(1)='1') then
                        temp(to_integer(unsigned(addr_word)))(15 downto 8) := din(15 downto 8); end if;
                    if(w_en(2)='1') then
                        temp(to_integer(unsigned(addr_word)))(23 downto 16) := din(23 downto 16); end if;
                    if(w_en(3)='1') then
                        temp(to_integer(unsigned(addr_word)))(31 downto 24) := din(31 downto 24); end if;
            
    --                data_out <= temp(to_integer(unsigned(addr_word)));
                    ram_word(to_integer(unsigned(addr_word))) <= temp(to_integer(unsigned(addr_word)));
                    report "The value of 'ram word' is " & integer'image(to_integer(unsigned(ram_word(to_integer(unsigned(addr_word))))));
                    data_out <= x"00000000";
    --                data_out <= ram_word(to_integer(unsigned(addr_word)));
                    report "The value of 'data out' is " & integer'image(to_integer(unsigned(data_out)));
                    temp := (others => (others =>'0')); 
                else
                    data_out <= x"00000000";
                end if;
            end if;
        else
            data_out <= x"00000000";
            bound <= '1';
        end if;    
    end if;
end process;

dout <= data_out;
outofbound <= bound;
end Behavioral;
