/**
 * Step 1: Blinker
 * DONE
 */

`default_nettype none

`ifdef CMODA7
// Cmod A7-35T: 2 LEDs, 2 buttons, 12 MHz clock
module SOC (
    input        CLK,     // 12 MHz
    input  [1:0] BTN,     // BTN[0]=reset, BTN[1]=pause
    output [1:0] LEDS,    // LD1, LD2
    input        RXD,
    output       TXD
);
   // 25-bit counter: at 12 MHz, bit[23]~1.4 Hz, bit[24]~0.7 Hz
   reg [24:0] count = 0;
   always @(posedge CLK) begin
      if (BTN[0])      count <= 0;       // BTN0: reset
      else if (!BTN[1]) count <= count + 1; // BTN1: pause while held
   end
   assign LEDS = count[24:23];
   assign TXD  = 1'b0;
endmodule

`else
// Other boards: 5 LEDs, single reset button
module SOC (
    input  CLK,        // system clock
    input  RESET,      // reset button
    output [4:0] LEDS, // system LEDs
    input  RXD,        // UART receive
    output TXD         // UART transmit
);
   reg [4:0] count = 0;
   always @(posedge CLK) begin
      count <= count + 1;
   end
   assign LEDS = count;
   assign TXD  = 1'b0;
endmodule
`endif
