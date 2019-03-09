library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity EX is
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
end EX;

architecture Behavioral of EX is
signal rez_ALU: STD_LOGIC_VECTOR(15 downto 0);
signal ALU_in1,ALU_in2:STD_LOGIC_VECTOR(15 downto 0);
signal rez_mult: STD_LOGIC_VECTOR(31 downto 0);
begin
    Branch_Address<=NI+Ext_Imm;
    ALU_in1<=RD1;
    --RegDst mux
     process(Reg_Dst,RT,RD)
       begin
       case Reg_Dst is
            when '0' => WrAddr <= RT;  --rt
            when '1' => WrAddr <= RD;  --rd
           end case;
       end process;
    --mux;
    process(ALUSrc)
    begin
        if ALUSrc='1' then ALU_in2<=Ext_Imm;
        else if ALUSrc='0' then ALU_in2<=RD2;
            end if;
        end if;
    end process;
    --ALU Control Unit
    process(ALU_Op,Func)
    begin
    if ALU_Op /= "100" then
        Zero<='0';
    end if;
    case (ALU_Op) is
        when "000"=> case (Func) is
                    when "000"=> rez_ALU<=ALU_in1+ALU_in2;
                    when "001"=> rez_ALU<=ALU_in1-ALU_in2;
                    when "010"=> rez_ALU<=ALU_in1(14 downto 0) & "0";
                    when "011"=> rez_ALU<="0" & ALU_in1(15 downto 1);
                    when "100"=> rez_ALU<=ALU_in1 and ALU_in2;
                    when "101"=> rez_ALU<=ALU_in1 or ALU_in2;
                    when "110"=> rez_ALU<=ALU_in1 xor ALU_in2;
                    when "111"=> rez_mult<=ALU_in1 * ALU_in2;
                    rez_ALU<=rez_mult(15 downto 0);
                    when others=> rez_ALU<=ALU_in1+ALU_in2;
                    end case;
         when "001"=> rez_ALU<=ALU_in1+ALU_in2;
         when "010"=> rez_ALU<=ALU_in1+ALU_in2;
         when "011"=> rez_ALU<=ALU_in1+ALU_in2;
         when "100"=> rez_ALU<=ALU_in1-ALU_in2;
            if (rez_ALU="0000000000000000") then Zero<='1';
             else Zero<='0';
             end if;
         when "101"=> rez_ALU<=ALU_in1 or ALU_in2;
         when "110"=> rez_ALU<=ALU_in1 xor ALU_in2;
         when "111"=> rez_ALU<="0000000000000000";
         end case;
    end process;
    ALU_Res<=rez_ALU;
end Behavioral;
