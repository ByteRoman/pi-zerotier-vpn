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

## Usage

### Before Running the Script:
1. **Sign Up or Log In to ZeroTier:**
   - Go to [https://my.zerotier.com/](https://my.zerotier.com/).
   - Create an account or sign in if you already have one.
2. **Create a Network:**
   - Click on **Create a Network** to generate a unique Network ID. You'll need this when prompted by the script.

### Run the Script

1. Download the script at https://github.com/CochinaCoccyx/pi-zerotier-vpn/

2. Make the script executable:
    ```bash
    chmod +x setup_zerotier_vpn_on_pi.sh
    ```

3. Run the script as root:
    ```bash
    sudo ./setup_zerotier_vpn_on_pi.sh
    ```

### After Running the Script:
1. **Authorize Your Pi Server:**
   - Go to your ZeroTier dashboard and find the newly connected device (your Pi).
   - Click to authorize the device, allowing it to join the network.
2. **Enable Network Bridging:**
   - In the device settings on ZeroTier, check the box for **Allow network bridging**.
3. **Configure Managed Routes:**
   - Go to the **Managed Routes** section of your ZeroTier network settings.
     - **Local VPN Subnet:**
       - Destination: `172.26.0.0/16`
       - Via: (Leave empty)
     - **Internet Traffic Routing:**
       - Destination: `0.0.0.0/0`
       - Via: Pi’s VPN IP (e.g., `172.26.82.11`)

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
