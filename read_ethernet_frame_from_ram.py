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

uart = uart_link(comport, 5e6)
print("print ethernet frame from ram : ")
for i in range(40):
    print(hex(uart.request_data_from_address(10001+i)))
