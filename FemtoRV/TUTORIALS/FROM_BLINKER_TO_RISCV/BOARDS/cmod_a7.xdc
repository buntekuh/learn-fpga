# Clock pin
set_property PACKAGE_PIN L17 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]

# LEDs (LD1=A17, LD2=C16)
set_property PACKAGE_PIN A17 [get_ports {LEDS[0]}]
set_property PACKAGE_PIN C16 [get_ports {LEDS[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[1]}]

# Buttons (BTN0=A18, BTN1=B18, active high)
set_property PACKAGE_PIN A18 [get_ports {BTN[0]}]
set_property PACKAGE_PIN B18 [get_ports {BTN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[1]}]

# Clock constraints
create_clock -period 83.33 [get_ports CLK]

# UART
set_property PACKAGE_PIN J18 [get_ports TXD]
set_property PACKAGE_PIN J17 [get_ports RXD]
set_property IOSTANDARD LVCMOS33 [get_ports RXD]
set_property IOSTANDARD LVCMOS33 [get_ports TXD]

