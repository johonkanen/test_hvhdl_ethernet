library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.fpga_interconnect_pkg.all;

entity top is
    port (
        clock_120mhz : in std_logic;
        uart_rx      : in std_logic;
        uart_tx      : out std_logic
    );
end entity top;


architecture rtl of top is

    signal bus_from_top : fpga_interconnect_record := init_fpga_interconnect;

    signal bus_from_communications : fpga_interconnect_record := init_fpga_interconnect;
    signal bus_to_communications : fpga_interconnect_record := init_fpga_interconnect;

    signal register_in_top : natural range 0 to 2**16-1 := 44252;
begin

    test_communications : process(clock_120mhz)
        
    begin
        if rising_edge(clock_120mhz) then
            init_bus(bus_from_top);
            connect_data_to_address(bus_from_communications, bus_from_top, 1, register_in_top);
            
        end if; --rising_edge
    end process test_communications;	

    create_bus : process(clock_120mhz)
        
    begin
        if rising_edge(clock_120mhz) then
            bus_to_communications <= bus_from_top;
        end if; --rising_edge
    end process create_bus;	

    u_communications : entity work.fpga_communications
    port map(clock => clock_120mhz,
             uart_rx => uart_rx,
             uart_tx => uart_tx,
             bus_to_communications => bus_to_communications,
             bus_from_communications => bus_from_communications);


end rtl;
