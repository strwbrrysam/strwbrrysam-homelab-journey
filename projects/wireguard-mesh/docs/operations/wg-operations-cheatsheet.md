# WireGuard Commands – Homelab Mesh (HK1 / UK1 / USA / HK2)

Focused ONLY on your multi-site WireGuard mesh with /30 links and BIRD OSPF.

---

## Interface Status (Per-Tunnel Debug)

- Show all tunnels (quick overview):
  - `sudo wg`
- Show a specific S/A/B/C/D/E link:
  - `sudo wg show S1`
  - `sudo wg show A2`
- Show peers on a given link:
  - `sudo wg show S1 peers`
- Show timestamps so you can confirm OSPF adjacency freshness:
  - `sudo wg show S1 latest-handshakes`
- Show TX/RX counters for tunnel health:
  - `sudo wg show S1 transfer`

---

## wg-quick (Your naming convention preserves tunnel names!)

- Bring up one tunnel:
  - `sudo wg-quick up S1`
- Bring down one tunnel:
  - `sudo wg-quick down S1`
- Restart it (common when OSPF gets stuck in `Init` or `2-Way`):
  - `sudo wg-quick down S1 && sudo wg-quick up S1`

---

## systemd Wrappers (How your servers actually run tunnels)

- Start a tunnel service:
  - `sudo systemctl start wg-quick@S1`
- Stop:
  - `sudo systemctl stop wg-quick@S1`
- Restart cleanly:
  - `sudo systemctl restart wg-quick@S1`
- Check recent logs from tunnel boot:
  - `sudo journalctl -u wg-quick@S1 -n 50`

---

## IP-Level Checks For Your /30 WireGuard Links

- Verify each tunnel has the expected /30:
  - `ip addr show dev S1`
- Confirm point-to-point routes (your auto-added WG routes):
  - `ip route | grep 10.255.`
- Ping the remote end of a /30 link:
  - `ping 10.255.X.Y`
- Ping through a specific tunnel to test path selection:
  - `ping -I S1 10.188.10.1`

---

## When OSPF Drops on a Single Tunnel

Use this quick sequence:

1. `sudo wg show S1 latest-handshakes`
2. `ip addr show S1`
3. `sudo birdc "show ospf neighbors"`
4. If the S1 adjacency is stuck → `sudo wg-quick down S1 && sudo wg-quick up S1`
