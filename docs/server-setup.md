# Server Setup

Setup of the server (in this example, a Shuttle running Debian) to allow external access via SSH or direct Ethernet connection locally.

## Prerequisites

1. Check physical connections (Ethernet properly connected)
2. Install `network-manager` if needed:

   ```bash
   sudo apt install network-manager
   ```

3. Configure the network:

   ```bash
   sudo nmtui
   ```

   1. Set the system hostname
   2. Configure the Ethernet connection:
      - Select "Edit a connection".
      - If no connection exists under "Ethernet", add one.
      - Keep the default values and confirm.

4. Disable ModemManager (to avoid conflicts with the 4G modem).

   ```bash
   sudo systemctl disable --now ModemManager
   sudo systemctl mask ModemManager
   ```

5. Install picocom (for debugging and communicating with a 4G modem via AT commands):

   ```bash
   sudo apt-get install picocom
   ```

## Access Configuration

The server requires several configurations to be fully operational:

### SSH Access

For secure remote management of the server  
➜ [Detailed SSH configuration](./remote-access.md)

### Local Network

For direct access to the server, independent of the internet connection  
➜ [Local network configuration](./offline-network.md)

### External Access

For access from the internet (DNS configuration and port forwarding)  
➜ [Router and DNS configuration](./router-setup.md)

## Zigbee Dongle

Linux's USB autosuspend can randomly disconnect the Zigbee dongle (`ASH_ERROR_TIMEOUTS` error in z2m). Disable autosuspend via a udev rule for the specific dongle.

## Development Workflows

### Development via SSH

For efficient development with frequent changes and restarts:

1. Install the VSCode extension `ms-vscode-remote.remote-ssh` to develop directly on the server
2. Test changes on the server
3. After validation, copy locally and commit

This approach avoids the repetitive modify-commit-push-pull-test cycle.

**Important**: Maintain a clear separation between local modifications and those on the server.

### Local Development

For local development before production, configure a local DNS as documented [here](./docs/dnsmasq.md#dns-configuration).
