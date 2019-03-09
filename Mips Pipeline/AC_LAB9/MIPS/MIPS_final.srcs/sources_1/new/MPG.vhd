
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal cnt: STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";
signal Q1: STD_LOGIC;
signal Q2: STD_LOGIC;
signal Q3: STD_LOGIC;
begin
    process(clk)  --process pt counter
    begin
        if rising_edge(clk) then
            cnt<=cnt+1;
        end if;
    end process;
    process(clk)  --proces pt primul registru
    begin
        if rising_edge(clk) then
            if cnt="1111111111111111" then
                Q1<=btn;
            end if;
        end if;
    end process;
    process(clk)  --proces pt al doilea reg
    begin
        if rising_edge(clk) then
            Q2<=Q1;
        end if;
    end process;
    process(clk)  --proces pt al treilea reg
    begin
        if rising_edge(clk) then
            Q3<=Q2;
        end if;
    end process;
    en<=Q2 and (not Q3);
end Behavioral;
