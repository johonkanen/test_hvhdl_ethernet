from scapy.all import Ether, sendp

# Define the destination MAC address
destination_mac = "00:11:22:33:44:55"

# Define the example data to send
example_data = b"Hello, World!"

# Create the Ethernet frame with example data
ethernet_frame = Ether(dst=destination_mac) / example_data

# Send the Ethernet frame
sendp(ethernet_frame, iface="Ethernet")

# example ethernet frame
#00 11 22 33 44 55 c8 7f 54 54 57 cd 90 00 48 65 6c 6c 6f 2c 20 57 6f 72 6c 64 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c9 92 2a 86
