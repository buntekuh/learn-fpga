library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Cmod A7-35T: 2 LEDs, 2 buttons, 12 MHz clock
-- LEDS(0) ~ 1.4 Hz, LEDS(1) ~ 0.7 Hz
entity SOC is
    port (
        CLK   : in  std_logic;
        RESET : in  std_logic;
        LEDS  : out std_logic_vector(1 downto 0);
        RXD   : in  std_logic;
        TXD   : out std_logic
    );
end entity SOC;

architecture rtl of SOC is
    -- 25-bit counter: at 12 MHz, bit 23 ~ 1.4 Hz, bit 24 ~ 0.7 Hz
    signal count : unsigned(24 downto 0) := (others => '0');

    -- iterate over pattern bytes in memory
    signal ref : unsigned(2 downto 0) := (others => '0');

    -- Memory array with initial values
    type MEM_TYPE is array (0 to 20) of std_logic_vector(4 downto 0);
    constant MEM : MEM_TYPE := (
        "00000", 
        "00001", 
        "00010", 
        "00100", 
        "01000", 
        "10000",
        others => "00000"
    );
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count <= (others => '0');
                ref <= (others => '0);
            else
                count <= count + 1;
                ref <= ref + 1;
                if (ref = 6) then
                    ref <= (others => '0'); -- Reset to 0
                end if;

            end if;
        end if;
    end process;

    LEDS <= std_logic_vector(count(24 downto 23));
    TXD  <= '0';

end architecture rtl;