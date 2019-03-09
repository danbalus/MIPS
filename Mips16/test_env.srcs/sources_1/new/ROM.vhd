----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:37:55 03/23/2015 
-- Design Name: 
-- Module Name:    ROM - Behavioral 
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

entity ROM is
port(
	A: in STD_LOGIC_VECTOR(7 downto 0);
	DO: out STD_LOGIC_VECTOR(15 downto 0));
end ROM;

architecture Behavioral of ROM is
type rom_type is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal ROM: rom_type := ( -- al zecelea termen al sirului lui fibonacci
								 B"001_000_001_0000001", --addi $1 , $0 , 000x1   ---- a = 1; primul element din sirul lui fibonacci
								 B"001_000_010_0000001", --addi $2 , $0 , 000x1   ---- b = 1; al doilea element din sirul lui fibonacci
								 B"001_000_011_0001010", --addi $3 , $0 , 000x4  ---- pozElementCautat = 4;
								 B"001_000_100_0000010", --addi $4 , $0 , 000x2   ---- contor = 2 ;
								 --eticheta 												  ---- do
								 B"000_001_010_101_0_001",--add $5 , $1 , $2      ---- c = a+b ;
								 B"001_010_001_0000000", --addi $1 , $2 , 000x0   ---- a = b + 0 ;
								 B"001_101_010_0000000", --addi $2 , $5 , 000x0   ---- b = c + 0;
								 B"001_100_111_0000000", --addi $4 , $4 , 000x1   ---- contor = contor +1 ;
								 B"001_000_110_0000001", --beq $3 , $4 , 000x1    ---- while ( contor != pozElementCautat )
								 B"000_110_111_100_0_001",
								 B"011_011_100_0000001",
								 B"111_0000000000100",   --j eticheta = sari la instructiunea 4 iar           
								 others=> B"1111111111111111");

begin
	DO <= ROM(conv_integer(A));
end Behavioral;

