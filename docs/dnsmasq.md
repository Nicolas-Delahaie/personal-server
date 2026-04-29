# **dnsmasq** Configuration

Dnsmasq is a lightweight DNS and DHCP server, commonly used to manage IP addresses on a local network.

## Installing dnsmasq

On the host machine (example with Homebrew on macOS):

```bash
brew install dnsmasq
```

A default `dnsmasq` configuration is available in `host_configs/dnsmasq-example.conf`. To use it as a base:

```bash
cp host_configs/dnsmasq-example.conf /opt/homebrew/etc/dnsmasq.conf
```

## DHCP Configuration

This DNS server dynamically assigns an address to the server, enabling a local connection for debugging. The host machine acts as an internet router and the server can connect to it autonomously.

1. **Configure dnsmasq on the host machine**

   - In `/opt/homebrew/etc/dnsmasq.conf` (macOS path), add:

     ```ini
     # Declare this machine as the sole DHCP server on the network
     dhcp-authoritative
     # Configure the interface to listen on, the range, netmask and lease duration
     dhcp-range=192.168.10.50,192.168.10.150,255.255.255.0,24h
     # Set the default gateway (host machine's IP address)
     dhcp-option=3,192.168.10.1
     # Limit DNS responses to local networks
     local-service
     ```

     > Important notes:
     >
     > - The starting IP must be higher than the host machine's static IP
     > - Dnsmasq becomes the DHCP server for all interfaces
     > - To limit to a specific interface, prefix with its name (example: `dhcp-option=en11,3,192.168.10.1`)
     > - The 192.168.10.x range is recommended as it is reserved for private networks and rarely used

   - Restart the service:

     ```bash
     sudo brew services restart dnsmasq
     ```

2. **Set a static IP on the host's Ethernet interface**

   - In Settings > Network > Ethernet adapter > TCP/IP:
     - Configure IPv4: Manually
     - IP Address: 192.168.10.1 (matching the gateway in dhcp-option)
     - Subnet mask: 255.255.255.0

3. **Configure the server as a DHCP client**

   - Configure the server to use DHCP via NetworkManager:

     ```bash
     sudo nmtui
     ```

   - Select "Edit a connection"
   - Choose the Ethernet connection > "Edit"
   - Verify "IPv4 Configuration" is set to "Automatic" (DHCP)

4. **Establish the connection**
   - Connect the Ethernet cable between host and server
   - The server will automatically receive an IP via dnsmasq
   - To verify, see the "[debugging](#debugging)" section

## DNS Configuration

Traefik generates subdomains for each service. In production, all subdomains point to the same IP via the global DNS. Locally, you need to configure redirection of `*.localhost` to `localhost`.

The DNS server redirects all local subdomains to itself, allowing the application to be tested locally under the same conditions as in production.

Add to `/opt/homebrew/etc/dnsmasq.conf`:

```ini
address=/.localhost/127.0.0.1
```

DNS resolver configuration:

```bash
sudo mkdir -p /etc/resolver
echo "nameserver 127.0.0.1" \
 | sudo tee /etc/resolver/localhost

sudo nano /opt/homebrew/etc/dnsmasq.conf
sudo nano /etc/resolv.conf
sudo nano /etc/resolver/localhost
ls /etc/resolver
```

Note: /etc/resolv.conf is automatically generated based on the current network

## Debugging

### Logging

Add to `/opt/homebrew/etc/dnsmasq.conf`:

```ini
log-queries
log-facility=/opt/homebrew/var/log/dnsmasq.log
```

Real-time view of DNS and DHCP requests:

```bash
tail -f /opt/homebrew/var/log/dnsmasq.log
```

For startup errors (invalid configuration):

```bash
sudo log stream --style syslog --predicate 'process == "dnsmasq"'
```

Check listening on port 53:

```bash
sudo lsof -i UDP:53 -i TCP:53
```

### DNS Queries

```bash
dig <domain> +short
dig @127.0.0.1 <domain> +short
dig +trace <domain> # trace the DNS chain
nslookup <domain>
```

### Resolver Information (macOS)

```bash
scutil --dns
scutil --resolver localhost
dscacheutil -q host -a name <domain>
```

### Flush DNS Cache (macOS)

```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

### Connectivity Tests

```bash
ping -c1 test.localhost
curl -I --no-keepalive http://<service>.localhost
```
