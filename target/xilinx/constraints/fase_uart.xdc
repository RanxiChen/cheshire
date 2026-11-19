# UART RX is asynchronous to the 50 MHz SoC clock. Only cut the first stage.
set fase_rx_first [get_pins -quiet -hier -filter {NAME =~ *fase_rx_meta_q_reg/D}]
set_false_path -from [get_ports uart_rx_i] -to $fase_rx_first
