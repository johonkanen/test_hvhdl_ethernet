library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.ethernet_rx_ddio_pkg.all;

entity ethernet_rx_ddio is
    port (
        clk : in std_logic;
        ethernet_rx_ddio_fpga_in : in ethernet_rx_ddio_FPGA_input_group;
        ethernet_ddio_out : out ethernet_rx_ddio_data_output_group
    );
end entity ethernet_rx_ddio;


architecture rtl of ethernet_rx_ddio is

    alias self is ethernet_rx_ddio_fpga_in;

begin

    ethernet_ddio_out <= (rx_ctl => (self.fpga_IO_HI(4), self.fpga_IO_LO(4)), 
                          ethernet_rx_byte => 
                              (self.fpga_IO_LO(0) ,
                                self.fpga_IO_LO(1),
                                self.fpga_IO_LO(2),
                                self.fpga_IO_LO(3),
                                self.fpga_IO_HI(0),
                                self.fpga_IO_HI(1),
                                self.fpga_IO_HI(2),
                                self.fpga_IO_HI(3)));
                    
    
    end rtl;
------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.fpga_interconnect_pkg.all;
    use work.mdio_driver_internal_pkg.all;

    use work.ethernet_rx_ddio_pkg.all;

entity top is
    port (
        clock_120mhz : in std_logic;
        uart_rx      : in std_logic;
        uart_tx      : out std_logic;

        mdio_clock             : out std_logic;
        mdio_data_io_in        : in std_logic;
        mdio_data_io_out       : out std_logic;
        mdio_dir_is_out_when_1 : out std_logic;

        rgmii_rx_pll_clock  : in std_logic;
        rgmii_rx_and_ctl_HI : in std_logic_vector(4 downto 0);
        rgmii_rx_and_ctl_LO : in std_logic_vector(4 downto 0);

        -- rgmii_tx_pll_clock  : out std_logic;
        rgmii_tx_and_ctl_HI : out std_logic_vector(4 downto 0);
        rgmii_tx_and_ctl_LO : out std_logic_vector(4 downto 0)
    );
end entity top;


architecture rtl of top is

    signal bus_from_top : fpga_interconnect_record := init_fpga_interconnect;

    signal bus_from_communications : fpga_interconnect_record := init_fpga_interconnect;
    signal bus_to_communications : fpga_interconnect_record := init_fpga_interconnect;

    signal register_in_top : natural range 0 to 2**16-1 := 44252;
    signal mdio_driver : mdio_driver_record := init_mdio_driver_record;

    signal request_counter_reset : std_logic := '0';
    signal request_another_counter_reset : std_logic := '0';
    signal clock_counter : natural := 30000;
    signal testi : natural range 0 to 2**16-1 := 0;
    -- rgmii clock data
    signal shift_register : std_logic_vector(15 downto 0);
    signal rmgii_active : boolean := false;
    signal testi2 : natural range 0 to 2**16-1 := 0;
    signal testi3 : natural range 0 to 2**16-1 := 56;
    signal toggle : std_logic_vector(2 downto 0) := (others => '0');
    signal toggle_counters : std_logic_vector(2 downto 0) := (others => '0');
    signal fast_counter : natural range 0 to 2**16-1 := 0;
    signal clock_register : natural range 0 to 2**16-1 := 0;

    signal output_shift_register : std_logic_vector(15 downto 0) := x"acdc";
    signal ethernet_ddio_out : ethernet_rx_ddio_data_output_group;

begin

    mdio_clock             <= mdio_driver.mdio_clock;
    mdio_data_io_out       <= mdio_driver.mdio_io_data_out;
    mdio_dir_is_out_when_1 <= mdio_driver.MDIO_io_direction_is_out_when_1;
------------------------------------------------------------------------
    test_communications : process(clock_120mhz)
    begin
        if rising_edge(clock_120mhz) then
            init_bus(bus_from_top);
            connect_data_to_address(bus_from_communications, bus_from_top, 1000, register_in_top);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1001, testi);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1002, testi2);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1003, shift_register);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1004, clock_register);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1005, testi3);

            create_mdio_driver(mdio_driver, mdio_data_io_in);

            if write_to_address_is_requested(bus_from_communications, 10e3) then
                request_another_counter_reset <= not request_another_counter_reset;
            end if;

            if write_is_requested_to_address_range(bus_from_communications, 0, 100) then
                write_data_to_mdio(mdio_driver, x"00", std_logic_vector(to_unsigned(get_address(bus_from_communications),8)), std_logic_vector(to_unsigned(get_data(bus_from_communications),16)));
            end if;

            if data_is_requested_from_address_range(bus_from_communications, 0, 100) then
                read_data_from_mdio(mdio_driver, x"00", std_logic_vector(to_unsigned(get_address(bus_from_communications),8)));
            end if;

            if mdio_read_is_ready(mdio_driver) then
                write_data_to_address(bus_from_top, 0, to_integer(unsigned(get_mdio_data(mdio_driver))));
            end if;

            if clock_counter > 0 then
                clock_counter <= clock_counter - 1;
            else
                clock_counter <= 30e3;
                request_counter_reset <= not request_counter_reset;
            end if;
            
        end if; --rising_edge
    end process test_communications;	

------------------------------------------------------------------------
    test_rgmii_clock : process(rgmii_rx_pll_clock)
        
    begin
        if rising_edge(rgmii_rx_pll_clock) then

            fast_counter <= fast_counter + 1;
            toggle <= toggle(1 downto 0) & request_counter_reset;
            if toggle(2) /= toggle(1) then
                fast_counter <= 0;
                clock_register <= fast_counter;
            end if;

            rmgii_active <= ethernet_rx_is_active(ethernet_ddio_out);
            if ethernet_rx_is_active(ethernet_ddio_out) or rmgii_active then
                shift_register <= shift_register(7 downto 0) & get_reversed_byte(ethernet_ddio_out);
                if shift_register /= x"aaaa" then
                    testi2 <= testi2 + 1;
                    if testi2 = 65535 then
                        testi3 <= testi3 + 1;
                    end if;
                end if;
                if testi < 50e3 then
                    testi <= testi + 1;
                end if;
            end if;

            output_shift_register <= output_shift_register(7 downto 0) & output_shift_register(15 downto 8);

            rgmii_tx_and_ctl_HI <= '1' & x"a";
            rgmii_tx_and_ctl_LO <= '1' & x"a";

            toggle_counters <= toggle_counters(1 downto 0) & request_another_counter_reset;
            if toggle_counters(2) /= toggle_counters(1) then
                testi2 <= 0;
                testi3 <= 0;
            end if;
        end if; --rising_edge
    end process test_rgmii_clock;	

    u_rxddio : entity work.ethernet_rx_ddio
    port map(rgmii_rx_pll_clock, (rgmii_rx_and_ctl_HI, rgmii_rx_and_ctl_LO), ethernet_ddio_out);
------------------------------------------------------------------------
    create_bus : process(clock_120mhz)
    begin
        if rising_edge(clock_120mhz) then
            bus_to_communications <= bus_from_top;
        end if; --rising_edge
    end process create_bus;	

------------------------------------------------------------------------
    u_communications : entity work.fpga_communications
    port map(clock => clock_120mhz,
             uart_rx => uart_rx,
             uart_tx => uart_tx,
             bus_to_communications   => bus_to_communications,
             bus_from_communications => bus_from_communications);

end rtl;
