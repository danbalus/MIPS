
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Reg_File is
    Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Reg_Write : in STD_LOGIC;
           clk : in STD_LOGIC;
           WE: in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end Reg_File;

architecture Behavioral of Reg_File is
type memorie is array (0 to 7) of std_logic_vector (15 downto 0);
signal mem: memorie := (
0=> "0000000000000000",  --0
1=> "0000000000000000",  --0
2=> "0000000000000000",  --0  
3=> "0000000000000000",  --0 
4=> "0000000000000011",  --3
others=> "0000000000000000"
);
begin
    process(clk,WE) 
    begin
          if (clk'event and clk='1') then
            if Reg_Write='1' then
                if  WE='1'  then  
                   mem(conv_integer(WA))<=WD;
                 end if;
             end if;
          end if;
          RD1<=mem(conv_integer(RA1));
          RD2<=mem(conv_integer(RA2));
    end process;

end Behavioral;
