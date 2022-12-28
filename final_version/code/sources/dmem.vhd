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
use IEEE.NUMERIC_STD.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


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
    func3: in std_logic_vector(2 downto 0);         -- func3
    addr: in std_logic_vector(31 downto 0);         -- input address (byte)
    sw0: in std_logic_vector(15 downto 0);           -- input switches
    din: in std_logic_vector(31 downto 0);          -- input data
    dout: out std_logic_vector(31 downto 0);        -- output data
    ledOut: out std_logic_vector(15 downto 0);        -- output LED
    outofbound: out std_logic                       -- address out of bound signal
  );
end dmem;

architecture Behavioral of dmem is
-- Data Memory Size (4KB or 1024 Words)
-- RAM_LENGTH_WORDS = 1024
type ram is array(0 to 1023) of std_logic_vector(31 downto 0);
signal ram_words: ram :=  (x"00000000", others => (others =>'0'));  -- dmem array 
signal addr_word: integer;   -- 32-bit word addressed pc address input
--signal word: std_logic_vector(31 downto 0); -- word at given address
signal data_out: std_logic_vector(31 downto 0);                     -- read result
--signal ram_word: ram;       -- store the written input (element in the array)
signal bound: std_logic:= '0';  -- out of bound signal
signal lower_bound : std_logic_vector(31 downto 0) :=  x"7fffffff"; -- memory start address
signal upper_bound : std_logic_vector(31 downto 0) :=  x"80001000"; -- memory end address
-- three special read-only memory-mapped values at addresses 0x00100000, 0x00100004, 0x00100008
signal N1: std_logic_vector(31 downto 0) := x"00B6E933";  -- N number of Qing Xiang
signal N2: std_logic_vector(31 downto 0) := x"011EB84B";  -- N number of Xiao Ding
signal N3: std_logic_vector(31 downto 0) := x"009C8351";  -- N number of Xinran Tang
signal SW: std_logic_vector(31 downto 0) := x"00000000";  -- switches
signal LED: std_logic_vector(31 downto 0) := x"00000000"; -- LEDs

signal addr11to2 : std_logic_vector(9 downto 0);

begin
-- RAM_LENGTH_BITS = 4096 = 2^12 
-- Address Translation divide by 4
-- RAM_ADDR_BITS = 12
-- size of addr_word=10
-- e.g. input 0000 0004 -> translate to -> 0000 0001
-- addr_word(9 downto 0) <= addr(11 downto 2);
 
 
process(clk, rst) 
--variable temp: ram:=  (others => (others =>'0'));
variable word: std_logic_vector(31 downto 0); -- word at given address
 
begin
    if (rst = '1') then       -- resets
        report "reset ";
        ram_words <=  (x"00000000", others => (others =>'0'));  -- clear the array
        LED <= x"00000000";
        SW <= x"00000000"; 
        data_out <= x"00000000";                                -- output the read data 0
        bound <= '0';
    elsif (clk'event and clk = '1') then           
        -- size of word addressed addresses is 1024
        SW <= x"0000" & sw0; -- store switches
        if(dmemRW = "01") then
        -- read
            -- 0x00100000 - 0x80000000
            case addr is
            when x"00100000" =>
                data_out <= N1;
            when x"00100004" =>
                data_out <= N2;
            when x"00100008" =>
                data_out <= N3;
            when x"00100010" =>
                data_out <= SW;
            when x"00100014" =>
                data_out <= LED;
            when others =>
            -- addr > 0x80000000
            if(unsigned(lower_bound) < unsigned(addr) and unsigned(addr) < unsigned(upper_bound)) then  -- read 4KB memory
                --addr_word <= to_integer(unsigned(addr(11 downto 2)));
                word := ram_words(to_integer(unsigned(addr(11 downto 2))));
                
                if (addr(1 downto 0)/= "00") then
                    bound <= '1';
                else
                    case func3 is
                    when "000" => -- LB
                        if(word(7) = '1') then 
                            data_out <= x"ffffff" & word(7 downto 0);
                        else 
                            data_out <= x"000000" & word(7 downto 0);
                        end if;

                    when "001" => -- LH
                            if(word(15) = '1') then
                            data_out <= x"ffff" & word(15 downto 0);
                        else 
                            data_out <= x"0000" & word(15 downto 0);
                        end if;

                    when "010" => -- LW
                        data_out <= word;

                    when "100" => -- LBU
                        data_out <= x"000000" & word(7 downto 0);

                    when "101" => -- LHU
                        data_out <= x"0000" & word(15 downto 0);

                    when others => null;
                    end case;
                end if;
            else  
                data_out <= x"00000000";
                bound <= '1';
            end if;
            end case;
        elsif(dmemRW = "10") then
        -- write
            data_out <= x"00000000";
            if(addr = x"00100014") then  -- write LEDs
                LED <= din;
            elsif(unsigned(lower_bound) < unsigned(addr) and unsigned(addr) < unsigned(upper_bound)) then  -- write 4KB memory
                if (addr(1 downto 0)/= "00") then
                    bound <= '1';
                else
                    
                    word := ram_words(to_integer(unsigned(addr(11 downto 2))));
                    case func3 is
                    when "000" => -- SB
                        ram_words(to_integer(unsigned(addr(11 downto 2)))) <= word(31 downto 8) & din(7 downto 0);
                    when "001" => -- SH
                        ram_words(to_integer(unsigned(addr(11 downto 2)))) <= word(15 downto 0) & din(15 downto 0);
                    when "010" => -- SW
                        ram_words(to_integer(unsigned(addr(11 downto 2)))) <= din;
                    when others => null;
                    end case;
                
                end if;
                
                


            else
                bound <= '1';
            end if;
        else
            data_out <= x"00000000";
            bound <= '0';
        end if;
    end if;
end process;

dout <= data_out;
ledOut <= LED(15 downto 0);
outofbound <= bound;
end Behavioral;