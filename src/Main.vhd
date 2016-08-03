library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Main IS
    port (
        clk   : in std_logic; -- 50MHz
        reset : in std_logic;
        led   : out std_logic_vector (1 downto 0)
    );
end entity;

architecture Behavioral of Main IS
    component FreqDivider
        generic (DIVIDER : integer);

        port (
            clk    : in std_logic;
            reset  : in std_logic;
            clkOut : out std_logic
        );
    end component;

    signal s_clk2 : std_logic; -- Hz
    signal s_clk1 : std_logic; -- Hz

begin
    divider25M : FreqDivider
        generic map (DIVIDER => 25000000)
        port map (clk => clk, reset => reset, clkOut => s_clk2);

    divider50M : FreqDivider
        generic map (DIVIDER => 50000000)
        port map (clk => clk, reset => reset, clkOut => s_clk1);

    led(0) <= s_clk2;
    led(1) <= s_clk1;
end Behavioral;
