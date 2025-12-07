# WireGuard Commands – My Homelab Mesh (HK1 / UK1 / USA / HK2)

These are the exact commands I use when debugging my multi-site WireGuard mesh with /30 links and BIRD OSPF.

---

## Interface Status (Per-Tunnel Checks)

- Show all tunnels (my quick overview when I think something feels “off”):
  - `sudo wg`

- Show a specific S/A/B/C/D/E link when I suspect that one tunnel has died:
  - `sudo wg show S1`
  - `sudo wg show A2`

- Show peers on a tunnel (useful when I forget which endpoint belongs to which link):
  - `sudo wg show S1 peers`

- Show timestamps so I can confirm if OSPF hellos are fresh:
  - `sudo wg show S1 latest-handshakes`

- Check TX/RX counters to see whether traffic is flowing both ways:
  - `sudo wg show S1 transfer`

---

## wg-quick (How I Bring Links Up/Down)

- Bring up a single tunnel:
  - `sudo wg-quick up S1`

- Bring it down:
  - `sudo wg-quick down S1`

- Restart the tunnel when OSPF is stuck in `Init` or `2-Way`:
  - `sudo wg-quick down S1 && sudo wg-quick up S1`

---

## systemd (How My Servers Actually Manage WG)

- Start a tunnel:
  - `sudo systemctl start wg-quick@S1`

- Stop:
  - `sudo systemctl stop wg-quick@S1`

- Restart cleanly when I’m sure it’s the tunnel misbehaving:
  - `sudo systemctl restart wg-quick@S1`

- Check logs for a tunnel when I don’t understand why it failed:
  - `sudo journalctl -u wg-quick@S1 -n 50`

---

## IP-Level Checks for My /30 WG Links

- Verify a tunnel has the expected /30:
  - `ip addr show dev S1`

- Confirm the P2P routes are actually injected:
  - `ip route | grep 10.255.`

- Ping the remote end of a /30 when I suspect L3 is dead:
  - `ping 10.255.X.Y`

- Force traffic to use a specific tunnel:
  - `ping -I S1 10.188.10.1`

---

## When OSPF Drops on a Single Tunnel

This is the exact sequence I run:

1. `sudo wg show S1 latest-handshakes`  
2. `ip addr show S1`  
3. `sudo birdc "show ospf neighbors"`  
4. If the S1 adjacency is stuck → `sudo wg-quick down S1 && sudo wg-quick up S1`
