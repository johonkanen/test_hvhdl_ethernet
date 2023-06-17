library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.ethernet_rx_ddio_pkg.all;
    use work.PCK_CRC32_D8.all;
    use work.ethernet_frame_ram_write_pkg.all;

package ethernet_receiver_pkg is

    type ethernet_receiver_record is record
        shift_register           : std_logic_vector(15 downto 0);
        crc32                    : std_logic_vector(31 downto 0);
        frame_detected           : boolean;
        receiver_ram_address     : natural;
        crc_counter              : natural range 0 to 7;
        number_of_bytes_received : natural;
        frame_was_received       : boolean;
        rx_is_active             : boolean;
        inverted_byte            : std_logic_vector(7 downto 0);
    end record;

    constant init_ethernet_receiver : ethernet_receiver_record := ((others => '0'), (others => '1'), false, 0, 0, 0,false, false, (others => '0'));

    procedure create_ethernet_receiver (
        signal self      : inout ethernet_receiver_record;
        enet_rx_ddio     : in ethernet_rx_ddio_data_output_group;
        signal ram_write : out ram_write_control_record);

    procedure idle_transmitter (
        signal ddio_hi, ddio_lo : out std_logic_vector(4 downto 0));

    procedure transmit_byte (
        signal ddio_hi, ddio_lo : out std_logic_vector(4 downto 0);
        byte : in std_logic_vector(7 downto 0));

end package ethernet_receiver_pkg;

package body ethernet_receiver_pkg is

    procedure create_ethernet_receiver
    (
        signal self      : inout ethernet_receiver_record;
        enet_rx_ddio     : in ethernet_rx_ddio_data_output_group;
        signal ram_write : out ram_write_control_record
    ) is
        variable enet_byte : std_logic_vector(7 downto 0);
        variable inverted_enet_byte : std_logic_vector(7 downto 0);
    begin
        enet_byte := self.shift_register(7 downto 0);
        inverted_enet_byte := self.inverted_byte;

        self.rx_is_active <= ethernet_rx_is_active(enet_rx_ddio);
        if ethernet_rx_is_active(enet_rx_ddio) or self.rx_is_active then
            self.shift_register <= self.shift_register(7 downto 0) & get_byte(enet_rx_ddio);
            self.inverted_byte <= get_byte_with_inverted_bit_order(enet_rx_ddio);
            if self.shift_register = x"aaab" then
                self.frame_detected <= true;
            end if;

            if self.frame_detected then
                self.crc32 <= nextCRC32_D8(enet_byte, self.crc32);
            end if;

            self.crc_counter <= 4;
        else
            self.frame_detected <= false;

            if self.crc_counter > 0 then
                self.crc_counter <= self.crc_counter - 1;
                self.crc32 <= self.crc32(23 downto 0) & x"ff";
                write_data_to_ram(ram_write, self.receiver_ram_address, self.crc32(31 downto 24));
                self.receiver_ram_address <= self.receiver_ram_address + 1;
            end if;
        end if;
    ------------------------------
        if self.rx_is_active then
            if self.receiver_ram_address < 2**10-1 then
                self.receiver_ram_address <= self.receiver_ram_address + 1;
                if self.frame_detected then
                    write_data_to_ram(ram_write, self.receiver_ram_address, inverted_enet_byte);
                else
                    write_data_to_ram(ram_write, self.receiver_ram_address, enet_byte);
                end if;
            end if;
        end if;
        
    end create_ethernet_receiver;

------------------------------------------------------------------------
        procedure transmit_byte
        (
            signal ddio_hi, ddio_lo : out std_logic_vector(4 downto 0);
            byte : in std_logic_vector(7 downto 0)
        ) is
        begin
            ddio_hi <= '1' & byte(7 downto 4);
            ddio_lo <= '1' & byte(3 downto 0);
            
        end transmit_byte;

        procedure idle_transmitter
        (
            signal ddio_hi, ddio_lo : out std_logic_vector(4 downto 0)
        ) is
        begin
            ddio_hi <= '0' & x"0";
            ddio_lo <= '0' & x"0";
            
        end idle_transmitter;

