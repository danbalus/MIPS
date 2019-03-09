library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Main is
   Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw: in STD_LOGIC_VECTOR(15 downto 0);
         led: out STD_LOGIC_VECTOR(15 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0);
         an : out STD_LOGIC_VECTOR (3 downto 0));
end Main;

architecture Behavioral of Main is
component MPG is
 Port ( clk : in STD_LOGIC;
          btn : in STD_LOGIC;
          en : out STD_LOGIC);
end component;
component SSD is
    Port ( cat: out STD_LOGIC_VECTOR (6 downto 0);
       clk : in STD_LOGIC;
       D: in STD_LOGIC_VECTOR(15 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0));
end component;
component InstructionFetch is
 Port(clk: in STD_LOGIC;
     btn: in STD_LOGIC_VECTOR(4 downto 0);--btn(0)-validare scriere PC, btn(4)-reset PC
     reset: in STD_LOGIC;
     PCSrc: in STD_LOGIC;
      PC_enable:in STD_LOGIC;
     jump: in STD_LOGIC;
     JumpAddress: in STD_LOGIC_VECTOR(15 downto 0);
     BranchAddress: in STD_LOGIC_VECTOR(15 downto 0);
     NextInstruction: out STD_LOGIC_VECTOR(15 downto 0);
     Instruction: out STD_LOGIC_VECTOR(15 downto 0));
end component;
component UC is
Port	(    Instr:in std_logic_vector(2 downto 0);
			 RegDst: out std_logic;
			 ExtOp: out std_logic;
			 ALUSrc: out std_logic;
			 Branch: out std_logic;
			 Jump: out std_logic;
			 ALUOp: out std_logic_vector(2 downto 0);
			 MemWrite: out std_logic;
			 MemtoReg: out std_logic;
			 RegWrite: out std_logic);

end component;
component InstructionDecode is
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
end component;
component EX is
   Port ( NI: in STD_LOGIC_VECTOR(15 downto 0);
        RT: in STD_LOGIC_VECTOR(2 downto 0);
        RD: in STD_LOGIC_VECTOR(2 downto 0);
        Reg_Dst: in STD_LOGIC;
        RD1: in STD_LOGIC_VECTOR(15 downto 0);
        RD2: in STD_LOGIC_VECTOR(15 downto 0);
        ALUSrc: in STD_LOGIC;
        Ext_Imm: in STD_LOGIC_VECTOR(15 downto 0);
        Sa: in STD_LOGIC;
        Func: in STD_LOGIC_VECTOR(2 downto 0);
        ALU_Op: in STD_LOGIC_VECTOR(2 downto 0);
        Branch_Address: out STD_LOGIC_VECTOR(15 downto 0);
        Zero: out STD_LOGIC;
        WrAddr: out STD_LOGIC_VECTOR(2 downto 0);
        ALU_Res: out STD_LOGIC_VECTOR(15 downto 0));
end component;
component MEM is
  Port ( Mem_Write: in STD_LOGIC;
       Enable:in STD_LOGIC;
       clk: in STD_LOGIC;
       ALU_Res_in: in STD_LOGIC_VECTOR(15 downto 0);
       RD2: in STD_LOGIC_VECTOR(15 downto 0);
       Mem_Data: out STD_LOGIC_VECTOR(15 downto 0);
       ALU_Res_out: out STD_LOGIC_VECTOR(15 downto 0));
