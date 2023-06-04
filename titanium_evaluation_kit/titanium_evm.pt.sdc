
# Efinity Interface Designer SDC
# Version: 2022.2.322.5.7
# Date: 2023-06-04 19:57

# Copyright (C) 2017 - 2022 Efinix Inc. All rights reserved.

# Device: Ti60F225
# Project: titanium_evm
# Timing Model: C4 (final)

# PLL Constraints
#################
create_clock -waveform {0.3333 4.3333} -period 8.0000 rgmii_rx_pll_clock
create_clock -period 10.0000 pll_inst1_CLKOUT0
create_clock -period 8.3333 clock_120mhz

# GPIO Constraints
####################
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {uart_rx}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {uart_rx}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {uart_tx}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {uart_tx}]

# HSIO GPIO Constraints
#########################
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~121~1}] -max 0.414 [get_ports {rgmii_rx_and_ctl_LO[0] rgmii_rx_and_ctl_HI[0]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~121~1}] -min 0.276 [get_ports {rgmii_rx_and_ctl_LO[0] rgmii_rx_and_ctl_HI[0]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~120~1}] -max 0.414 [get_ports {rgmii_rx_and_ctl_LO[1] rgmii_rx_and_ctl_HI[1]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~120~1}] -min 0.276 [get_ports {rgmii_rx_and_ctl_LO[1] rgmii_rx_and_ctl_HI[1]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~82~1}] -max 0.414 [get_ports {rgmii_rx_and_ctl_LO[2] rgmii_rx_and_ctl_HI[2]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~82~1}] -min 0.276 [get_ports {rgmii_rx_and_ctl_LO[2] rgmii_rx_and_ctl_HI[2]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~81~1}] -max 0.414 [get_ports {rgmii_rx_and_ctl_LO[3] rgmii_rx_and_ctl_HI[3]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~81~1}] -min 0.276 [get_ports {rgmii_rx_and_ctl_LO[3] rgmii_rx_and_ctl_HI[3]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~93~1}] -max 0.414 [get_ports {rgmii_rx_and_ctl_LO[4] rgmii_rx_and_ctl_HI[4]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~93~1}] -min 0.276 [get_ports {rgmii_rx_and_ctl_LO[4] rgmii_rx_and_ctl_HI[4]}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_clock}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_clock}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_data_io_in}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_data_io_in}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_data_io_out}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_data_io_out}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_dir_is_out_when_1}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_dir_is_out_when_1}]

# Clockout Interface
######################
# rgmii_rx_and_ctl[0] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~121~1}]
# rgmii_rx_and_ctl[1] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~120~1}]
# rgmii_rx_and_ctl[2] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~82~1}]
# rgmii_rx_and_ctl[3] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~81~1}]
# rgmii_rx_and_ctl[4] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~93~1}]

set_clock_groups -exclusive -group { rgmii_rx_pll_clock }