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
reset_arg = str(sys.argv[2])


from uart_communication_functions import *
uart = uart_link(comport                       , 5e6)

def read_ethernet_ram():
    for i in range(64):
        # print(i, " : ", hex(uart.request_data_from_address(i)))
        # print("shift register value : " , hex(uart.request_data_from_address(1003)))
        print("shift register value : " , hex(uart.request_data_from_address(10000+i)))
def reset_counters():
    uart.write_data_to_address(10000, 1) #reset counters
def reset_phy():
    uart.write_data_to_address(0, int('8000')) #reset counters
def loopback():
    uart.write_data_to_address(0 , int('4140' , 16))
def gigabit():
    uart.write_data_to_address(0 , int('1140' , 16))

# uart.write_data_to_address(0                   , int('9140', 16))
time.sleep(0.5)
# loopback()
gigabit()
time.sleep(0.5)

if reset_arg == "reset":
    reset_counters()

# 00 11 22 33 44 55 3F 7F 54 54 57 30 00 0F 48 65 6C 6C 6F 2C 20 57 6F 72 6C 64 21 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


time.sleep(0.5)
from test_sending_raw_frames import *
time.sleep(0.5)

print("read data from uart : "                 , hex(uart.request_data_from_address(1000)))
print("read data from mdio : "                 , hex(uart.request_data_from_address(0)))
print("number of receive errors : "            , (uart.request_data_from_address(1001)))
print("number of start of frame delimiters : " , (uart.request_data_from_address(1002)))
print("read data4 from rx clock : "            , (uart.request_data_from_address(1004)))
print("read data5 from rx clock : "            , (uart.request_data_from_address(1005)))
print("read number of crc checks : "            , (uart.request_data_from_address(1006)))

read_ethernet_ram()
