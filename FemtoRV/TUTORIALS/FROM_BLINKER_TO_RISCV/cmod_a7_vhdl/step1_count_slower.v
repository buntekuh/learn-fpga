/**
 * Step 1: Blinker — Cmod A7-35T variant
 *
 * The Cmod A7 has 2 LEDs and 2 buttons (vs 5 LEDs / 1 button on other boards)
 * and runs at 12 MHz. A 25-bit counter gives visible blink rates:
 *   bit[23] ~ 1.4 Hz, bit[24] ~ 0.7 Hz
 */

`default_nettype none

module SOC (
    input        CLK,     // 12 MHz
    input  [1:0] BTN,     // BTN[0]=reset, BTN[1]=pause
    output [1:0] LEDS,    // LD1, LD2
    input        RXD,
    output       TXD
);
   reg [24:0] count = 0;
   always @(posedge CLK) begin
      if (BTN[0])       count <= 0;
      else if (!BTN[1]) count <= count + 1;
   end
   assign LEDS = count[24:23];
   assign TXD  = 1'b0;
endmodule
