library IEEE;
use IEEE.std_logic_1164.ALL;
--Multi-cycle Control Unit
entity control is
  Port (clk: in std_logic;    --clock signal
        rst: in std_logic;    --asynchronous reset signal
        en: in std_logic;     --global enable signal
        outofbound: in std_logic;     --dmem address out of bound signal
        opcode: in std_logic_vector (6 downto 0);   --7-bit opcode
        br: out std_logic;                          --1-bit branch control signal
        dmemRW: out std_logic_vector (1 downto 0);  --2-bit read or write data memory control signal
        dmem2Reg: out std_logic_vector (1 downto 0);--2-bit write back source control signal
        ALUOp: out std_logic_vector (1 downto 0);   --2-bit ALU operation control signal
        ALUsrc1: out std_logic;                     --1-bit ALU input source1 control signal
        ALUsrc2: out std_logic;                     --1-bit ALU input source2 control signal
        regRW: out std_logic_vector (1 downto 0);   --1-bit write back to register control signal
        pcW: out std_logic;                         --1-bit write pc control signal
        imemR: out std_logic                        --1-bit read instruction memory control signal
        );
end control;

architecture Behavioral of control is
    -- temporary control signals
    signal opcode: std_logic_vector (6 downto 0);
    signal brt: std_logic;                          
    signal dmemRWt: std_logic_vector (1 downto 0);  
    signal dmem2Regt: std_logic_vector (1 downto 0);
    signal ALUOpt: std_logic_vector (1 downto 0);   
    signal ALUsrc1t: std_logic;                     
    signal ALUsrc2t: std_logic;                     
    signal regRWt: std_logic_vector (1 downto 0);  
    
--    signal nop: std_logic;  --nop signal 
    signal halt: std_logic; --halt signal                   
    -- stages
    signal stage: std_logic_vector (2 downto 0);
    signal next_stage: std_logic_vector (2 downto 0);
    constant IFE: std_logic_vector (2 downto 0):= "001";    --Instruction Fetch  
    constant EXE: std_logic_vector (2 downto 0):= "010";    --Instruction Decode and Execute
    constant MEM: std_logic_vector (2 downto 0):= "011";    --Memory access
    constant WB: std_logic_vector (2 downto 0):= "100";     --Write Back
    constant HLT: std_logic_vector (2 downto 0):= "000";    --Halt   
begin
--Calculate control signals based on opcode
opcode <= instr(6 downto 0);
process(opcode) begin
    --set temporary control signals to default values
    brt <= '0';
    dmemRWt <= b"00";
    dmem2Regt <= b"00";
    ALUOpt <= b"00";
    ALUsrc1t <= '0';
    ALUsrc2t <= '0';
    regRWt <= b"00";
    halt <= outofbound;
    
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
        brt <= '1';
        ALUsrc1t <= '1';
        ALUsrc2t <= '1';
        regRWt <= b"10";
    when "1100111" =>   --JALR
        brt <= '1';
        ALUsrc2t <= '1';
        regRWt <= b"10";
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
        ALUOpt <= b"10";
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
    case stage is
    when IFE =>
        imemR <= '1';   --activate fetching instruction from IMEM
        next_stage <= EXE;
    when EXE =>
        regRW <= '0' & regRWt(0);   --activate reading data from RF
        ALUOp <= ALUOpt;    --select operation type for ALU
        ALUsrc1 <= ALUsrc1t;    --select ALU src1
        ALUsrc2 <= ALUsrc2t;    --select ALU src2
        br <= brt;  --control branch
        if halt = '0' then
            if dmemRWt = b"00" then next_stage <= WB;   --skip memory access stage if not load/store
            else next_stage <= MEM;
            end if;
        end if;
    when MEM =>
        dmemRW <= dmemRWt;  --activate memory read/write
        next_stage <= WB;
    when WB =>
        dmem2Reg <= dmem2Regt;  --select write back data
        pcW <= '1'; --activate PC update
        regRW <= regRWt(1) & '0';   --activate RF write back
        next_stage <= IFE;
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
