----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:50:28 03/31/2015 
-- Design Name: 
-- Module Name:    UC - Behavioral 
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

entity UC is
	Port ( instr : in  STD_LOGIC_VECTOR (2 downto 0);
			 reg_dst : out  STD_LOGIC;
			 branch : out  STD_LOGIC;
			 jump: out STD_LOGIC;
			 --mem_read : out  STD_LOGIC;
			 mem_toReg : out  STD_LOGIC;
			 alu_op : out  STD_LOGIC_VECTOR(2 downto 0);
			 mem_wr : out  STD_LOGIC;
			 alu_src : out  STD_LOGIC;
			 reg_wr : out  STD_LOGIC;
			 ext_op :out STD_LOGIC
		  );
end UC;

architecture Behavioral of UC is
begin
process(instr)
	begin
		case (instr) is 
			 when "000" =>--tip R
			      reg_dst<='1';--in writeAdress=rd
				   alu_src<='0';--In alu<=readData2
				   mem_toReg<='0';--writeData<=rezAlu
				   reg_wr<='1'; --scriem rez in reg
				   -- mem_read<='0'; --nu citim din mem
				   mem_wr<='0'; --nu scriem in mem
				   branch<='0';
				   ext_op<='0';
				   jump<='0';
				   alu_op<="000";--ALU control=function
				  
			when "001" =>--addi
					reg_dst<='0';--Write Adress=rt
					alu_src<='1';--sa se adune cu imediatul
					mem_toReg <='0';--rez alu nu din mem
					reg_wr<='1'; --scriem rez in registru
					--mem_read<='0';
					mem_wr<='0'; 
					branch<='0';
					ext_op<='1';
				   jump<='0';
					alu_op<="001";--se efectueaza adunarea
					
			when "010" =>--lw
					reg_dst<='0';--reg destinatie este rt 
					alu_src<='1'; --ext cu semn
					mem_toReg <='1'; --citeste cuvantul din memorie
					reg_wr<='1';--scriem in reg rt
					--mem_read<='1';--citim din mem
					mem_wr<='0'; 
					branch<='0';
					ext_op<='1';
				   jump<='0';
					alu_op<="001";--efectial adunare
					
		  when "011" =>reg_dst<='X'; --sw
					alu_src<='1';--ext cu semn
					mem_toReg <='X';--nu dorim sa scriem in regFile
					reg_wr<='0'; --nu scriem in blocul de reg
					--mem_read<='0'; 
					mem_wr<='1'; --scriem in memorie
					branch<='0';
					ext_op<='1';
				   jump<='0';
					alu_op<="001";
					
		when "100" =>reg_dst<='X'; --beq
					alu_src<='0';--rt
					mem_toReg <='X';--nu dorim sa scriem in regFile
					reg_wr<='0'; --nu scriem in blocul de reg
					--mem_read<='0'; 
					mem_wr<='0';
					branch<='1';
					ext_op<='1';
				   jump<='0';
					alu_op<="010";--facem scaderea celor2 reg pt a verifica ZF
					
		when "110" =>reg_dst<='0'; --xori
					alu_src<='1';--imm
					mem_toReg <='0';--rez alu
					reg_wr<='1'; --scriem in blocul de reg
					--mem_read<='0'; 
					mem_wr<='0';
					branch<='0';
					ext_op<='1';
				   jump<='0';
					alu_op<="110";--xor de tip R
					
		when "101" =>reg_dst<='0'; --ori
					alu_src<='1';--imm
					mem_toReg <='0';--rez alu
					reg_wr<='1'; --scriem in blocul de reg
					--mem_read<='0'; 
					mem_wr<='0';
					branch<='0';
					ext_op<='1';
					jump<='0';
					alu_op<="101";--or de tip R
					
		when "111" =>reg_dst<='X'; --jump
					alu_src<='X';--imm
					mem_toReg <='X';--rez alu
					reg_wr<='0'; --scriem in blocul de reg
					--mem_read<='0'; 
					mem_wr<='0';
					branch<='0';
					ext_op<='0';
					jump<='1';
					alu_op<="111";--or de tip R
					
	 when others =>
				  reg_dst<='X';--in writeAdress=rd
				  alu_src<='X';--In alu<=readData2
				  mem_toReg<='X';--writeData<=rezAlu
				  reg_wr<='0'; --scriem rez in reg
				  -- mem_read<='0'; --nu citim din mem
				  mem_wr<='0'; --nu scriem in mem
				  branch<='0';
				  ext_op<='0';
				  jump<='0';
				  alu_op<="000";--ALU control=function
	end case;
end process;

end Behavioral;

