library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity MEM is
  Port ( Mem_Write: in STD_LOGIC;
         Enable: in STD_LOGIC;
         clk: in STD_LOGIC;
         ALU_Res_in: in STD_LOGIC_VECTOR(15 downto 0);
         RD2: in STD_LOGIC_VECTOR(15 downto 0);
         Mem_Data: out STD_LOGIC_VECTOR(15 downto 0);
         ALU_Res_out: out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type mem is array (0 to 63) of std_logic_vector (15 downto 0);
signal RAM: mem := (
0=> "0000000000000011",  --3
1=> "0000000000000010",  --2
2=> "0000000000000001",  --1
3=> "0000000000000000",  --0
4=> "0000000000000101",  --5
5=> "0000000000000000",  --0
6=> "0000000000000111",  --7
7=> "0000000000001000",   --8  //devine 6 in urma instr sw
8=> "0000000000001001",   --9
9=> "0000000000001010",   --10
10=> "0000000000001011",   --11
others=> "0000000000000000"                
);
signal ALU_mem: STD_LOGIC_VECTOR(5 downto 0);  --????
begin
    ALU_mem<=ALU_Res_in(5 downto 0);
    ALU_Res_out<=ALU_Res_in;
    process (clk)
    begin
      if (rising_edge(clk)) then
        if (Enable='1') then 
             if (Mem_Write='1') then
                 RAM(conv_integer(ALU_mem))<=RD2;
             end if;
        end if;
      end if;
      Mem_Data<=RAM(conv_integer(ALU_mem));
    end process;
end Behavioral;
