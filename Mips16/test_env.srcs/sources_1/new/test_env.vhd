----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:25:35 03/23/2015 
-- Design Name: 
-- Module Name:    test_env - Behavioral 
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

entity test_env is
	Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0);
           dp : out  STD_LOGIC);
end test_env;

architecture Behavioral of test_env is

--Declaram componenta monoPulse
component MPG is
	port(	btn : in std_logic;
			clk : in std_logic;
			enable : out std_logic);
end component;

component SSG is
	Port ( digit : in  STD_LOGIC_VECTOR (15 downto 0);
          an : out  STD_LOGIC_VECTOR (3 downto 0);
          cat : out  STD_LOGIC_VECTOR (6 downto 0);
			 clk : in std_logic);
end component;

component ROM is
	Port(A : in std_logic_vector(7 downto 0);
		  D0 : out std_logic_vector(15 downto 0));
end component;


component IFetch is
    Port ( clk : in  STD_LOGIC;
	        reset: in STD_LOGIC;
			  enablePC :in STD_LOGIC;
	        adr_branch : in  STD_LOGIC_VECTOR (15 downto 0);
			  adr_jump : in  STD_LOGIC_VECTOR (15 downto 0);
			  jump: in STD_LOGIC ;
			  PCSrc: in STD_LOGIC;
			  instr : out STD_LOGIC_VECTOR (15 downto 0);
			  adr_next : out STD_LOGIC_VECTOR
			  );
end component;

component ID is
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
end component;

component UC is
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
end component;

component EX is
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
end component;

