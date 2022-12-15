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
    addr: in std_logic_vector(31 downto 0);         -- input address (byte)
    din: in std_logic_vector(31 downto 0);          -- input data
    dout: out std_logic_vector(31 downto 0);        -- output data
    outofbound: out std_logic                       -- address out of bound signal
  );
end dmem;

architecture Behavioral of dmem is
-- Data Memory Size (4KB or 1024 Words)
-- RAM_LENGTH_WORDS = 1024
type ram is array(0 to 1024-1) of std_logic_vector(31 downto 0);
signal ram_words: ram :=  (x"00000000", others => (others =>'0'));  -- dmem array 
signal addr_word: std_logic_vector(31 downto 0) := x"00000000";   -- 32-bit word addressed pc address input
signal addr0: std_logic_vector(31 downto 0) := x"80000000";         -- start address
signal data_out: std_logic_vector(31 downto 0);                     -- read result
--signal ram_word: ram;       -- store the written input (element in the array)
signal bound: std_logic;

-- three special read-only memory-mapped values at addresses 0x00100000, 0x00100004, 0x00100008
signal N1: std_logic_vector(31 downto 0) := x"11987251";  -- N number of Qing Xiang
signal N2: std_logic_vector(31 downto 0) := x"18790475";  -- N number of Xiao Ding
signal N3: std_logic_vector(31 downto 0) := x"10257233";  -- N number of Xinran Tang

begin
-- RAM_LENGTH_BITS = 4096 = 2^12 
-- Address Translation divide by 4
-- RAM_ADDR_BITS = 12
-- size of addr_word=10
-- e.g. input 0000 0004 -> translate to -> 0000 0001
addr_word(12-3 downto 0) <= addr(12-1 downto 2);

 
process(clk, rst) 
variable temp: ram:=  (others => (others =>'0')); 
begin
    if (rst = '1') then       -- resets
        report "reset ";
        ram_words <=  (x"00000000", others => (others =>'0'));  -- clear the array
        data_out <= x"00000000";                                -- output the read data 0
        bound <= '0';
    elsif (clk'event and clk = '1') then           
        -- size of word addressed addresses is 1024
        if(dmemRW = "10") then
        -- read
            -- 0x00100000 - 0x80000000
            if(addr(20)='1' and addr(31)='0') then
                if(addr=x"00100000") then
                    data_out <= N1;    
                elsif(addr=x"00100004") then
                    data_out <= N2;     
                elsif(addr=x"00100008") then
                    data_out <= N3;  
                else  
                    data_out <= x"00000000";
                end if;
            end if;
            
            -- addr > 0x80000000
            if(addr(31)='1') then
                report "The value of 'ram word' is " & integer'image(to_integer(unsigned(ram_words(to_integer(unsigned(addr_word(9 downto 0)))))));
                data_out <= ram_words(to_integer(unsigned(addr_word(9 downto 0))));
            end if;
        elsif(dmemRW = "01") then
        -- write
            addr_word(31) <= '1';       -- start from 0x80000000
            if(w_en(0)='1') then
                temp(to_integer(unsigned(addr_word(9 downto 0))))(7 downto 0) := din(7 downto 0); end if;
            if(w_en(1)='1') then
                temp(to_integer(unsigned(addr_word(9 downto 0))))(15 downto 8) := din(15 downto 8); end if;
            if(w_en(2)='1') then
                temp(to_integer(unsigned(addr_word(9 downto 0))))(23 downto 16) := din(23 downto 16); end if;
            if(w_en(3)='1') then
                temp(to_integer(unsigned(addr_word(9 downto 0))))(31 downto 24) := din(31 downto 24); end if;
                
            ram_words(to_integer(unsigned(addr_word(9 downto 0)))) <= temp(to_integer(unsigned(addr_word(9 downto 0))));
            temp := (others => (others =>'0')); 
        else
            data_out <= x"00000000";
            bound <= '1';
        end if;    
    end if;
end process;

dout <= data_out;
outofbound <= bound;
end Behavioral;
