library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Clock divider and reset generator.
--
-- SLOW = 0 : pass CLK through, hold resetn low for 2^16 cycles after power-on
--            so that block-RAM contents settle before the design starts.
-- SLOW > 0 : divide CLK by 2^SLOW (useful for single-stepping a design),
--            resetn is simply the complement of RESET.
--
-- Note: output port is named clk_out because VHDL is case-insensitive
-- and CLK (input) and clk (output) would collide.
entity Clockworks is
    generic (
        SLOW : integer := 0
    );
    port (
        CLK     : in  std_logic;   -- board clock
        RESET   : in  std_logic;   -- board reset (active high)
        clk_out : out std_logic;   -- divided (or passthrough) clock
        resetn  : out std_logic    -- active-low reset for the design
    );
end entity Clockworks;

architecture rtl of Clockworks is
begin

    -- Slow mode: divide clock by 2^SLOW, simple combinational reset
    slow_mode: if SLOW /= 0 generate
        signal slow_CLK : unsigned(SLOW downto 0) := (others => '0');
    begin
        process(CLK)
        begin
            if rising_edge(CLK) then
                slow_CLK <= slow_CLK + 1;
            end if;
        end process;

        clk_out <= slow_CLK(SLOW);
        resetn  <= not RESET;
    end generate slow_mode;

    -- Fast mode: pass clock through, timed power-on reset.
    -- reset_cnt counts up until all bits are 1 (resetn goes high).
    -- Asserting RESET restarts the counter, re-holding resetn low.
    fast_mode: if SLOW = 0 generate
        signal reset_cnt : unsigned(15 downto 0) := (others => '0');
        signal resetn_i  : std_logic;
    begin
        clk_out  <= CLK;
        resetn_i <= and reset_cnt;  -- '1' when all bits are 1, same as Verilog &reset_cnt
        resetn   <= resetn_i;

        process(CLK, RESET)
        begin
            if RESET = '1' then
                reset_cnt <= (others => '0');
            elsif rising_edge(CLK) then
                if resetn_i = '0' then
                    reset_cnt <= reset_cnt + 1;
                end if;
            end if;
        end process;
    end generate fast_mode;

end architecture rtl;
