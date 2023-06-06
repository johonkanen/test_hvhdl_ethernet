
# Efinity Interface Designer SDC
# Version: 2022.2.322.5.7
# Date: 2023-06-06 18:31

# Copyright (C) 2017 - 2022 Efinix Inc. All rights reserved.

# Device: Ti60F225
# Project: titanium_custom_board
# Timing Model: C4 (final)

# PLL Constraints
#################
create_clock -period 8.0000 pll_inst3_CLKOUT0
create_clock -waveform {1.2727 5.2727} -period 8.0000 enet_tx_clock
create_clock -period 8.0000 outclock
create_clock -waveform {2.3333 6.3333} -period 8.0000 rgmii_rx_pll_clock
create_clock -period 10.0000 pll_inst1_CLKOUT0
create_clock -period 8.3333 clock_120mhz

# GPIO Constraints
####################
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~4~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_HI[0]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~4~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_HI[0]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~4~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_LO[0]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~4~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_LO[0]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~10~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_HI[1]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~10~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_HI[1]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~10~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_LO[1]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~10~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_LO[1]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~6~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_HI[2]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~6~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_HI[2]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~6~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_LO[2]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~6~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_LO[2]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~18~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_HI[3]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~18~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_HI[3]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~18~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_LO[3]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~18~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_LO[3]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~16~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_HI[4]}]
set_input_delay -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~16~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_HI[4]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~16~322}] -max 0.691 [get_ports {rgmii_rx_and_ctl_LO[4]}]
set_input_delay -clock_fall -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~16~322}] -min 0.461 [get_ports {rgmii_rx_and_ctl_LO[4]}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {rgmii_rx_input_clock}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {rgmii_rx_input_clock}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {uart_rx}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {uart_rx}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_clock}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_clock}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~215~322}] -max 0.079 [get_ports {rgmii_tx_and_ctl_LO[0] rgmii_tx_and_ctl_HI[0]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~215~322}] -min -0.045 [get_ports {rgmii_tx_and_ctl_LO[0] rgmii_tx_and_ctl_HI[0]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~198~322}] -max 0.079 [get_ports {rgmii_tx_and_ctl_LO[1] rgmii_tx_and_ctl_HI[1]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~198~322}] -min -0.045 [get_ports {rgmii_tx_and_ctl_LO[1] rgmii_tx_and_ctl_HI[1]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~209~322}] -max 0.079 [get_ports {rgmii_tx_and_ctl_LO[2] rgmii_tx_and_ctl_HI[2]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~209~322}] -min -0.045 [get_ports {rgmii_tx_and_ctl_LO[2] rgmii_tx_and_ctl_HI[2]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~203~322}] -max 0.079 [get_ports {rgmii_tx_and_ctl_LO[3] rgmii_tx_and_ctl_HI[3]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~203~322}] -min -0.045 [get_ports {rgmii_tx_and_ctl_LO[3] rgmii_tx_and_ctl_HI[3]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~213~322}] -max 0.079 [get_ports {rgmii_tx_and_ctl_LO[4] rgmii_tx_and_ctl_HI[4]}]
set_output_delay -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~213~322}] -min -0.045 [get_ports {rgmii_tx_and_ctl_LO[4] rgmii_tx_and_ctl_HI[4]}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {uart_tx}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {uart_tx}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_data_io_in}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_data_io_in}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_data_io_out}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_data_io_out}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {mdio_dir_is_out_when_1}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {mdio_dir_is_out_when_1}]

# HSIO GPIO Constraints
#########################

# Clockout Interface
######################
# rgmii_rx_and_ctl[0] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~4~322}]
# rgmii_rx_and_ctl[1] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~10~322}]
# rgmii_rx_and_ctl[2] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~6~322}]
# rgmii_rx_and_ctl[3] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~18~322}]
# rgmii_rx_and_ctl[4] -clock rgmii_rx_pll_clock -reference_pin [get_ports {rgmii_rx_pll_clock~CLKOUT~16~322}]
# rgmii_tx_and_ctl[0] -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~215~322}]
# rgmii_tx_and_ctl[1] -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~198~322}]
# rgmii_tx_and_ctl[2] -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~209~322}]
# rgmii_tx_and_ctl[3] -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~203~322}]
# rgmii_tx_and_ctl[4] -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~213~322}]
# rgmii_tx_clock -clock enet_tx_clock -reference_pin [get_ports {enet_tx_clock~CLKOUT~217~322}]
set_clock_groups -exclusive -group { rgmii_rx_pll_clock }
