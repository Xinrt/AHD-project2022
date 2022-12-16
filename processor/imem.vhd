library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity imem is
  Port ( 
    clk: in std_logic;    -- clock signal
    rst: in std_logic;    -- asynchronous reset signal
    imemR: in std_logic;     -- imemRead enable signal
    addr: in std_logic_vector(31 downto 0);       -- 32-bit byte addressed pc address input
    instr: out std_logic_vector(31 downto 0)      -- 32-bit instruction value output
  );
end imem;

architecture Behavioral of imem is
-- byte addressed: 4 address <-> 1 instruction
-- word addressed: 1 address <-> 1 instruction
-- size of imem = 2KByte = 2048 addresses (in byte addressed) -> 2048/4 = 512 instructions
-- now translate the byte addressed to word addressed: 512 instructions need 512 addresses
-- ROM_LENGTH_WORDS = 512
signal word: std_logic_vector(31 downto 0);
type instr_rom is array(0 to 512-1) of std_logic_vector(31 downto 0);
-- Read a *.hex file
impure function instr_rom_readfile(FileName : STRING) return
instr_rom is
file FileHandle : TEXT open READ_MODE is FileName;
variable CurrentLine : LINE;
variable CurrentWord : std_logic_vector(31 downto 0);
variable Result : instr_rom := (others => (others => 'X'));
begin
for i in 0 to 512 - 1 loop
exit when endfile(FileHandle);
readline(FileHandle, CurrentLine);
hread(CurrentLine, CurrentWord);
Result(i) := CurrentWord;
end loop;
return Result;
end function;

--signal rom_words: instr_rom;        -- word addressed read only memory
signal addr_word: std_logic_vector(31 downto 0);  -- 32-bit word addressed pc address input

-- store addi addi add j
-- rom_words(0??= x"00100093"  the instruction at the 1st address is x"00100093" (addi x1, x0, 1)
-- rom_words(1??= x"00200113" the instruction at the 2nd address is x"00200113" (addi x2, x0, 2)
-- rom_words(2??= x"002080b3" the instruction at the 3rd address is x"002080b3" (add x1, x1, x2)
-- rom_words(3??= x"ffdff06f" the instruction at the 4th address is x"ffdff06f" (j loop)
--signal rom_words: instr_rom := (x"00100093", x"00200113", x"002080b3", x"ffdff06f", others => (others =>'X'));
signal rom_words: instr_rom := instr_rom_readfile("main1.mem");

signal lower_bound : std_logic_vector(31 downto 0) :=  x"00ffffff"; -- memory start address
signal upper_bound : std_logic_vector(31 downto 0) :=  x"01000800"; -- memory end address


begin
-- ROM_LENGTH_BITS = 2048 = 2^11 
-- Address Translation divide by 4
-- ROM_ADDR_BITS = 11

-- shift 2 bits
-- addr = 01000004
-- addr = 1000000000000000000000100      addr(11-1 downto 2): 000000001
-- addr_word = 10000000000000000000001     addr_word(11-3 downto 0): 000000001

process(clk, rst) begin
--report "The value of 'rom0' is " & integer'image(to_integer(unsigned(rom_words(0))));
--report "The value of 'rom1' is " & integer'image(to_integer(unsigned(rom_words(1))));
--report "The value of 'rom2' is " & integer'image(to_integer(unsigned(rom_words(2))));
--report "The value of 'rom3' is " & integer'image(to_integer(unsigned(rom_words(3))));
      if (rst = '1') then       -- PC resets to 0x01000000 -> addr = 0x01000000
          -- to_integer(unsigned(addr_word)) = 0
          rom_words <=  (x"00000000", others => (others =>'0'));  -- clear the array
          word <= x"00000000";
      elsif (clk'event and clk = '1') then 
          -- to_integer(unsigned(addr_word)) = 0, 1, 2, 3
          if(imemR = '1') then
              if((unsigned(lower_bound) < unsigned(addr)) and (unsigned(addr) < unsigned(upper_bound))) then
                  if(addr(1 downto 0) /= "00") then word <= x"00000073"; -- halt instr
                  else word <= rom_words(to_integer(unsigned(addr(12 downto 2))));
                  end if;
              else word <= x"00000073"; -- halt instr
              end if;
          end if;
      end if;
end process;
instr <= word;
end Behavioral;


-- input program:
-- addi x1, x0, 1
-- addi x2, x0, 2
-- loop:
-- add x1, x1, x2
-- j loop
