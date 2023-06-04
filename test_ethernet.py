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
uart.write_data_to_address(0, int('1140',16))
print("read data from uart : ", uart.request_data_from_address(1000))
print("read data from mdio : ", uart.request_data_from_address(4))
print("read data from rx clock : ", uart.request_data_from_address(1001))
print("read data2 from rx clock : ", uart.request_data_from_address(1002))
print("read data3 from rx clock : ", uart.request_data_from_address(1003))
print("read data4 from rx clock : ", uart.request_data_from_address(1004))
# os.system('cls')
for i in range(32):
    print(i, " : ", hex(uart.request_data_from_address(i)))
