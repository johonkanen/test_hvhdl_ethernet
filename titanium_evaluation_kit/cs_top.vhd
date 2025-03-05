library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.fpga_interconnect_pkg.all;
    use work.mdio_driver_internal_pkg.all;

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

    signal bus_from_top            : fpga_interconnect_record := init_fpga_interconnect;
    signal bus_from_communications : fpga_interconnect_record := init_fpga_interconnect;
    signal bus_to_communications   : fpga_interconnect_record := init_fpga_interconnect;

    signal register_in_top : natural range 0 to 2**16-1 := 44252;
    signal mdio_driver : mdio_driver_record := init_mdio_driver_record;

    signal request_counter_reset : std_logic := '0';
    signal clock_counter : natural := 30000;
    signal testi : natural range 0 to 2**16-1 := 0;
    -- rgmii clock data
    signal shift_register : std_logic_vector(15 downto 0);
    signal rmgii_active : boolean := false;
    signal testi2 : natural range 0 to 2**16-1 := 0;
    signal testi3 : natural range 0 to 2**16-1 := 0;
    signal toggle : std_logic_vector(2 downto 0) := (others => '0');
    signal fast_counter : natural range 0 to 2**16-1 := 0;
    signal clock_register : natural range 0 to 2**16-1 := 0;

    signal output_shift_register : std_logic_vector(15 downto 0) := x"acdc";

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

            create_mdio_driver(mdio_driver, mdio_data_io_in);

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
        variable rgmii_data : std_logic_vector(7 downto 0);
        
    begin
        if rising_edge(rgmii_rx_pll_clock) then
            testi3 <= 10e3;
            rgmii_data := 
                rgmii_rx_and_ctl_HI(3) &
                rgmii_rx_and_ctl_HI(2) &
                rgmii_rx_and_ctl_HI(1) &
                rgmii_rx_and_ctl_HI(0) &
                rgmii_rx_and_ctl_LO(3) &
                rgmii_rx_and_ctl_LO(2) &
                rgmii_rx_and_ctl_LO(1) &
                rgmii_rx_and_ctl_LO(0);

            fast_counter <= fast_counter + 1;
            toggle <= toggle(1 downto 0) & request_counter_reset;
            if toggle(2) /= toggle(1) then
                fast_counter <= 0;
                clock_register <= fast_counter;
            end if;


            rmgii_active <= rgmii_rx_and_ctl_HI(4) = '1' and rgmii_rx_and_ctl_LO(4) = '1';
            if (rgmii_rx_and_ctl_HI(4) = '1' and rgmii_rx_and_ctl_LO(4) = '1') or rmgii_active then
                shift_register <= shift_register(7 downto 0) & rgmii_data;
                if shift_register = x"aaab" then
                    testi2 <= testi2 + 1;
                end if;
                if testi < 44252 then
                    testi <= testi + 1;
                end if;
            end if;

            output_shift_register <= output_shift_register(7 downto 0) & output_shift_register(15 downto 8);

            rgmii_tx_and_ctl_HI <= '1' & x"a";
            rgmii_tx_and_ctl_LO <= '1' & x"a";
        end if; --rising_edge
    end process test_rgmii_clock;	
------------------------------------------------------------------------
    create_bus : process(clock_120mhz)
    begin
        if rising_edge(clock_120mhz) then
            bus_to_communications <= bus_from_top;
        end if; --rising_edge
    end process create_bus;	

------------------------------------------------------------------------
    u_fpga_communications : entity work.fpga_communications
    generic map(fpga_interconnect_pkg => work.fpga_interconnect_pkg)
        port map(
            clock                    => main_clock
            ,uart_rx                 => uart_rx
            ,uart_tx                 => uart_tx
            ,bus_to_communications   => bus_to_communications
            ,bus_from_communications => bus_from_communications
        );

end rtl;
