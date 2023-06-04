import os
import sys
import serial.tools.list_ports

abs_path = os.path.dirname(os.path.realpath(__file__))
sys.path.append(abs_path + '/fpga_communication/fpga_uart_pc_software/')

ports = serial.tools.list_ports.comports()
for port, desc, hwid in sorted(ports):
        print("{}: {} [{}]".format(port, desc, hwid))
comport = str(sys.argv[1])


from uart_communication_functions import *

uart = uart_link(comport, 5e6)
# print("read data from uart : ", uart.request_data_from_address(1000))
# print("read data from mdio : ", uart.request_data_from_address(4))
os.system('cls')
for i in range(32):
    print(i, " : ", hex(uart.request_data_from_address(i)))
