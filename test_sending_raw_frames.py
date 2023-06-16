from scapy.all import Ether, sendp

# Define the destination MAC address
destination_mac = "00:11:22:33:44:55"

# Define the example data to send
example_data = b"Hello, World!"

# Create the Ethernet frame with example data
ethernet_frame = Ether(dst=destination_mac) / example_data

# Send the Ethernet frame
sendp(ethernet_frame, iface="Ethernet")