end component;
signal PC_enable, PC_reset: STD_LOGIC;
signal JA,BA,NI,Instr: STD_LOGIC_VECTOR(15 downto 0);
signal digits: STD_LOGIC_VECTOR(15 downto 0);
signal Reg_Dest,Ext_Op,ALU_Src,Branch,Jump,Mem_Write,Mem_toReg,Reg_Write,PC_Src: STD_LOGIC;
signal ALU_Op: STD_LOGIC_VECTOR(2 downto 0);
signal WD,RD1,RD2,Ext_Imm : STD_LOGIC_VECTOR(15 downto 0);
signal Func: STD_LOGIC_VECTOR(2 downto 0);
signal ALU_Result_in,ALU_Result_out: STD_LOGIC_VECTOR(15 downto 0);
signal Sa: STD_LOGIC;
signal MEM_out: STD_LOGIC_VECTOR(15 downto 0);
signal Zero_Flag: STD_LOGIC;
signal WrAddr: STD_LOGIC_VECTOR(2 downto 0);
--Etaje
signal Reg_IF_ID: STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000000";
signal Reg_ID_EX: STD_LOGIC_VECTOR(82 downto 0):="00000000000000000000000000000000000000000000000000000000000000000000000000000000000";
signal Reg_EX_MEM: STD_LOGIC_VECTOR(55 downto 0):="00000000000000000000000000000000000000000000000000000000";
signal Reg_MEM_WB: STD_LOGIC_VECTOR(36 downto 0):="0000000000000000000000000000000000000";
begin
--btn(0)-validare scriere PC, btn(4)-reset PC
    p1: MPG port map(clk,btn(0),PC_enable);
    p2: MPG port map(clk,btn(4),PC_reset);
    p3: InstructionFetch port map(clk,btn,PC_reset,PC_Src,PC_enable,Jump,JA,Reg_EX_MEM(55 downto 40),NI,Instr);--sw(1)-PcSrc, sw(0)-Jump
    p4: UC port map(Reg_IF_ID(15 downto 13),Reg_Dest,Ext_Op,ALU_Src,Branch,Jump,ALU_Op,Mem_Write,Mem_toReg,Reg_Write);
    -- InstrDecode(clk,WrAddr,WE,Instr,WD,Reg_Write,ExtOp,/// RD1,RD2,Ext_Imm,Func,Sa)
    p5: InstructionDecode port map(clk, Reg_MEM_WB(4 downto 2),PC_enable,Reg_IF_ID(15 downto 0),WD,Reg_MEM_WB(0),Ext_Op,RD1,RD2,Ext_Imm,Func,Sa); 
    -- MEM(MemWrite,Enable,clk,ALU_Res_in,RD2,/// Mem_Data,ALU_Res_out);
    p6: MEM port map(Reg_EX_MEM(1),PC_enable,clk,Reg_EX_MEM(38 downto 23), Reg_EX_MEM(22 downto 7),MEM_out,ALU_Result_out);
    -- EX: (NI,RT,RD,Reg_Dst,RD1,RD2,Alu_Src,Ext_imm,Sa,Func,Alu_op,/// Branch_Addr,Zero,WrAddr,ALU_Res);
    p7: EX port map(Reg_ID_EX(82 downto 67),Reg_ID_EX(18 downto 16),Reg_ID_EX(15 downto 13),Reg_ID_EX(0),Reg_ID_EX(66 downto 51),Reg_ID_EX(50 downto 35),Reg_ID_EX(1),Reg_ID_EX(34 downto 19),Reg_ID_EX(9),Reg_ID_EX(12 downto 10), Reg_ID_EX(4 downto 2),BA,Zero_Flag,WrAddr,ALU_Result_in);
    PC_Src<=Reg_EX_MEM(0) and Reg_EX_MEM(39);
    process(Reg_MEM_WB(1),MEM_out,ALU_Result_out)
    begin
        if Reg_MEM_WB(1)='1' then 
            WD<=Reg_MEM_WB(36 downto 21);
        else if Reg_MEM_WB(1)='0' then
            WD<=Reg_MEM_WB(20 downto 5);
             end if;
    end if;
    end process;
    JA<="000" & Reg_IF_ID(12 downto 0);
    --IF/ID
    process(clk,PC_enable)
    begin
    if (rising_edge(clk)) then
        if (PC_enable='1') then
            Reg_IF_ID(31 downto 16)<=NI;
            Reg_IF_ID(15 downto 0)<=Instr;
        end if;
    end if;
    end process;
    --ID/EX
    process(clk,PC_enable)
    begin
    if (rising_edge(clk)) then
        if (PC_enable='1') then
            Reg_ID_EX(82 downto 67)<=Reg_IF_ID(31 downto 16); --NI
            Reg_ID_EX(66 downto 51)<=RD1;
            Reg_ID_EX(50 downto 35)<=RD2;
            Reg_ID_EX(34 downto 19)<=Ext_Imm;
            Reg_ID_EX(18 downto 16)<=Reg_IF_ID(9 downto 7);  --rt
            Reg_ID_EX(15 downto 13)<=Reg_IF_ID(6 downto 4);  --rd
            Reg_ID_EX(12 downto 10)<=Func;--Reg_IF_ID(2 downto 0);  --func
            Reg_ID_EX(9)<=Sa;--Reg_IF_ID(3);  --sa
            Reg_ID_EX(8)<=Mem_toReg;
            Reg_ID_EX(7)<=Reg_Write;
            Reg_ID_EX(6)<=Mem_Write;
            Reg_ID_EX(5)<=Branch;
            Reg_ID_EX(4 downto 2)<=ALU_op;
            Reg_ID_EX(1)<=ALU_Src;
            Reg_ID_EX(0)<=Reg_Dest;
        end if;
    end if;
    end process;
    --EX/MEM
    process(clk,PC_enable)
    begin
    if (rising_edge(clk)) then
        if (PC_enable='1') then
            Reg_EX_MEM(55 downto 40)<=BA;
            Reg_EX_MEM(39)<=Zero_Flag;
            Reg_EX_MEM(38 downto 23)<=ALU_Result_in;
            Reg_EX_MEM(22 downto 7)<=Reg_ID_EX(50 downto 35);  --RD2
            Reg_EX_MEM(6 downto 4)<=WrAddr;
            Reg_EX_MEM(3)<=Reg_ID_EX(8);  --Mem To Reg
            Reg_EX_MEM(2)<=Reg_ID_EX(7);  --RegWrite
            Reg_EX_MEM(1)<=Reg_ID_EX(6);  --MemWrite
            Reg_EX_MEM(0)<=Reg_ID_EX(5);  --Branch
        end if;
    end if;
    end process;
    --MEM/WB
    process(clk,PC_enable)
    begin
    if (rising_edge(clk)) then
        if (PC_enable='1') then
            Reg_MEM_WB(36 downto 21)<=MEM_Out;
            Reg_MEM_WB(20 downto 5)<=Reg_EX_MEM(38 downto 23);  --ALU res  --ALU_RES_OUT
            Reg_MEM_WB(4 downto 2)<=Reg_EX_MEM(6 downto 4);  --WrAddr
            Reg_MEM_WB(1)<=Reg_EX_MEM(3);  --Mem to reg
            Reg_MEM_WB(0)<=Reg_EX_MEM(2);  --RegWrite
        end if;
    end if;
    end process;
    process(sw,Instr,RD1,RD2,WD,NI)
    begin
        case sw(8 downto 5) is
            when "0000"=>digits<=Instr;
            when "0001"=>digits<=NI;
            when "0010"=>digits<=RD1; 
            when "0011"=>digits<=RD2;
            when "0100"=>digits<=Ext_Imm;
            when "0101"=>digits<=ALU_Result_in;
            when "0110"=>digits<=MEM_out;
            when "0111"=>digits<=WD;
            when "1000"=>digits <= Reg_ID_EX(66 downto 51);
            when "1001"=>digits <= Reg_ID_EX(34 downto 19);
            when "1010"=>digits <= Reg_EX_MEM(38 downto 23);
            when "1011"=>digits <="0000000000000" & Func;
            when "1100"=> digits<="0000000000000" & WrAddr;
            when "1101"=> digits<=ALU_Result_out;
            when others=>digits<="0000000000000000";
         end case;
    end process;
    process(sw,Reg_Dest,Ext_Op,ALU_Src,Branch,Jump,Mem_Write,Mem_toReg,Reg_Write,Zero_Flag)
    begin
       if sw(0)='0' then
        led(0)<=Reg_Dest;
        led(1)<=Ext_Op;
        led(2)<=ALU_Src;
        led(3)<=Branch;
        led(4)<=Jump;
        led(5)<=Mem_Write;
        led(6)<=Mem_toReg;
        led(7)<=Reg_Write;
        led(8)<=Zero_Flag;
       end if;
       if sw(0)='1' then
         led(2 downto 0)<=ALU_Op;
         led(15 downto 3)<="0000000000000";
        end if;        
    end process;
    p8: SSD port map(cat,clk,digits,an);
end Behavioral;
