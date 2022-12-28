library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

--Multi-cycle Control Unit
entity control is
  Port (clk: in std_logic;    --clock signal
        rst: in std_logic;    --asynchronous reset signal
        en: in std_logic;     --global enable signal
        opcode: in std_logic_vector (6 downto 0);   --7-bit opcode
        br: out std_logic;                          --1-bit branch control signal
        dmemRW: out std_logic_vector (1 downto 0);  --2-bit read or write data memory control signal
        dmem2Reg: out std_logic_vector (1 downto 0);--2-bit write back source control signal
        ALUOp: out std_logic_vector (1 downto 0);   --2-bit ALU operation control signal
        ALUsrc1: out std_logic;                     --1-bit ALU input source1 control signal
        ALUsrc2: out std_logic;                     --1-bit ALU input source2 control signal
        regRW: out std_logic_vector (1 downto 0);   --1-bit write back to register control signal
        pcW: out std_logic;                         --1-bit write pc control signal
        imemR: out std_logic;                        --1-bit read instruction memory control signal
        jump : out std_logic
        );
end control;

architecture Behavioral of control is
    -- temporary control signals
    signal brt: std_logic;                          
    signal dmemRWt: std_logic_vector (1 downto 0);  
    signal dmem2Regt: std_logic_vector (1 downto 0);
    signal ALUOpt: std_logic_vector (1 downto 0);   
    signal ALUsrc1t: std_logic;                     
    signal ALUsrc2t: std_logic;                     
    signal regRWt: std_logic_vector (1 downto 0);  
    signal jumpt : std_logic;
    
--    signal nop: std_logic;  --nop signal 
    signal halt: std_logic; --halt signal                   
    -- stages

    constant IFE: std_logic_vector (2 downto 0):= "001";    --Instruction Fetch  
    
    constant IDE: std_logic_vector (2 downto 0):= "010";    --Instruction Decode
    
    constant EXE: std_logic_vector (2 downto 0):= "011";    --Instruction Execute
    
    
    
    constant MEM: std_logic_vector (2 downto 0):= "100";    --Memory access
    constant WB: std_logic_vector (2 downto 0):= "101";     --Write Back
    constant HLT: std_logic_vector (2 downto 0):= "000";    --Halt   
    
    constant INI: std_logic_vector (2 downto 0):= "111";
    
    signal stage: std_logic_vector (2 downto 0) := INI;
    signal next_stage: std_logic_vector (2 downto 0);
    
begin
--Calculate control signals based on opcode
process(opcode) begin
    --set temporary control signals to default values
    --opcodet <= opcode;
    
    brt <= '0';
    dmemRWt <= b"00";
    dmem2Regt <= b"00";
    ALUOpt <= b"00";
    ALUsrc1t <= '0';
    ALUsrc2t <= '0';
    regRWt <= b"00";
    halt <= '0';
    jumpt <= '0';
    
    case opcode is
    when "0110111" =>   --LUI
        dmem2Regt <= b"10";
        ALUsrc2t <= '1';
        regRWt <= b"10";
    when "0010111" =>   --AUIPC
        dmem2Regt <= b"10";
        ALUsrc1t <= '1';
        ALUsrc2t <= '1';
        regRWt <= b"10";
    when "1101111" =>   --JAL
        jumpt <= '1';
        ALUsrc1t <= '1';
        ALUsrc2t <= '1';
        regRWt <= b"10";
    when "1100111" =>   --JALR
        ALUsrc2t <= '1';
        regRWt <= b"11";
        jumpt <= '1';
    when "1100011" =>   --branch
        brt <= '1';
        ALUOpt <= b"01";
        ALUsrc1t <= '1';
        ALUsrc2t <= '1';
        regRWt <= b"01";
    when "0000011" =>   --load
        dmemRWt <= b"01";
        dmem2Regt <= b"01";
        ALUsrc2t <= '1';
        regRWt <= b"11";
    when "0100011" =>   --store
        dmemRWt <= b"10";
        ALUsrc2t <= '1';
        regRWt <= b"01";
    when "0010011" =>   --ALU immediate
        dmem2Regt <= b"10";
        ALUOpt <= b"11";
        ALUsrc2t <= '1';
        regRWt <= b"11";
    when "0110011" =>   --R-type
        dmem2Regt <= b"10";
        ALUOpt <= b"10";
        regRWt <= b"11";
    when "1110011" =>   --HALT
        halt <= '1';
    when others => null;
    end case;
