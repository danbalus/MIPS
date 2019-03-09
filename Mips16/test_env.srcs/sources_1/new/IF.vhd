----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:12:07 03/23/2015 
-- Design Name: 
-- Module Name:    IF - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
    Port ( clk : in  STD_LOGIC;
	        reset: in STD_LOGIC;
			  enablePC :in STD_LOGIC;
	        adr_branch : in  STD_LOGIC_VECTOR (15 downto 0);
			  adr_jump : in  STD_LOGIC_VECTOR (15 downto 0);
			  jump: in STD_LOGIC ;
			  PCSrc: in STD_LOGIC;
			  instr : out STD_LOGIC_VECTOR (15 downto 0);
			  adr_next : out STD_LOGIC_VECTOR(15 downto 0) 
			  );
end IFetch;

architecture Behavioral of IFetch is
--memoria de instructiuni
component ROM is
port(
	A: in STD_LOGIC_VECTOR(7 downto 0);
	DO: out STD_LOGIC_VECTOR(15 downto 0));
end component ;

signal pc: STD_LOGIC_VECTOR (15 downto 0):=X"0000";
signal iesireMux2 : STD_LOGIC_VECTOR (15 downto 0):=X"0000";
signal iesireMux1 : STD_LOGIC_VECTOR (15 downto 0):=X"0000";
signal iesireAdder: STD_LOGIC_VECTOR (15 downto 0);
signal instructiune :  STD_LOGIC_VECTOR (15 downto 0);

begin

--incarc in pc adresa --folosim bistabil d
PCu: process( reset,clk,enablePC) 
	begin
	   if(reset = '1') then
			pc <= x"0000";
		  elsif clk'event and clk='1' and enablePC='1' then
				pc <= iesireMux2;
		end if;
end process PCu ;

--calc adresa next
ADDER: process(pc)
   begin
      iesireAdder<= pc + 1;
end process ADDER;

adr_next <= iesireAdder;

--citire din rom
MEMORIE : ROM port map ( pc( 7 downto 0 ) ,instructiune );
instr <= instructiune ;
--branch
Mux1: process ( PCSrc )
   begin 
	  if PCSrc ='1' then 
	       iesireMux1 <= adr_branch;
		 else iesireMux1 <= iesireAdder ;
	  end if ;
end process Mux1;

--jump
Mux2: process ( jump , instructiune(15 downto 13) )
   begin 
	  --if jump = '0' then
       if(instructiune(15 downto 13) ) ="111" then	  
	       iesireMux2 <= adr_jump ;
		 --end if;
		 else iesireMux2 <= iesireMux1;
	  end if ;
end process Mux2;

end Behavioral;

