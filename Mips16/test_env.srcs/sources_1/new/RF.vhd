----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:15:27 03/31/2015 
-- Design Name: 
-- Module Name:    RF - Behavioral 
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

entity RF is
	port (
       clk : in std_logic;
       ReadAdress1 : in std_logic_vector (2 downto 0);
       ReadAdress2 : in std_logic_vector (2 downto 0);
       WriteAdress : in std_logic_vector (2 downto 0);
       WriteData : in std_logic_vector (15 downto 0);
       RegWrite : in std_logic;
       ReadData1 : out std_logic_vector (15 downto 0);
       ReadData2 : out std_logic_vector (15 downto 0)
    );
end RF;

architecture Behavioral of RF is

type reg_array is array (0 to 15 ) of std_logic_vector(15 downto 0);
--signal reg_file : reg_array:=( X"0001", X"0002", X"0003", X"0004",
--										 X"0005", X"0006", X"0007", X"0008",
--										 X"0009", X"000A", X"000B", X"000C",
--                               X"000D", X"000E", X"000F", X"0000" );

signal reg_file : reg_array:=( X"0000", X"0000", X"0000", X"0000",
										 X"0000", X"0000", X"0000", X"0000",
										 X"0000", X"0000", X"0000", X"0000",
                              X"0000", X"0000", X"0000", X"0000" );



begin
   process(clk)
      begin
         --if rising_edge(clk) then
         if clk='1' and clk' event then
                if RegWrite = '1' then
                    reg_file(conv_integer(WriteAdress)) <= WriteData;
               end if;
         end if;
  end process;
ReadData1 <= reg_file(conv_integer(ReadAdress1));
ReadData2 <= reg_file(conv_integer(ReadAdress2)); 

end Behavioral;

