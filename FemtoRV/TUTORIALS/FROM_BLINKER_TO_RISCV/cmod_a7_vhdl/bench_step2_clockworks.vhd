library ieee;
use ieee.std_logic_1164.all;

entity bench is
end entity bench;

architecture sim of bench is

    signal CLK   : std_logic := '0';
    signal RESET : std_logic := '0';
    signal LEDS  : std_logic_vector(6 downto 0);
    signal RXD   : std_logic := '0';
    signal TXD   : std_logic;

    signal prev_LEDS : std_logic_vector(6 downto 0) := (others => '0');

begin
    -- SLOW=3: clk_out period = 2^3 * 83 ns ~ 665 ns, all 6 patterns in ~4 us
    uut: entity work.SOC
        generic map(SLOW => 3)
        port map(
            CLK   => CLK,
            RESET => RESET,
            LEDS  => LEDS,
            RXD   => RXD,
            TXD   => TXD
        );

    -- 12 MHz clock: period = 83.33 ns
    CLK <= not CLK after 41 ns;

    process(CLK)
    begin
        if rising_edge(CLK) then
            if LEDS /= prev_LEDS then
                report "LEDS(6:2) = " & to_string(LEDS(6 downto 2));
            end if;
            prev_LEDS <= LEDS;
        end if;
    end process;

end architecture sim;