component MemoryData is
	Port ( MemWrite : in  STD_LOGIC;
			 clk : in std_Logic;
          ALURes : in  STD_LOGIC_VECTOR (15 downto 0);
          RD2 : in  STD_LOGIC_VECTOR (15 downto 0);
          MemData : out  STD_LOGIC_VECTOR (15 downto 0);
			 enable : in std_logic;
          ALUResOut : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

signal count_int: STD_LOGIC_VECTOR(7 downto 0);
signal enable: STD_LOGIC;
signal dig: STD_LOGIC_VECTOR(15 downto 0);
signal rd1_o: STD_LOGIC_VECTOR(15 downto 0);
signal rd2_o: STD_LOGIC_VECTOR(15 downto 0);
signal enable2: STD_LOGIC;
signal sum_o: STD_LOGIC_VECTOR(15 downto 0);
signal shl_o: STD_LOGIC_VECTOR(15 downto 0);
signal do_o: STD_LOGIC_VECTOR(15 downto 0);
signal instr_o: STD_LOGIC_VECTOR(15 downto 0);
signal pc_o: STD_LOGIC_VECTOR(15 downto 0);
signal afis: STD_LOGIC_VECTOR(15 downto 0 );
signal jumpu: std_logic:='0';

------------------------------semnale ID
--signal RegDst: STD_LOGIC;
signal WDat: STD_LOGIC_VECTOR(15 downto 0);
--signal Ext_op: STD_LOGIC;
signal RD1: STD_LOGIC_VECTOR(15 downto 0);
signal RD2: STD_LOGIC_VECTOR(15 downto 0);
signal Ext_imm: STD_LOGIC_VECTOR(15 downto 0);
signal functionALU: STD_LOGIC_VECTOR(2 downto 0);
signal sa: STD_LOGIC;

-------------------------------semnale UC
signal reg_dst: STD_LOGIC;
signal branch: STD_LOGIC;
signal jump: STD_LOGIC;
signal mem_read: STD_LOGIC;
signal mem_toReg: STD_LOGIC;
signal alu_op: STD_LOGIC_VECTOR(2 downto 0);
signal mem_wr: STD_LOGIC;
signal alu_src: STD_LOGIC;
signal reg_wr: STD_LOGIC;
signal ext_oper: STD_LOGIC;
signal branch_address : std_logic_vector(15 downto 0); --adresa de branch
signal jump_addr : std_logic_vector(15 downto 0); -- adresa de jump

----------------------------semnal EX
signal zero: STD_LOGIC;
signal ALURes : std_logic_vector (15 downto 0); -- iesirea din ALU
---------------------------semnale memory data
signal MemData : std_logic_vector (15 downto 0);
signal ALUResOut : std_logic_vector (15 downto 0);
------------------------------semnale intrare
signal output_sel :std_logic_vector(2 downto 0);
signal selector :  std_logic;
signal BranchSignal : std_logic;

--signal sum: STD_LOGIC_VECTOR(15 downto 0);
begin

--atribuiri
output_sel(2 downto 0)<= sw(7 downto 5);
selector <= sw(0);

----------counter
--	process (clk, enable) 
--	begin
--		if clk='1' and clk'event then
--         if enable='1' then   
--            count_int <= count_int + 1;
--         end if;
--		end if;
--	end process;

----------instantierea MPG--------------------------
	MPG1: MPG port map (btn(1), clk, enable); ---pentru reset
	
---------instantiere MPG2---------------------------
	MPG2: MPG port map(btn(0), clk, enable2);  ---pentru adunare

-------------mux pt iesirea instr_fetch-------------
--	process(sw(7))
--	begin
--		if(sw(7) = '0') then
--			afis <= instr_o;
--		end if;
--		if(sw(7) = '1')then 
--			afis <= pc_o;
--		end if;
--	end process;

-----------instantiere instr_fetch--------------------
I_F: IFetch port map (clk,enable, enable2,branch_address,jump_addr,jump, BranchSignal,instr_o , pc_o);

--------------------------instanta UC----------------
UC1:UC port map(instr_o(15 downto 13),reg_dst,branch,jump,mem_toReg, alu_op,mem_wr, alu_src, reg_wr,ext_oper);

----------------------------instanta ID---------------
ID1:ID port map(clk,instr_o,reg_dst,Wdat,ext_oper,enable2,RD1,RD2,Ext_imm,functionALU,sa);

------------------------------executia----------------
executia : EX port map ( pc_o, RD1, RD2, Ext_imm, sa, functionALU, alu_src, alu_op, branch_address, zero, ALURes );

-------------------------------memory data------------
Memory : MemoryData port map (mem_wr, clk, ALURes, RD2, MemData ,enable2, ALUResOut);

----------------------jump address
jump_addr(12 downto 0) <= instr_o(12 downto 0);

---------------------poarta si pentru branch ---------
BranchSignal <= branch and zero;

------------------WB-----------------------------------
WriteBackMUX : process (mem_toReg, ALUResOut, MemData)
	begin 
		case mem_toReg is
			when '0' => WDat <= ALUResOut;
			when others => WDat <= MemData;
		end case;
	end process;

------------------------MUX2-switch-------------------
	process(sw(7 downto 5))
	  begin
		if(sw(7 downto 5) = "000") then
			afis <= instr_o;-- instr
		end if;
		if(sw(7 downto 5) = "001")then 
			afis <= pc_o; --pc <-instructiunea urmatoare
		end if;
		if(sw(7 downto 5) = "010")then 
			afis <=RD1; --prima data 
		end if;
		if(sw(7 downto 5) = "011")then 
			afis <=RD2; -- adoua data
		end if;
		if(sw(7 downto 5) = "100")then 
			afis <=Ext_imm; --extindere imediat
		end if;
		if(sw(7 downto 5) = "101")then 
			afis <=ALURes ; --rezultatul din alu
		end if;
		if(sw(7 downto 5) = "110")then 
			afis <=MemData; --ce iese din memoria de date
		end if;
		if(sw(7 downto 5) = "111")then 
			afis <=Wdat; --write data
		end if;
	end process;
-----------instantierea SSG------------------------
	SSG1: SSG port map (afis, an, cat, clk );
-----------------------MUX led---------------------
	process(sw(0))
	   begin
	     if(sw(0)= '0') then
	            led(0)<=reg_dst;
	            led(1)<=branch;
	            led(2)<=jump;
	            led(3)<=mem_toReg;
	            led(4)<=mem_wr;
	            led(5)<=alu_src;
	            led(6)<=reg_wr;
	            led(7)<=ext_oper;
      end if;
      if(sw(0)='1') then 
               led(2 downto 0)<=alu_op(2 downto 0);
					led(7 downto 3)<="11111";
      end if;
   end process;
---------------------------------------------------
dp <= '1';
end Behavioral;
