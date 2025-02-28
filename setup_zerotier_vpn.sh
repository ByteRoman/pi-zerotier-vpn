#!/bin/bash

echo "=== ZeroTier VPN Server Setup on Raspberry Pi ==="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root (use sudo)"
  exit
fi

# Install ZeroTier
echo "Installing ZeroTier..."
curl -s https://install.zerotier.com | sudo bash

# Enable and start the ZeroTier service
echo "Enabling and starting ZeroTier service..."
sudo systemctl enable zerotier-one
sudo systemctl start zerotier-one

# Ask for ZeroTier Network ID
read -p "Enter your ZeroTier Network ID: " ZT_NETWORK_ID

# Join the ZeroTier network
echo "Joining ZeroTier network..."
zerotier-cli join $ZT_NETWORK_ID

# Get ZeroTier interface name
ZT_IF=$(ip -o link show | grep "zt" | awk -F': ' '{print $2}')
if [ -z "$ZT_IF" ]; then
  echo "ZeroTier interface not found. Ensure you joined the network correctly."
  exit
fi
echo "Detected ZeroTier interface: $ZT_IF"

# Get available interfaces excluding the ZeroTier interface
echo "Available network interfaces:"
interfaces=($(ip -o link show | awk -F': ' '{print $2}' | grep -v "$ZT_IF"))
for i in "${!interfaces[@]}"; do
  echo "[$((i+1))] ${interfaces[$i]}"
done

# User selects the interface by number
while true; do
  read -p "Select your internet-facing interface by number: " choice
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#interfaces[@]}" ]; then
    INTERNET_IF=${interfaces[$((choice-1))]}
    echo "Selected interface: $INTERNET_IF"
    break
  else
    echo "Invalid selection. Please choose a number from the list."
  fi
done

# Enable IP forwarding
echo "Enabling IP forwarding..."
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

# Set up iptables rules for NAT
echo "Configuring iptables for NAT routing..."
sudo iptables -t nat -A POSTROUTING -o $INTERNET_IF -j MASQUERADE
sudo iptables -A FORWARD -i $ZT_IF -o $INTERNET_IF -j ACCEPT
sudo iptables -A FORWARD -i $INTERNET_IF -o $ZT_IF -m state --state RELATED,ESTABLISHED -j ACCEPT

# Make iptables rules persistent
echo "Making iptables rules persistent..."
sudo apt update
sudo apt install -y iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

echo "ZeroTier VPN server setup completed!"
echo "Ensure you authorize the device on your ZeroTier Central dashboard."
