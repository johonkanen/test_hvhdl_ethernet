from scapy.all import Ether, IP, UDP, sendp

# Define the source and destination MAC addresses
source_mac = "00:11:22:33:44:55"
destination_mac = "AA:BB:CC:DD:EE:FF"

# Create the Ethernet frame
ethernet_frame = Ether(src=source_mac, dst=destination_mac)

# Create the IP packet
ip_packet = IP(src="192.168.0.1", dst="192.168.0.2")

# Create the UDP packet
udp_packet = UDP(sport=12345, dport=54321)

# Define the message to send
message = b"Hello, World!"

# Create the final packet by combining the Ethernet frame, IP packet, UDP packet, and message
packet = ethernet_frame / ip_packet / udp_packet / message

# Send the packet
sendp(packet, iface="Ethernet")
