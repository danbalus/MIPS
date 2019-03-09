----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:42:20 04/06/2015 
-- Design Name: 
-- Module Name:    MemoryData - Behavioral 
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

entity MemoryData is
	Port ( MemWrite : in  STD_LOGIC;
			 clk : in std_Logic;
          ALURes : in  STD_LOGIC_VECTOR (15 downto 0);
          RD2 : in  STD_LOGIC_VECTOR (15 downto 0);
          MemData : out  STD_LOGIC_VECTOR (15 downto 0);
			 enable : in std_logic;
          ALUResOut : out  STD_LOGIC_VECTOR (15 downto 0));
end MemoryData;
architecture Behavioral of MemoryData is

component RAM is
	port ( clk : in std_logic;
		    we : in std_logic;
		    en : in std_logic;
		    addr : in std_logic_vector(15 downto 0);
		    di : in std_logic_vector(15 downto 0);
		    do : out std_logic_vector(15 downto 0));
end component;

begin

	 RAMU:RAM port map (clk, MemWrite, enable, RD2, ALURes, MemData);
	 ALUResOut <= ALURes;
end Behavioral;

