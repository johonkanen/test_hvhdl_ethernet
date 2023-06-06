import os
import sys
import serial.tools.list_ports
import time

abs_path = os.path.dirname(os.path.realpath(__file__))
sys.path.append(abs_path + '/fpga_communication/fpga_uart_pc_software/')

ports = serial.tools.list_ports.comports()
for port, desc, hwid in sorted(ports):
        print("{}: {} [{}]".format(port, desc, hwid))
comport = str(sys.argv[1])


from uart_communication_functions import *

uart = uart_link(comport                       , 5e6)
uart.write_data_to_address(0                   , int('4140', 16))
uart.write_data_to_address(10000, 1); #reset counters
# time.sleep(2.5)
print("read data from uart : "                 , hex(uart.request_data_from_address(1000)))
print("read data from mdio : "                 , hex(uart.request_data_from_address(0)))
print("number of received bytes : "            , (uart.request_data_from_address(1001)))
print("number of start of frame delimiters : " , (uart.request_data_from_address(1002)))
print("read data4 from rx clock : "            , (uart.request_data_from_address(1004)))
print("read data5 from rx clock : "            , (uart.request_data_from_address(1005)))
# os.system('cls')
# for i in range(32):
#     print(i, " : ", hex(uart.request_data_from_address(i)))
for i in range(10):
    # print(i, " : ", hex(uart.request_data_from_address(i)))
    print("shift register value : " , hex(uart.request_data_from_address(1003)))
