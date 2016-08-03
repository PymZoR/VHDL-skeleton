library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FreqDivider is
    generic (DIVIDER : integer := 2); -- Minimum is 2
    port (
        clk    : in std_logic;
        reset  : in std_logic;
        clkOut : out std_logic
    );
end entity;

architecture Behavioral of FreqDivider is
    signal s_clkOut : std_logic;

begin
    div_proc : process (clk, reset)
        variable count : integer range 0 to DIVIDER-1;
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                s_clkOut <= '0';
                count := 0;
            else
                if (count = DIVIDER/2 - 1) then
                    s_clkOut <= not s_clkOut;
                    count := count + 1;
                elsif (count = DIVIDER-1) then
                    s_clkOut <= not s_clkOut;
                    count := 0;
                else
                    count := count + 1;
                end if;
            end if;
        end if;
    end process;

    clkout <= s_clkout;
end Behavioral;
