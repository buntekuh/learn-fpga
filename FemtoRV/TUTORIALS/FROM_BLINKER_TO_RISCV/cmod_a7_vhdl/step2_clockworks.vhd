library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Cmod A7-35T: 5 breadboard LEDs on DIP pins 26-30 (LEDS[2..6])
-- SLOW=22 advances one pattern every ~0.35 s at 12 MHz; use a small value in simulation.
entity SOC is
    generic (
        SLOW : integer := 22
    );
    port (
        CLK   : in  std_logic;
        RESET : in  std_logic;
        LEDS  : out std_logic_vector(6 downto 0);
        RXD   : in  std_logic;
        TXD   : out std_logic
    );
end entity SOC;

architecture rtl of SOC is
    signal slow_clk    : std_logic;
    signal resetn : std_logic;
    signal ref    : unsigned(2 downto 0) := (others => '0');

    type MEM_TYPE is array (0 to 20) of std_logic_vector(4 downto 0);
    constant MEM : MEM_TYPE := (
        "00000",
        "00100",
        "01110",
        "11111",
        "00100",
        "00100",
        "01110",
        others => "00000"
    );
begin

    CW: entity work.Clockworks
        generic map(SLOW => SLOW)
        port map(
            CLK     => CLK,
            RESET   => RESET,
            clk_out => slow_clk,
            resetn  => resetn
        );

    process(slow_clk, resetn)
    begin
        if resetn = '0' then
            ref <= (others => '0');
        elsif rising_edge(slow_clk) then
            if ref = 6 then
                ref <= (others => '0');
            else
                ref <= ref + 1;
            end if;
        end if;
    end process;

    LEDS(1 downto 0) <= "00";
    LEDS(6 downto 2) <= MEM(to_integer(ref));
    TXD              <= '0';

end architecture rtl;
