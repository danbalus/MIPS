
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity SSD is
    Port ( cat: out STD_LOGIC_VECTOR (6 downto 0);
           clk : in STD_LOGIC;
           D: in STD_LOGIC_VECTOR(15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal cnt:STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";
signal M1:  STD_LOGIC_VECTOR (3 downto 0);
begin
    --proces numarat:
    process(clk)
    begin
        if rising_edge(clk) then
            cnt<=cnt+1;
        end if;
    end process;
    --mux1:
    process(cnt(15 downto 14),D)
    begin
        case cnt(15 downto 14) is
        when "00"=> M1<=D(3 downto 0);
        when "01"=> M1<=D(7 downto 4);
        when "10"=> M1<=D(11 downto 8);
        when others=> M1<=D(15 downto 12);
        end case;
    end process;
    --mux2:
    process(cnt(15 downto 14))
    begin
        case cnt(15 downto 14) is
        when "00"=> an<="1110";
        when "01"=> an<="1101";
        when "10"=> an<="1011";
        when others=> an<="0111";
        end case;
    end process;
     with M1 SELect
      cat<= "1111001" when "0001",   --1
            "0100100" when "0010",   --2
            "0110000" when "0011",   --3
            "0011001" when "0100",   --4
            "0010010" when "0101",   --5
            "0000010" when "0110",   --6
            "1111000" when "0111",   --7
            "0000000" when "1000",   --8
            "0010000" when "1001",   --9
            "0001000" when "1010",   --A
            "0000011" when "1011",   --B
            "1000110" when "1100",   --C
            "0100001" when "1101",   --D
            "0000110" when "1110",   --E
            "0001110" when "1111",   --F
            "1000000" when others;
end Behavioral;
