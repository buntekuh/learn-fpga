library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Cmod A7-35T: 2 LEDs, 2 buttons, 12 MHz clock
-- LEDS(0) ~ 1.4 Hz, LEDS(1) ~ 0.7 Hz
entity SOC is
    port (
        CLK  : in  std_logic;
        BTN  : in  std_logic_vector(1 downto 0);  -- BTN(0)=reset, BTN(1)=pause
        LEDS : out std_logic_vector(1 downto 0);
        RXD  : in  std_logic;
        TXD  : out std_logic
    );
end entity SOC;

architecture rtl of SOC is
    -- 25-bit counter: at 12 MHz, bit 23 ~ 1.4 Hz, bit 24 ~ 0.7 Hz
    signal count : unsigned(24 downto 0) := (others => '0');
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if BTN(0) = '1' then
                count <= (others => '0');     -- BTN0: reset
            elsif BTN(1) = '0' then
                count <= count + 1;           -- BTN1: pause while held
            end if;
        end if;
    end process;

    LEDS <= std_logic_vector(count(24 downto 23));
    TXD  <= '0';

end architecture rtl;
