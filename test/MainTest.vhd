library ieee;
library std;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MainTest is
    --
end MainTest;

architecture Behavioral of MainTest is
    component Main
        port (
            clk   : in std_logic;
            reset : in std_logic;
            led   : out std_logic_vector (1 downto 0)
        );
    end component;

    constant s_clkPeriod: time := 20 ns;

    signal s_clk   : std_logic;
    signal s_reset : std_logic;
    signal s_led   : std_logic_vector (1 downto 0);

begin
    -- UUT declaration --
    uut : Main port map (
        clk    => s_clk,
        reset  => s_reset,
        led    => s_led
    );

    -- Clock process --
    s_clk_proc : process begin
        s_clk <= '0';
		wait for s_clkPeriod/2;
	    s_clk <= '1';
		wait for s_clkPeriod/2;
    end process s_clk_proc;

    -- Stimulus process --
    stim_proc : process begin
        s_reset <= '1';
        wait for s_clkPeriod;
        s_reset <= '0';
        wait;
    end process stim_proc;
end architecture Behavioral;
