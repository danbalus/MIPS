
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity InstructionDecode is
   Port (clk: in STD_LOGIC;
        WrAddr: in STD_LOGIC_VECTOR(2 downto 0);
        WE:in STD_LOGIC;
        Instr: in STD_LOGIC_VECTOR(15 downto 0);
        WD: in STD_LOGIC_VECTOR(15 downto 0);
        Reg_Write: in STD_LOGIC;
        ExtOp: in STD_LOGIC;
        RD1: out STD_LOGIC_VECTOR(15 downto 0);
        RD2: out STD_LOGIC_VECTOR(15 downto 0);
        Ext_Imm: out STD_LOGIC_VECTOR(15 downto 0);
        Func: out STD_LOGIC_VECTOR(2 downto 0);
        Sa: out STD_LOGIC);
end InstructionDecode;

architecture Behavioral of InstructionDecode is
component Reg_File is
  Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
         RA2 : in STD_LOGIC_VECTOR (2 downto 0);
         WA : in STD_LOGIC_VECTOR (2 downto 0);
         WD : in STD_LOGIC_VECTOR (15 downto 0);
         Reg_Write : in STD_LOGIC;
         clk : in STD_LOGIC;
         WE: in STD_LOGIC;
         RD1 : out STD_LOGIC_VECTOR (15 downto 0);
         RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;
signal extension : std_logic_vector (15 downto 0) := x"0000"; 
begin
   
    process(ExtOp,Instr)
    begin
    if (ExtOp='1') and (Instr(6)='1') then 
        extension<=B"111111111" & Instr(6 downto 0);
    else if ExtOp='0' then
         extension <= B"000000000" & Instr(6 downto 0);
         end if;
    end if;
    end process;
    Ext_Imm<=extension;
    Sa<=Instr(3);
    Func<=Instr(2 downto 0);
    p1: Reg_File port map(Instr(12 downto 10),Instr(9 downto 7),WrAddr,WD,Reg_Write,clk,WE,RD1,RD2);
    
end Behavioral;
