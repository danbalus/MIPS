----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:13:03 03/31/2015 
-- Design Name: 
-- Module Name:    ID - Behavioral 
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

entity ID is
	Port(
		Clk: in std_logic;
		Instruction: in std_logic_vector (15 downto 0); -- operanzi	
		RegDst:in std_logic; -- selectia pt mux
		WD: in std_logic_vector (15 downto 0);
		ExtOp: in std_logic; -- extindere de semn
		RegWrite: in std_logic;
		RD1: out std_logic_vector (15 downto 0);
		RD2: out std_logic_vector (15 downto 0);
		Ext_imm: out std_logic_vector (15 downto 0);
		functionALU: out std_logic_vector (2 downto 0);
		sa: out std_logic
		);
		
end ID;

architecture Behavioral of ID is

component RF is
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
end component;

--semnale ptr extindere cu 0 sau semn
signal concat_plus: std_logic_vector (8 downto 0) := "000000000";
signal concat_minus: std_logic_vector (8 downto 0) :="111111111";
--semnale intermediare
signal mux_out: std_logic_vector (2 downto 0);
signal concat: std_logic_vector (15 downto 0);

begin

--se activeaza scrierea (front crescator de ceas!) valorii pe 16 de biti de pe Write Data în registrul 
--dat de Write Address, in RF
RF1: RF port map(Clk,Instruction(12 downto 10),Instruction(9 downto 7),mux_out,WD,RegWrite,RD1,RD2);

--semnalul de control RedDst
process(RegDst)
   begin
      case RegDst is
          when '0'=> mux_out<=Instruction(9 downto 7);
          when '1'=> mux_out<=Instruction(6 downto 4 );
          when others=>mux_out<=Instruction(6 downto 4 );
      end case;
  end process;
--proces extindere semn
process(ExtOP)
  begin
	if (ExtOP = '1') then 
		case Instruction(6) is
          when '0'=>concat<=concat_plus & Instruction(6 downto 0);
          when '1'=> concat<=concat_minus & Instruction(6 downto 0);
			 when others=> concat<=concat_minus & Instruction(6 downto 0);
    end case;
	else concat <= concat_plus & instruction(6 downto 0);
	end if;
 end process;

with ExtOp select
	Ext_imm<= concat when '1', concat_plus & Instruction(6 downto 0) when others;
functionALU<= Instruction(2 downto 0);
sa<=Instruction(3);

end Behavioral;

