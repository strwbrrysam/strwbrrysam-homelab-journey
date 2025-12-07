# BIRD / birdc Commands – My OSPF Mesh

These are the commands I actually use to debug the HK1 ↔ HK2 ↔ UK1 ↔ USA OSPF mesh over WireGuard.

---

## Core OSPF Health Checks

- Show all neighbors so I can instantly see which link is broken:
  - `show ospf neighbors`

- Sort neighbors so I can visually see state differences:
  - `show ospf neighbors | sort`

- If I’m using multiple OSPF instances, check the mesh-specific one:
  - `show ospf neighbors ospf_mesh`

---

## Interface-Level OSPF Checks

- Show all WG tunnels participating in OSPF:
  - `show ospf interface`

- Check timers, cost, MTU mismatches, or a link stuck in `ExStart`:
  - `show ospf interface S1`

---

## Routing Tables (For My 10.188.x.x LANs)

- Show all OSPF-learned routes:
  - `show route where proto = "ospf_mesh"`

- Inspect a specific LAN prefix:
  - `show route 10.188.10.0/24`

- Get full explanation (origin router, next-hop, LSAs):
  - `show route all for 10.188.10.0/24`

---

## Debugging Partial Mesh Issues

- Check if a site is learning HK1 + USA prefixes:
  - `show route where net ~ [10.188.10.0/24, 10.188.30.0/24]`

- Check if BIRD chose the wrong tunnel (ECMP mismatch):
  - `show route all for 10.188.30.1`

- Confirm that ECMP is being applied correctly between links:
  - `show route 10.188.30.0/24`

---

## Reloading BIRD Safely

- Apply config without dropping sessions:
  - `configure soft`

- Hard reload when I suspect MTU issues or adjacency stuck too long:
  - `configure`

---

## When a LAN Prefix Disappears

This is the workflow I use every time:

1. `show route 10.188.X.0/24`  
2. If it’s missing → `show ospf neighbors`  
3. If a neighbor is missing → `sudo wg show`  
4. If the WG link is stale → restart that specific tunnel  
5. Re-check route and adjacency  
