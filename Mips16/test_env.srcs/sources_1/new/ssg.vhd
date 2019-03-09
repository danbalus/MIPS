----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:45:06 03/02/2015 
-- Design Name: 
-- Module Name:    ssg - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssg is
    Port ( digit : in  STD_LOGIC_VECTOR (15 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0);
			  clk : in std_logic);
end ssg;

architecture Behavioral of ssg is
--declarare semnale
signal iesireMux1 :std_logic_vector (3 downto 0);
signal sel : std_logic_vector (1 downto 0);
signal count : std_logic_vector (15 downto 0);
signal anod : std_logic_vector (3 downto 0);
signal catod : std_logic_vector(6 downto 0);


begin
--proces mux1
mux1 : process(sel)
begin
	case sel is
		when "00" => iesireMux1 <= digit(15 downto 12);
		when "01" => iesireMux1 <= digit(11 downto 8);
		when "10" => iesireMux1 <= digit(7 downto 4);
		when "11" => iesireMux1 <= digit(3 downto 0);
		when others => iesireMux1 <= "0000";
   end case;
end process mux1;

-- proces mux2
mux2: process(sel)
begin
	case sel is
		when "00" => anod <= "1110";
		when "01" => anod <= "1101";
		when "10" => anod <= "1011";
		when "11" => anod <= "0111";
		when others => anod <="1111";
	end case;
end process;


-- segment encoinputg
--      0
--     ---  
--  5 |   | 1
--     ---   <- 6
--  4 |   | 2
--     ---
--      3

-- proces dcd
dcd: process (iesireMux1)
begin 
	case iesireMux1 is
		when "0000" => catod <= "1000000";--0
		when "0001" => catod <="1111001"; --1
		when "0010" => catod <="0100100"; --2
		when "0011" => catod <="0110000"; --3
		when "0100" => catod <="0011001"; --4
		when "0101" => catod <="0010010"; --5
		when "0110" => catod <="0000010"; --6
		when "0111" => catod <="1111000"; --7
		when "1000" => catod <="0000000"; --8
		when "1001" => catod <="0010000"; --9
		when "1010" => catod <="0001000"; --A
		when "1011" => catod <="0000011"; --b
		when "1100" => catod <="1000110"; --C
		when "1101" => catod <="0100001"; --d
		when "1110" => catod <="0000110"; --E
		when "1111" => catod <="1000000"; --F
		when others => catod <="0000110";
	end case;
end process dcd;

-- proces counter
counter: process
begin
		if clk='1'and clk'event then 
			count <= count + 1;
		end if;
end process counter;
sel(1)<= count(15);
sel(0) <= count(14);

--atribuiri finale
an <= anod;
cat <=catod;
end Behavioral;

