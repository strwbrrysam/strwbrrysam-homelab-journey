# Routing Debug Cheatsheet – Focused on WireGuard + BIRD OSPF

Strictly tailored to your homelab’s routing problems, especially:
- “Prefix missing on one site”
- “OSPF neighbor stuck”
- “Traffic only flows one direction”
- “WG tunnel up but routes missing”

---

## Step 1 — Verify WG Tunnel Health

- Show all handshakes (to spot one dead link):
  - `sudo wg show | grep handshake`
- Check that a /30 is assigned:
  - `ip addr show dev S1`
- Check tunnel MTU (OSPF breaks if mismatched):
  - `ip link show S1 | grep mtu`

---

## Step 2 — Confirm OSPF Neighbor State

- `sudo birdc "show ospf neighbors"`
- Look for:
  - `Full` (good)
  - `Init` or `2-Way` (not forming adjacency)
  - `ExStart` (MTU mismatch)
  - `Loading` for too long (sync stuck)

---

## Step 3 — Check If A Prefix Is Being Learned

- `sudo birdc "show route 10.188.X.0/24"`
- If missing → check neighbor on that LAN’s originating router:
  - `sudo birdc "show ospf neighbors"`

---

## Step 4 — Check That Policy Routing Isn’t Interfering

(Used rarely in your current design but useful for debugging if you add ECMP)

- `ip rule show`
- `ip route show table main | grep 10.188`

---

## Step 5 — Inspect Traffic Directly

- Capture on the tunnel:
  - `sudo tcpdump -ni S1`
- Look for:
  - OSPF Hello packets  
  - Missing responses  
  - Asymmetric traffic (OSPF only one direction)

---

## Step 6 — Restart Only What’s Broken

- Restart a tunnel:
  - `sudo wg-quick down S1 && sudo wg-quick up S1`
- Reload BIRD (soft first):
  - `sudo birdc "configure soft"`

---

## Quick Reference – Common Root Causes You've Encountered

- WRONG subnet mask (/24 mistaken for /30)
- MTU mismatch between WG endpoints  
- Dead remote peer (handshake expired)  
- Incorrect AllowedIPs blocking OSPF traffic  
- Wrong next-hop due to stale OSPF LSA  
- BIRD instance not reloaded after config change  

This is your “fast triage” for the most common failures.
