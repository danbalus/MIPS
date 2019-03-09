
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
Port	(    Instr:in std_logic_vector(2 downto 0);
			 RegDst: out std_logic;
			 ExtOp: out std_logic;
			 ALUSrc: out std_logic;
			 Branch: out std_logic;
			 Jump: out std_logic;
			 ALUOp: out std_logic_vector(2 downto 0);
			 MemWrite: out std_logic;
			 MemtoReg: out std_logic;
			 RegWrite: out std_logic);

end UC;
architecture Behavioral of UC is
begin
    process(Instr)
    begin
        regDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        ALUOp <= "000";
        MemWrite <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';

        case (Instr) is
         -- R TYPE
        when "000" => 
            RegDst <= '1'; 
            RegWrite <= '1';
        
         --I TYPR
         when "001" => --ADDI
           -- ExtOp <= '1';
            RegWrite <= '1';
            ALUSrc <= '1';
            ALUOp <= "001";
        
        when "010" => --LW
           -- ExtOp <= '1';  --sau 0?
            RegWrite <= '1';
            ALUSrc <= '1';
            MemtoReg <= '1';
            ALUOp <= "010";
        
        when "011" => --SW
          --  ExtOp <= '1';   --sau 0?
            ALUSrc <= '1';
            MemWrite <= '1';
            MemtoReg <= '1';   
            ALUOp <= "011"; 
        
        when "100" => --BEQ
            MemtoReg <= '1';  --?
            -- ExtOp <= '1';
            Branch<= '1';
            ALUOp <= "100";
 
         when "101" => --ORI
            -- ExtOp<='1';
             ALUSrc<='1';
             RegWrite <= '1';
             ALUOp <= "101";
         
         when "110" => --XORI
              ExtOp<='1';
              ALUSrc<='1';
              RegWrite <= '1';
              ALUOp <= "110";
                    
            --JUMP
         when "111" =>
              ALUOp <= "111";
              Jump <= '1';
    end case;
end process;

end Behavioral;
