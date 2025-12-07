# Routing Debug Cheatsheet – How I Diagnose WG + BIRD OSPF Failures

This is MY actual flow when a prefix vanishes, a tunnel flaps, or OSPF looks suspicious.

---

## Step 1 — Check the WireGuard Tunnel

- Look at handshakes to instantly spot a dead peer:
  - `sudo wg show | grep handshake`

- Confirm a /30 is actually assigned:
  - `ip addr show dev S1`

- Verify MTU (I’ve seen OSPF break purely because of MTU mismatches):
  - `ip link show S1 | grep mtu`

---

## Step 2 — Check OSPF Neighbor State

- `sudo birdc "show ospf neighbors"`

I specifically look for:

- `Full` → good  
- `Init` → tunnel up but adjacency down  
- `ExStart` → MTU mismatch  
- `Loading` for too long → OSPF stuck syncing

---

## Step 3 — Check If the Prefix Exists in the Routing Table

- `sudo birdc "show route 10.188.X.0/24"`

If BIRD doesn’t know the prefix, then the originating site isn’t advertising it or OSPF adjacency is broken.

---

## Step 4 — Confirm Policy Routing Isn’t Interfering

I rarely use policy routing in this setup, but when debugging ECMP or asymmetric paths:

- `ip rule show`
- `ip route show table main | grep 10.188`

---

## Step 5 — Inspect Traffic Directly

When things make zero sense:

- `sudo tcpdump -ni S1`

I check whether:

- OSPF Hello packets are coming in  
- Replies are missing  
- Traffic is only flowing one way  

---

## Step 6 — Restart ONLY the Broken Component

- Restart a tunnel:
  - `sudo wg-quick down S1 && sudo wg-quick up S1`

- Reload BIRD softly:
  - `sudo birdc "configure soft"`

---
