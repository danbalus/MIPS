----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:52:36 04/06/2015 
-- Design Name: 
-- Module Name:    WB - Behavioral 
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

entity WB is
  Port ( MemToReg : std_logic;
	      ALUResOut : std_logic_vector(15 downto 0);
			MemoryData : std_logic_vector(15 downto 0);
			WriteData : std_logic_vector (15 downto 0)
		);
end WB;

architecture Behavioral of WB is

begin
	WriteBackMUX : process (MemToReg, ALUResOut, MemoryData)
	begin 
		case MemToReg is
			when '0' => WriteData <= ALUResOut;
			when others => WriteData <= MemoryData;
		end case;
	end process;

end Behavioral;

