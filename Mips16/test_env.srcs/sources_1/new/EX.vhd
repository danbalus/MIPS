----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:46:46 04/06/2015 
-- Design Name: 
-- Module Name:    EX - Behavioral 
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

entity EX is
	Port ( next_instruction : in  STD_LOGIC_VECTOR (15 downto 0);
          rd1 : in  STD_LOGIC_VECTOR (15 downto 0);
          rd2 : in  STD_LOGIC_VECTOR (15 downto 0);
          ext_imm : in  STD_LOGIC_VECTOR (15 downto 0);
          sa : in  STD_LOGIC;
          func : in  STD_LOGIC_VECTOR (2 downto 0);
          ALUSrc : in  STD_LOGIC;
          ALUOp : in  STD_LOGIC_vector (2 downto 0);
          branch_address : out  STD_LOGIC_VECTOR (15 downto 0);
          zero : out  STD_LOGIC;
          ALURes : out  STD_LOGIC_VECTOR (15 downto 0));
end EX;

architecture Behavioral of EX is

--declaratii semnale
signal  iesireMux  : std_logic_vector (15 downto 0);
signal ALUcontrol : std_logic_vector (2 downto 0);

begin
	branch_address <= ext_imm + next_instruction;
	
-------------Proces mux 
   mux: process(ALUSrc, rd2, ext_imm)
	begin
		case ALUSrc is
			when '0' => iesireMux <= rd2;
			when others => iesireMux <= ext_imm;
		end case;
	end process;	
-------------Proces Alu control
   ALUctrl : process(ALUOp, func)
	begin
		case ALUOp is
			when "000" => 
						case func is
							when "001" => ALUcontrol <= "000"; -- ADUNARE
							when "010" => ALUcontrol <= "001"; -- SCADERE
							when "011" => ALUcontrol <= "010"; -- SLL
							when "100" => ALUcontrol <= "011"; -- SRL
							when "101" => ALUcontrol <= "100"; -- AND
							when "110" => ALUcontrol <= "101"; -- OR
							when "111" => ALUcontrol <= "110"; -- XOR
							when others => ALUcontrol <= "000";
						end case;
			when "001" => ALUcontrol <= "000"; -- ADUNARE (cu imediat, dar tot adunare) ADDI
			when "010" => ALUcontrol <= "000"; -- ADUNARE (pentru calculul adresei de citire a cuvantului) LW
			when "011" => ALUcontrol <= "000"; -- ADUNARE (pentru calculul adresei de scriere a cuvantului) SW
			when "100" => ALUcontrol <= "001"; -- SCADERE (pentru identificarea lui ZERO in caz de branch) BEQ
			when "110" => ALUcontrol <= "101"; -- OR (cu imediat) ORI
			--when "110" => ALUcontrol <= "010"; -- SCADERE (pentru a identifica LIPSA lui ZERO ) BNE
			when others => ALUcontrol <="001"; -- SCADERE (pentru a identifica ZERO) JUMP
		end case;
	end process;
-----------Proces Alu 
	ALU : process (ALUcontrol, iesireMux, rd1, sa)
	begin
		case ALUcontrol is
			when "000" => ALUres <= (rd1 + iesireMux); -- ADUNARE
			when "001" => ALUres <= (rd1 - iesireMux); -- SCADERE
			when "010" => 
					if ( sa = '1') then				  -- SLL
						ALUres(15 downto 1) <= rd1 (14 downto 0);
						ALUres(0) <= '0';
					else
						ALUres <= rd1;
					end if;
			when "011" =>
					if ( sa = '1') then				  -- SRL
						ALUres(14 downto 0) <= rd1 (15 downto 1);
						ALUres(15) <= '0';
					else
						ALUres <= rd1;
					end if;
			when "100" => ALUres <= rd1 and iesireMux; -- AND
			when "101" => ALUres <= rd1 or iesireMux; -- OR
			when "110" => ALUres <= rd1 xor  iesireMux; -- XOR
			when others => ALUres <= x"0000";
			end case;
	end process;
--------Proces zero
   zeroSignal: process (rd1, iesireMux)
    	begin
		   if (rd1 - iesireMux) = x"0000" then
			    zero <= '1';
		   else 
			    zero <= '0';
		end if;
	end process;
end Behavioral;

