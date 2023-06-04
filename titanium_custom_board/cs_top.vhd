library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


entity top is
    port (
        clock_120mhz : in std_logic;
        uart_rx      : in std_logic;
        uart_tx      : out std_logic
    );
end entity top;


architecture rtl of top is


begin


end rtl;
