# Private Network Configuration

This configuration enables connecting to the server via a simple Ethernet cable, without depending on the internet router. Ideal for debugging in local mode.

## Internet Sharing

This method shares the host machine's internet connection with the server. Note: this solution does not provide true isolation in an exclusive local network.

Configuration on the host machine (macOS):

1. Go to Settings > Internet Sharing
2. Select the source: internet connection to share (e.g. Wi-Fi)
3. Set the destination: Ethernet port in use

## APIPA Protocol

Without a DHCP server, the APIPA (Automatic Private IP Addressing) protocol enables automatic connection. This protocol automatically assigns an IP address when no DHCP server is available.

Configuration on the server:

1. Run `sudo nmtui`
2. Select "Edit a connection"
3. Choose the Ethernet interface
4. Set IPv4 to "Link-Local" (APIPA)

Configuration on the host machine (usually already active by default):

1. Go to Settings > Network
2. Select the Ethernet interface
3. Under Details > TCP/IP
4. Set IPv4 to "via DHCP" (to trigger APIPA when no DHCP server is present)

Once the Ethernet cable is connected, the devices automatically assign themselves an IP address in the 169.254.x.x range and establish the connection.

## DHCP Server on Host

To configure a DHCP server on the host machine using `dnsmasq`, follow the documentation [here](./dnsmasq.md#dhcp-configuration).
