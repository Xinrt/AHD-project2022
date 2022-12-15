library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use work.reg_32_pkg.all;


entity processor is
  Port (clk0: in std_logic;    --clock signal
        rst0: in std_logic;    --asynchronous reset signal
        en0: in std_logic;     --global enable signal
        sw: in std_logic_vector(16 downto 0);  --input switches
        regfile: out reg_32   --output register file
        );
end processor;

architecture Behavioral of processor is
    signal rst1,rst2,rstx: std_logic; --synchronized asynchronous reset signal
    --Control Unit
    signal opcode0: std_logic_vector (6 downto 0);
    signal brctrl,src1mux,src2mux: std_logic;
    signal wbmux: std_logic_vector (1 downto 0);
    component control is
        port(
            clk, rst, en: in std_logic;
            opcode: in std_logic_vector (6 downto 0);   
            br: out std_logic;                          
            dmemRW: out std_logic_vector (1 downto 0);  
            dmem2Reg: out std_logic_vector (1 downto 0);
            ALUOp: out std_logic_vector (1 downto 0);   
            ALUsrc1: out std_logic;                     
            ALUsrc2: out std_logic;                     
            regRW: out std_logic_vector (1 downto 0);   
            pcW: out std_logic;                         
            imemR: out std_logic 
        );
    end component;
    --Program Counter
    signal pcW0: std_logic;
    signal pcin: std_logic_vector (31 downto 0);
    signal pcout: std_logic_vector (31 downto 0);
    component pc is
        port(
            clk, rst, pcW: in std_logic;
            addr_in: in std_logic_vector(31 downto 0);
            addr_out: out std_logic_vector(31 downto 0)
        );
    end component;
    --Instruction Memory
    signal imemR0: std_logic;
    signal instr0: std_logic_vector (31 downto 0);
    component imem is
        port(
            clk, rst, imemR: in std_logic;
            addr: in std_logic_vector(31 downto 0);
            instr: out std_logic_vector(31 downto 0)
        );
    end component;
    --Register File
    signal regRW0: std_logic_vector (1 downto 0);
    signal rfdin,rfdout1,rfdout2: std_logic_vector (31 downto 0);
    signal reg_out0: reg_32;
    component rf is
        port(
            clk, rst: in std_logic;
            regRW: in std_logic_vector (1 downto 0);
            r1,r2,rd: in std_logic_vector(4 downto 0);
            din: in std_logic_vector (31 downto 0);
            dout1,dout2: out std_logic_vector(31 downto 0);
            reg_out: out reg_32
        );
    end component;
    --Arithmetic Logic Unit Control
    signal ALUOp0: std_logic_vector (1 downto 0);
    component alucontrol is
        port(
            ALUOp: in std_logic_vector(1 downto 0);
            func7bit2: in std_logic;
            func3: in std_logic_vector(2 downto 0);
            cout: out std_logic_vector(3 downto 0)
        );
    end component;
    --Arithmetic Logic Unit
    signal aluctrl: std_logic_vector(3 downto 0);
    signal op1,op2,aludout: std_logic_vector(31 downto 0);
    signal alubr: std_logic;
    component alu is
        port(
            control: in std_logic_vector(31 downto 0);
            operand1,operand2,din1,din2: in std_logic_vector(31 downto 0);
            dout: out std_logic_vector(31 downto 0);
            brout: out std_logic
        );
    end component;
    --Immediate Generator
    signal imm: std_logic_vector(31 downto 0);
    component immgen is
        port(
            instr: in std_logic_vector(31 downto 0);
            immout: out std_logic_vector(31 downto 0)
        );
    end component;
    --Data Memory
    signal dmemRW0: std_logic_vector(1 downto 0);
    signal dmemdout: std_logic_vector(31 downto 0);
    signal haltmux: std_logic;
    signal func: std_logic_vector(2 downto 0);
    component dmem is
        port(
            clk, rst: in std_logic;
            dmemRW: in std_logic_vector (1 downto 0);
            func3: in std_logic_vector(2 downto 0);
            addr: in std_logic_vector(31 downto 0);
            sw0: in std_logic_vector(16 downto 0);
            din: in std_logic_vector(31 downto 0);
            dout: out std_logic_vector(31 downto 0);
            outofbound: out std_logic
        );
    end component;
    --branch multiplexer control
    signal brmux: std_logic;
begin
--    process(rst0) begin
--        if rst0 = '1' then
--            rst1 <= '1';
--            rst2 <= '1';
--        else
--            rst1 <= '0';
--            rst2 <= rst1;
--        end if;
--    end process;
--    rstx <= rst2;
    --multiplexers
    brmux <= brctrl and alubr;
    func <= instr0(14 downto 12);
    with haltmux select opcode0 <= instr0(6 downto 0) when '0', b"1110011" when '1';
    with brmux select pcin <= pcout + b"100" when '0', aludout when '1';
    with src1mux select op1 <= rfdout1 when '0', pcout when '1';
    with src2mux select op2 <= rfdout2 when '0', imm when '1';
    with wbmux select rfdin <= pcout + b"100" when b"00", dmemdout when b"01", aludout when b"10"; 
    --component mappings
    control0: control
        port map(
            clk => clk0, rst => rst0, en => en0,
            opcode => opcode0,
            br => brctrl,
            dmemRW => dmemRW0,
            dmem2Reg => wbmux,
            ALUOp => ALUOp0,
            ALUsrc1 => src1mux,                     
            ALUsrc2 => src2mux,                     
            regRW => regRW0,  
            pcW => pcW0,                         
            imemR => imemR0
        );
    pc0: pc
        port map(
            clk => clk0, rst => rst0,
            pcW => pcW0,
            addr_in => pcin,
            addr_out => pcout
        );
    imem0: imem
        port map(
            clk => clk0, rst => rst0,
            imemR => imemR0,
            addr => pcout,
            instr => instr0
        );
    rf0: rf
        port map(
            clk => clk0, rst => rst0,
            regRW => regRW0,
            r1 => instr0(19 downto 15),
            r2 => instr0(24 downto 20),
            rd => instr0(11 downto 7),
            din => rfdin,
            dout1 => rfdout1,
            dout2 => rfdout2,
            reg_out => reg_out0
        );
    alucontrol0: alucontrol
        port map(
            ALUOp => ALUOp0,
            func7bit2 => instr0(30),
            func3 => instr0(14 downto 12),
            cout => aluctrl
        );
    alu0: alu
        port map(
            control => aluctrl,
            operand1 => op1,
            operand2 => op2,
            din1 => rfdout1,
            din2 => rfdout2,
            dout => aludout,
            brout => alubr
        );
    immgen0: immgen
        port map(
            instr => instr0,
            immout => imm
        );
    dmem0: dmem
        port map(
            clk => clk0, rst => rst0,
            dmemRW => dmemRW0,
            func3 => func,
            addr => aludout,
            sw0 => sw,
            din => rfdout2,
            dout => dmemdout,
            outofbound => haltmux
        );
regfile <= reg_out0;
end Behavioral;
