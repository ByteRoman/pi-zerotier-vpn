# ZeroTier VPN Server Setup on Raspberry Pi

This project provides a bash script to configure a Raspberry Pi as a VPN server using [ZeroTier](https://www.zerotier.com/). It sets up the Pi to route traffic securely through a ZeroTier virtual network, enabling remote access to your home network from anywhere.

## Features
- Installs and configures ZeroTier
- Joins a user-specified ZeroTier network
- Enables IP forwarding for VPN functionality
- Configures `iptables` for NAT routing
- Makes `iptables` rules persistent across reboots
- Allows user to select the internet-facing interface from a numbered list

## Requirements
- A Raspberry Pi with Raspberry Pi OS (or other Debian-based Linux)
- Root privileges (run with `sudo`)
- A registered [ZeroTier](https://my.zerotier.com) account and a created network ID

## Installation
1. Download the script:
    ```bash
    wget https://example.com/setup_zerotier_vpn.sh
    ```

2. Make the script executable:
    ```bash
    chmod +x setup_zerotier_vpn.sh
    ```

3. Run the script as root:
    ```bash
    sudo ./setup_zerotier_vpn.sh
    ```

## Usage
1. When prompted, enter your ZeroTier Network ID.
2. Select the internet-facing interface from a numbered list (e.g., `wlan0` or `eth0`).
3. The script will automatically:
   - Install ZeroTier
   - Enable and start the ZeroTier service
   - Join the ZeroTier network
   - Configure IP forwarding
   - Set up `iptables` rules for NAT routing
   - Make the `iptables` rules persistent

## Example Output
```
=== ZeroTier VPN Server Setup on Raspberry Pi ===
Installing ZeroTier...
Enabling and starting ZeroTier service...
Enter your ZeroTier Network ID: xxxxxxxx
Joining ZeroTier network...

Available network interfaces:
[0] lo
[1] wlan0
[2] eth0
Select your internet-facing interface by number: 1
Selected interface: wlan0
Enabling IP forwarding...
Configuring iptables for NAT routing...
Making iptables rules persistent...
ZeroTier VPN server setup completed!
Ensure you authorize the device on your ZeroTier Central dashboard.
```

## Authorizing the Device
After running the script, visit the [ZeroTier Central dashboard](https://my.zerotier.com) and authorize your Raspberry Pi in the Members tab of your network.

## Checking the Connection
Verify that your Raspberry Pi is connected to the ZeroTier network with:
```bash
zerotier-cli listnetworks
```

## Troubleshooting
- If the ZeroTier interface isn't detected, ensure the device is authorized in ZeroTier Central.
- Confirm the ZeroTier service is running:
    ```bash
    sudo systemctl status zerotier-one
    ```

## Uninstallation
To remove ZeroTier and the VPN configuration:
```bash
sudo zerotier-cli leave <Your_Network_ID>
sudo apt remove zerotier-one iptables-persistent -y
sudo iptables -F
sudo iptables -t nat -F
```

## License
This project is licensed under the MIT License.

## Author
Created by CochinaCoccyx

## Contributing
Contributions are welcome! Feel free to submit a pull request or open an issue.