end package body ethernet_receiver_pkg;
------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.fpga_interconnect_pkg.all;
    use work.mdio_driver_internal_pkg.all;

    use work.ethernet_rx_ddio_pkg.all;

    use work.ethernet_frame_ram_read_pkg.all;
    use work.ethernet_frame_ram_write_pkg.all;
    use work.PCK_CRC32_D8.all;
    use work.ethernet_receiver_pkg.all;

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
    signal rmgii_active : boolean := false;
    signal testi3 : natural range 0 to 2**16-1 := 0;
    signal toggle : std_logic_vector(2 downto 0) := (others => '0');
    signal toggle_counters : std_logic_vector(2 downto 0) := (others => '0');
    signal fast_counter : natural range 0 to 2**16-1 := 0;
    signal clock_register : natural range 0 to 2**16-1 := 0;

    signal output_shift_register : std_logic_vector(15 downto 0) := x"acdc";
    signal ethernet_ddio_out : ethernet_rx_ddio_data_output_group;

    signal ram_read_control_port : ram_read_control_group := init_ram_read_port;
    signal ram_read_out_port : ram_read_output_group := ram_read_output_init;

    signal write_port : ram_write_control_record := init_ram_write_control;

    signal ram_reader : ram_reader_record := init_ram_reader;
    signal ram_shift_register : std_logic_vector(31 downto 0) := (others => '0');

    signal crc_check_counter : natural range 0 to 2**16-1 := 0;
    
    signal empty_ram : boolean := false;

    signal self : ethernet_receiver_record := init_ethernet_receiver;

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
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1002, self.receiver_ram_address);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1003, self.shift_register);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1004, clock_register);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1005, testi3);
            connect_read_only_data_to_address(bus_from_communications, bus_from_top, 1006, crc_check_counter);


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
                clock_counter <= 50;
                request_counter_reset <= not request_counter_reset;
            end if;

            create_ram_reader(ram_reader, ram_read_control_port, ram_read_out_port, ram_shift_register);
            if data_is_requested_from_address_range(bus_from_communications, 10e3, 10e3+511) then
                load_ram_with_offset_to_shift_register(ram_reader, (get_address(bus_from_communications) - 10e3)*2, 2);
            end if;
            if ram_is_buffered_to_shift_register(ram_reader) then
                write_data_to_address(bus_from_top, 0, to_integer(unsigned(ram_shift_register(15 downto 0))));
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

            init_ram_write(write_port);
            create_ethernet_receiver(self, ethernet_ddio_out, write_port);

            ------------------------------------------------------------------------
            output_shift_register <= output_shift_register(7 downto 0) & output_shift_register(15 downto 8);
            idle_transmitter(rgmii_tx_and_ctl_HI, rgmii_tx_and_ctl_LO);
            -- transmit_byte(rgmii_tx_and_ctl_HI, rgmii_tx_and_ctl_LO, output_shift_register(15 downto 8));

            toggle_counters <= toggle_counters(1 downto 0) & request_another_counter_reset;
            if toggle_counters(2) /= toggle_counters(1) then
                self.receiver_ram_address <= 0;
                empty_ram <= true;
            end if;

            if empty_ram then
                if self.receiver_ram_address < 2**10-1 then
                    self.receiver_ram_address <= self.receiver_ram_address + 1;
                    write_data_to_ram(write_port, self.receiver_ram_address, x"00");
                else
                    empty_ram <= false;
                    self.receiver_ram_address <= 0;
                end if;
            end if;
        end if; --rising_edge
    end process test_rgmii_clock;	

    u_rxddio : entity work.ethernet_rx_ddio
    port map(rgmii_rx_pll_clock, (rgmii_rx_and_ctl_HI, rgmii_rx_and_ctl_LO), ethernet_ddio_out);

    u_dpram : entity work.dpram
    port map(clock_120mhz, ram_read_control_port,ram_read_out_port, rgmii_rx_pll_clock, write_port);

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
