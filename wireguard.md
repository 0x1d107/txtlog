title: Wireguard VPN setup
date: 2023-02-15

# Wireguard VPN setup

Here and later I'll be using debian names for packages. If you use other distributions, adapt the
package names accordingly.

## Wireguard setup
For userland utilities install `wireguard-tools` package. The package provides `wg` utility for
configuration of wireguard interfaces and `wg-quick` bash script for easily bringing up the
interface. The script also sets up DNS resolver using `openresolv`.

```
anonyamous@server$ sudo apt install wireguard-tools
```

First, we need to generate keys for VPN server. For security set umask to 0077 to restrict other
users' access to keys.

```
anonyamous@server$ umask 0077
```

Then, we generate the server private key and derive the public key.

```
anonyamous@server$ wg genkey > private_key
anonyamous@server$ wg pubkey < private_key > public_key
```

Now we create wireguard interface configuration file `server.conf`.

```
# Server configuration
[Interface]
Address = 10.0.0.1/24 # Server address in the VPN
ListenPort = 51820    # Wireguard listening port
PrivateKey = <contents of private_key file>
```

Now back at the client we also need to generate a pair of keys.

```
anonyamous@client$ wg genkey > client_private_key
anonyamous@client$ wg pubkey < client_private_key > client_public_key
```

And create configuration file `client.conf` similar to the one on the server.

```
# Client configuration
[Interface]
Address = 10.0.0.2/24 # Client address in the VPN
# Client will use random port by default
PrivateKey = <contents of client_private_key file>
```

Now let's get the server and the client to know each other: add `[Peer]` sections with each other's
public keys. Server should have *exposed static ip address* for client to connect. In `AllowedIPs`
field you should specify what subnet is going to be routed to the server. 
If you want expose the client behind NAT to the VPN subnet, specify seconds between keep-alive packets in
`PersistentKeepalive` field.

```
# Client configuration
[Interface]
Address = 10.0.0.2/24 # Client address in the VPN
# Client will use random port by default
PrivateKey = <contents of client_private_key file>

[Peer]
PublicKey = <contents of public_key file on the server>
Endpoint = <server ip address>:51820
AllowedIPs = 0.0.0.0/0 # All traffic will be routed through the server
# PersistentKeepalive = 25 # Prevent connection from closing
```

Now on the server:

```
# Server configuration
[Interface]
Address = 10.0.0.1/24 # Server address in the VPN
ListenPort = 51820    # Wireguard listening port
PrivateKey = <contents of private_key file>

[Peer]
PublicKey = <contents of client_public_key file on the client>
AllowedIPs = 10.0.0.2/32 # Only traffic to 10.0.0.2 will be routed to the client
```

## Persistence
To bring up the wireguard interface we can use `wg-quick` script that comes with 
wireguard-tools. By default `wg-quick` searches for configuration files in `/etc/wireguard/`.
The name of the config file minus `.conf` extension will be the name of the wireguard interface.

Copy the config files to `/etc/wireguard/` and bring the interface up.

*NB*: If you configured to route all traffic to the server, configure firewall rules *before* enabling
the wireguard inteface on the client. Use `wg-quick down wg0` to bring down the interface.

```
# On the client
anonyamous@client$ sudo cp client.conf /etc/wireguard/wg0.conf
anonyamous@client$ sudo wg-quick up wg0 
# On the server
anonyamous@server$ sudo cp server.conf /etc/wireguard/wg0.conf
anonyamous@server$ sudo wg-quick up wg0
```

On the server we probably want the interface to be brought up on boot. On debian, `wireguard-tools`
package has a systemd service file for wg-quick. Interface is specified in the instance name of the
service (this is the string between the first "@" character and the type suffix).

```
anonyamous@server$ sudo systemctl enable --now wg-quick@wg0.service
```

## Firewall rules (UFW)
Debian cloud image I use comes with UFW preinstalled. Otherwise, it can be installed with

```
anonyamous@server$ sudo apt install ufw
```

First we need to allow udp connections on our wireguard port.

```
anonyamous@server$ sudo ufw allow 51820/udp
```

Next backup and edit `/etc/ufw/before.rules` to allow forwarding traffic from/to wireguard interface.
Find `*filter` chain and add these rules after comment `# End required lines`.

```
-A ufw-before-forward -i wg0 -j ACCEPT
-A ufw-before-forward -o wg0 -j ACCEPT
```

In `/etc/sysctl.conf` uncomment the following lines to enable forwarding in the kernel

```
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
```

Reload the configuration

```
anonyamous@server$ sudo sysctl -p
```

To allow ip-forwarding in ufw uncomment in `/etc/ufw/sysctl.conf`

```
net/ipv4/ip_forward=1
net/ipv6/conf/default/forwarding=1
net/ipv6/conf/all/forwarding=1
```

To make the forwarded traffic look like it was sent from the server add a MASRQUERADE rule to NAT
chain. At the end of `/etc/ufw/before.rules` append 

```
*nat
:POSTROUTING ACCEPT [0:0]

-A POSTROUTING -s 10.0.0.0/24 -o enp1s0 -j MASQUERADE 
# substitute enp1s0 with your network interface ( ip link )

COMMIT
```

Now diff of backup and new config should look like that

```
anonyamous@server$ sudo diff -c8 /etc/ufw/before.rules.20230125_150929 /etc/ufw/before.rules
*** /etc/ufw/before.rules.20230125_150929	2020-11-28 19:02:12.000000000 +0000
--- /etc/ufw/before.rules	2023-01-30 10:49:47.689204778 +0000
***************
*** 11,26 ****
--- 11,29 ----
  # Don't delete these required lines, otherwise there will be errors
  *filter
  :ufw-before-input - [0:0]
  :ufw-before-output - [0:0]
  :ufw-before-forward - [0:0]
  :ufw-not-local - [0:0]
  # End required lines

+ # Enable forwarding on wireguard interface
+ -A ufw-before-forward -i wg0 -j ACCEPT
+ -A ufw-before-forward -o wg0 -j ACCEPT

  # allow all on loopback
  -A ufw-before-input -i lo -j ACCEPT
  -A ufw-before-output -o lo -j ACCEPT

  # quickly process packets for which we already have a connection
  -A ufw-before-input -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  -A ufw-before-output -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
***************
*** 68,75 ****
--- 71,87 ----
  -A ufw-before-input -p udp -d 224.0.0.251 --dport 5353 -j ACCEPT

  # allow MULTICAST UPnP for service discovery (be sure the MULTICAST line above
  # is uncommented)
  -A ufw-before-input -p udp -d 239.255.255.250 --dport 1900 -j ACCEPT

  # don't delete the 'COMMIT' line or these rules won't be processed
  COMMIT
+
+ *nat
+ :POSTROUTING ACCEPT [0:0]
+
+ # Masquerade IPs from 10.0.0.0/24 subnet see: man ufw-framework
+
+ -A POSTROUTING -s 10.0.0.0/24 -o enp1s0 -j MASQUERADE
+
+ COMMIT
```

Restart ufw to apply changes

```
anonyamous@server$ sudo systemctl restart ufw
```