end process;
--Update next stage FSM
process(stage) begin
    --set control signals to default values
    br <= '0';
    dmemRW <= b"00";
    dmem2Reg <= b"00";
    ALUOp <= b"00";
    ALUsrc1 <= '0';
    ALUsrc2 <= '0';
    regRW <= b"00";
    pcW <= '0';
    imemR <= '0';
    next_stage <= HLT;
    jump <= '0';
    
    case stage is
    
    when INI =>
        next_stage <= IFE;
    
    when IFE =>
        imemR <= '1';   --activate fetching instruction from IMEM
        if halt = '0' then
            next_stage <= IDE;
        end if;
        
    when IDE =>
        --opcodet <= opcode;
        if halt = '0' then
            next_stage <= EXE;
        end if;   
        
    when EXE =>
        regRW <= '0' & regRWt(0);   --activate reading data from RF
        ALUOp <= ALUOpt;    --select operation type for ALU
        ALUsrc1 <= ALUsrc1t;    --select ALU src1
        ALUsrc2 <= ALUsrc2t;    --select ALU src2
        br <= brt;  --control branch
        jump <= jumpt;
        if halt = '0' then
            if dmemRWt = b"00" then next_stage <= WB;   --skip memory access stage if not load/store
            else next_stage <= MEM;
            end if;
        end if;
--        report (integer'image(to_integer(unsigned(ALUOpt))));
--        report (integer'image(to_integer(unsigned(ALUsrc1t))));
--        report (integer'image(to_integer(unsigned(ALUsrc2t))));

    when MEM =>
        dmemRW <= dmemRWt;  --activate memory read/write
        regRW <= '0' & regRWt(0);   --activate reading data from RF
        ALUOp <= ALUOpt;    --select operation type for ALU
        ALUsrc1 <= ALUsrc1t;    --select ALU src1
        ALUsrc2 <= ALUsrc2t;    --select ALU src2   
        br <= brt;  --control branch
        jump <= jumpt;
        if halt = '0' then
            next_stage <= WB;
        end if;   
                
    when WB =>
        dmem2Reg <= dmem2Regt;  --select write back data
        pcW <= '1'; --activate PC update
        regRW <= regRWt(1) & '0';   --activate RF write back
        
        ALUOp <= ALUOpt;    --select operation type for ALU
        ALUsrc1 <= ALUsrc1t;    --select ALU src1
        ALUsrc2 <= ALUsrc2t;    --select ALU src2
        br <= brt;  --control branch
        jump <= jumpt;
        
        if halt = '0' then
            next_stage <= IFE;
        end if;   

    when HLT =>
        next_stage <= HLT;
    when others => null;  --stay halted
    end case;
end process;
--One stage per clock cycle
process(clk,rst) begin
    if rst = '1' then stage <= IFE; --stage resets to Instruction Fetch
    elsif en = '1' then
        if clk'event and clk = '1' then
            stage <= next_stage;  --update stage
        end if;
    end if;
end process; 

end Behavioral;

--Output signals' meanings:
--br       0: no branch     1: branch if condition met
--dmemRW   0: no DMEM access    1: read data from DMEM      2: write data to DMEM
--dmem2Reg 0: rd = PC+4     1: rd = data from DMEM  2: rd = data from ALU result
--ALUOp    0: LUI,AUIPC,JAL,JALR,and load   1: branch   2: R-type/I-type
--ALUsrc1  0: ALU operand1 = rs1    1: ALU operand1 = PC value
--ALUsrc2  0: ALU operand2 = rs2    1: ALU operand2 = sign-extended immediate value
--regRW    0: no RF access  1: read data from RF    2: write data to RF
--pcW      0: PC = PC   1: PC = new PC
--imemR    0: no IMEM access    1: fetch instruction from IMEM