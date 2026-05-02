library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Cmod A7-35T: 5 breadboard LEDs on DIP pins 26-30 (LEDS[2..6])
-- counting in binary. At 12 MHz, bit[20] ~ 11 Hz (fastest),
-- bit[24] ~ 0.7 Hz (slowest) — full 0-31 cycle takes ~2.8 seconds.
entity SOC is
    port (
        CLK   : in  std_logic;
        RESET : in  std_logic;
        LEDS  : out std_logic_vector(6 downto 0);
        RXD   : in  std_logic;
        TXD   : out std_logic
    );
end entity SOC;

architecture rtl of SOC is
    signal count : unsigned(26 downto 0) := (others => '0');
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count <= (others => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    LEDS(1 downto 0) <= "00";                              -- onboard LEDs off
    LEDS(6 downto 2) <= std_logic_vector(count(26 downto 22)); -- breadboard LEDs
    TXD <= '0';

end architecture rtl;
