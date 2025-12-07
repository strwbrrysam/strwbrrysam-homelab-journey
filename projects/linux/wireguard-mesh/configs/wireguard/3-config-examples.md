# 3 — WireGuard Config Examples

This section contains example WireGuard configurations based on my actual S1 link (HK1 ↔ UK1).  
All private keys are redacted, but the structure, comments, addressing, and design decisions reflect my real setup.

The goal here is to show how I build consistent tunnel configs across sites, and how each part fits into the larger routing design.

---

## 🧩 S1 — Example WireGuard Tunnel (HK1 ↔ UK1)

The S1 link is one of the three primary tunnels between HK1 and UK1.  
It uses the `10.255.1.0/24` addressing block allocated for all **S-class links**, with a `/30` assigned per tunnel.

For S1, the /30 is:

```
10.255.1.0/30   → HK1 = .1, UK1 = .2
```

Alphabetical order determines which side gets the lower IP:

```
HK1 < UK1 → HK1 = .1, UK1 = .2
```

Below are both configuration files for this tunnel.

---

## HK1 — `s1.conf`

```ini
# ============================
#   S1 WireGuard Tunnel (HK1)
#   HK1 ↔ UK1
#   Subnet: 10.255.1.0/30
# ============================

[Interface]
# Local tunnel IP for HK1 (lower IP because HK1 is alphabetically first)
Address = 10.255.1.1/30

# Port dedicated to S1 on HK1
ListenPort = 28914

# Redacted private key
PrivateKey = <HK1_S1_PRIVATE_KEY>

# Do not let WireGuard install its own routes.
# All routing decisions are done by BIRD OSPF.
Table = off

# Optional:
# SaveConfig = true

# -----------------------------
# Peer Configuration (UK1)
# -----------------------------
[Peer]
PublicKey = <UK1_S1_PUBLIC_KEY>

# In this design, I allow the full IPv4 range so all traffic
# is handed to BIRD for routing. BIRD decides what to do next.
AllowedIPs = 0.0.0.0/0

# UK1 endpoint (public IP or DDNS)
Endpoint = uk1.claycat.cc:28914

# NAT keepalive
PersistentKeepalive = 25
```

---

## UK1 — `s1.conf`

```ini
# ============================
#   S1 WireGuard Tunnel (UK1)
#   UK1 ↔ HK1
#   Subnet: 10.255.1.0/30
# ============================

[Interface]
# Local tunnel IP for UK1 (higher IP alphabetically)
Address = 10.255.1.2/30

# Port dedicated to S1 on UK1
ListenPort = 28914

# Redacted private key
PrivateKey = <UK1_S1_PRIVATE_KEY>

# Prevent WireGuard from creating routes (handled by BIRD)
Table = off

# Optional:
# SaveConfig = true

# -----------------------------
# Peer Configuration (HK1)
# -----------------------------
[Peer]
PublicKey = <HK1_S1_PUBLIC_KEY>

# Forward all traffic into the tunnel.
# BIRD handles the actual routing logic.
AllowedIPs = 0.0.0.0/0

# HK1 endpoint (public IP or DDNS)
Endpoint = hk1.claycat.cc:28914

# NAT keepalive
PersistentKeepalive = 25
```

---

## 🔧 Why This Example Looks Like This

### `/30` addressing  
Every WireGuard link in my homelab uses a `/30`:

```
network-address / (lower-host) / (higher-host) / broadcast
```

This keeps each tunnel self-contained and makes BIRD’s OSPF adjacency behavior very predictable.

### Alphabetical host assignment  
For any two sites:

- Alphabetically first = lower IP (`.1`, `.5`, `.9`, …)  
- Alphabetically second = higher IP (`.2`, `.6`, `.10`, …)

### `Table=off`  
WireGuard does not install routing entries.  
BIRD OSPF handles *all* routing choices.

### `AllowedIPs = 0.0.0.0/0`  
All packets enter the tunnel, but BIRD determines what actually leaves.

This keeps the tunnel as a pure encrypted transport layer.

---

## 🧱 Template: My Generic WireGuard Tunnel Structure

This is the structure I follow for every tunnel:

```ini
[Interface]
Address = <LOCAL_TUNNEL_IP>/30
ListenPort = <DEDICATED_UNIQUE_PORT>
PrivateKey = <PRIVATE_KEY>
Table = off

[Peer]
PublicKey = <REMOTE_PUBLIC_KEY>
AllowedIPs = 0.0.0.0/0
Endpoint = <REMOTE_PUBLIC_IP_OR_DDNS>:<REMOTE_PORT>
PersistentKeepalive = 25
```

Replace the IPs and ports according to the `1-link-inventory.md` file.

---

## Next Steps

I can generate:

- another example (A1, B1, etc.)  
- diagrams showing address flow  
- a comparison block showing *bad* vs *good* config patterns  
- notes about MTU strategy, OSPF quirks, or NAT behavior  

Just tell me what you want to add next.

