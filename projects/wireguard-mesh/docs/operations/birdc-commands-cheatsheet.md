# BIRD / birdc Commands – Homelab OSPF Mesh

These commands are tuned for your topology:  
HK1 ↔ HK2 ↔ UK1 ↔ USA (full mesh via multiple /30 WG links).

---

## Core OSPF Health Checks

- Show ALL neighbors across all tunnels:
  - `show ospf neighbors`
- Show adjacency states across every S/A/B/C/D link:
  - `show ospf neighbors | sort`
- Show neighbors on a specific instance (if you split HK1 internal vs mesh):
  - `show ospf neighbors ospf_mesh`

---

## Interface-Level OSPF Checks (Useful for tunnel-by-tunnel issues)

- Show which tunnels are part of OSPF:
  - `show ospf interface`
- Show detailed interface metrics, cost, MTU mismatches, dead timers:
  - `show ospf interface S1`

---

## Routing Table Checks (Specifically for your 10.188.x.x LANs)

- Show all learned routes from OSPF:
  - `show route where proto = "ospf_mesh"`
- Show a specific prefix (e.g., HK1 LAN):
  - `show route 10.188.10.0/24`
- Show detailed reason + next-hop + originating router:
  - `show route all for 10.188.10.0/24`

---

## Troubleshooting Split-Brain or Partial Mesh Problems

- Check whether UK1 is learning all HK1 and USA prefixes:
  - `show route where net ~ [10.188.10.0/24, 10.188.30.0/24]`
- Check if a route is coming from the wrong tunnel (mis-weighted ECMP):
  - `show route all for 10.188.30.1`
- Check ECMP load-sharing between tunnels:
  - `show route 10.188.30.0/24`

---

## Configuration Reloading (When you tweak OSPF interface cost or timers)

- Soft reload (preserves adjacencies):
  - `configure soft`
- Hard reload (if OSPF is stuck in `ExStart`/`Init` due to MTU mismatch):
  - `configure`

---

## Quick Command Chain When A Single Site Loses A LAN Prefix

Use this exact triage workflow:

1. Check if BIRD sees the prefix:
   - `show route 10.188.X.0/24`
2. Check if the origin router is advertising it:
   - `show ospf neighbors`
3. Check if a tunnel is down:
   - `sudo wg show`
4. Look for OSPF dead timer expiry:
   - `show ospf interface`
5. Restart only the problematic tunnel:
   - `sudo wg-quick down A2 && sudo wg-quick up A2`
