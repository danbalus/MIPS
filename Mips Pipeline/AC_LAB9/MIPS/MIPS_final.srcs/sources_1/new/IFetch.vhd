
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity InstructionFetch is
  Port(clk: in STD_LOGIC;
      btn: in STD_LOGIC_VECTOR(4 downto 0);
      reset: in STD_LOGIC;
      PCSrc: in STD_LOGIC;
      PC_enable:in STD_LOGIC;
      jump: in STD_LOGIC;
      JumpAddress: in STD_LOGIC_VECTOR(15 downto 0);
      BranchAddress: in STD_LOGIC_VECTOR(15 downto 0);
      NextInstruction: out STD_LOGIC_VECTOR(15 downto 0);
      Instruction: out STD_LOGIC_VECTOR(15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is
type memorie is array (0 to 15) of std_logic_vector (15 downto 0);
signal mem: memorie := (
--R 
0=> B"000_001_001_001_0_110",  --RF[1]=RF[1] ^ RF[1]; XOR --------------------0496
1=> B"000_010_010_010_0_110",  --RF[2]=RF[2] ^ RF[2]; XOR---------------------0926
2=> B"000_011_011_011_0_110",  --RF[3]=RF[3] ^ RF[3]; XOR---------------------0db6
3=> B"000_000_000_000_0_000",  --noOp-----------------------------------------0000
4=> B"010_100_001_0000001",    --RF[1]=M[RF[4]+1];  LW------------------------5081
5=> B"001_010_010_0000001",    --RF[2]=RF[2]+1;  ADDI-------------------------2901----2901----/----/----/
6=> B"000_000_000_000_0_000",  --noOp-----------------------------------------0000----0000----/----/----/
7=> B"000_000_000_000_0_000",  --noOp-----------------------------------------0000----0000----/----/----/
8=> B"000_000_000_000_0_000",  --noOp-----------------------------------------0000----0000----/----/----/
9=> B"000_011_010_011_0_000",  --RF[3]=RF[3]+RF[2];  ADD----------------------0d30----0d30----/----/----/
10=> B"100_001_010_0000100",    --if (RF[1]==RF[2]) => sare peste 3 instr1----8504----8504----/----/----/
11=> B"000_000_000_000_0_000",  --noOp----------------------------------------0000----0000----/----/----/
12=> B"000_000_000_000_0_000",  --noOp----------------------------------------0000----0000----/----/----/
13=> B"000_000_000_000_0_000",  --noOp----------------------------------------0000----0000----/----/----/
14=> B"111_0000000000101",      --JUMP to 5-----------------------------------E005----E005----/----/----/
others=> B"000_000_000_000_0_000"  --noOp-------------------------------------0000----0000----/----/----/
);
signal PC: STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";
signal mux2_out: STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";
signal sum_out: STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";
signal mux1_out: STD_LOGIC_VECTOR(15 downto 0);
begin
    process(clk)  --registru->PC
    begin
    if (reset='1') then
        PC<="0000000000000000";
    else  if (rising_edge(clk)) then
             if (PC_enable='1') then
                 PC<=mux2_out;
            end if;
         end if;
     end if;
    end process;
    Instruction<=mem(conv_integer(PC));
    sum_out<=PC+1;
    NextInstruction<=sum_out;
    process(PCSrc) --branch
    begin
        if (PCSrc='1') then
            mux1_out<=BranchAddress;
        else 
            mux1_out<=sum_out;
        end if;    
    end process;
    process(jump) --jump
    begin
        if (jump='1') then
            mux2_out<=JumpAddress;
        else 
            mux2_out<=mux1_out;
        end if;
    end process;
end Behavioral;
