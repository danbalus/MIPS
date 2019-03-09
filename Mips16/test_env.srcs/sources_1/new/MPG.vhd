----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:50:44 03/16/2015 
-- Design Name: 
-- Module Name:    MPG - Behavioral 
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

entity MPG is
	port(	btn : in std_logic;
			clk : in std_logic;
			enable : out std_logic);
end MPG;

architecture Behavioral of MPG is
signal counter : std_logic_vector(15 downto 0):= x"0000";
signal e1 : std_logic;
signal d1 : std_logic;
signal d2 : std_logic;
signal d3 : std_logic;
begin
--proces numarator
numarator: process (clk )
begin	
			if clk='1' and clk'event then
		           counter<=counter + 1;
	      end if;
end process numarator;

--proces poarta si pe 16 biti
poartaSi: process (counter(15 downto 0))
  begin
	if counter(15 downto 0) = x"FFFF" then e1<= '1';
		else e1<= '0';
	end if;
 end process poartaSi;

--proces registru1
reg1: process(clk)
	begin
		if clk = '1' and clk'event  then
			if e1= '1' then
				d1<= btn;
			end if;
		end if;
end process reg1;

--process registru2
reg2: process(clk)
	begin
		if clk= '1' and clk'event then
			d2<=d1;
		end if;
end process reg2;

--process registru3
reg3: process(clk)
	begin
		if clk= '1' and clk'event then
			d3<=d2;
		end if;
end process reg3;

--atribuite enable
 enable <= not(d3) and d2 ;


end Behavioral;

