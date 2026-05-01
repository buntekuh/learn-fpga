# Clock pin
set_property PACKAGE_PIN L17 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -period 83.33 [get_ports CLK]

# LEDs
# LEDS[0] and LEDS[1] are the onboard LEDs (LD1, LD2)
# LEDS[2..7] are breadboard LEDs on DIP pins 26-31 (via 1k resistor to GND)
set_property PACKAGE_PIN A17 [get_ports {LEDS[0]}]
set_property PACKAGE_PIN C16 [get_ports {LEDS[1]}]
set_property PACKAGE_PIN R3  [get_ports {LEDS[2]}]
set_property PACKAGE_PIN T3  [get_ports {LEDS[3]}]
set_property PACKAGE_PIN R2  [get_ports {LEDS[4]}]
set_property PACKAGE_PIN T1  [get_ports {LEDS[5]}]
set_property PACKAGE_PIN T2  [get_ports {LEDS[6]}]
set_property PACKAGE_PIN U1  [get_ports {LEDS[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[7]}]

# Reset button (BTN0, active high)
set_property PACKAGE_PIN A18 [get_ports RESET]
set_property IOSTANDARD LVCMOS33 [get_ports RESET]

# UART
set_property PACKAGE_PIN J18 [get_ports TXD]
set_property PACKAGE_PIN J17 [get_ports RXD]
set_property IOSTANDARD LVCMOS33 [get_ports RXD]
set_property IOSTANDARD LVCMOS33 [get_ports TXD]
