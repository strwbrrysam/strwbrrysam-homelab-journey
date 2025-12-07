# 2 — WireGuard Design Notes

This document captures the reasoning behind my WireGuard design choices.  
It is not a polished guide — it’s simply where I record the thinking, trade-offs,  
and practical lessons that shaped the current implementation.

These notes are here for future reference (and for any hiring manager who wants  
to understand how I approach network design, consistency, and troubleshooting).

---

## Why I Chose /30 Subnets Instead of /32

I initially experimented with a /32 scheme to simplify addressing and remove the  
need for subnet planning. In theory this works fine with dynamic routing, but in  
practice it introduced several operational problems:

- OSPF adjacencies did not always form without additional manual routes.
- WireGuard’s `Table=off` behaviour meant I had to inject host routes manually.
- The troubleshooting overhead wasn’t worth the theoretical elegance.

I reverted to a structured **/30 point-to-point format**, which:

- matches how most PtP VPNs traditionally behave
- provides predictable kernel routes
- works reliably with BIRD OSPF without special handling
- keeps each tunnel cleanly contained inside a dedicated subnet

This decision prioritises reliability over minimalism.

---

## Why I Group Tunnels by Site-Pair (/24 Blocks)

Even though I don’t *need* full /24 blocks for each site-pair, this structure makes  
the network far easier to document and reason about:

- HK1 ↔ UK1 (S links) always live under `10.255.1.x`
- UK1 ↔ USA (A links) always live under `10.255.2.x`
- HK1 ↔ USA (B links) always live under `10.255.3.x`
- HK1 ↔ HK2 (C links) → `10.255.4.x`
- HK2 ↔ UK1 (D links) → `10.255.5.x`
- HK2 ↔ USA (E links) → `10.255.6.x`

This separation makes expansion easy — even years from now I will know exactly  
where new tunnels should live without reviewing old configs.

---

## Alphabetical Assignment of Host Addresses

I assign host addresses within each /30 based on alphabetical order:

- alphabetically first site gets the lower address (.1, .5, .9…)
- alphabetically second site gets the higher address (.2, .6, .10…)

This avoids hardcoding assumptions about “primary” or “secondary” locations.  
It also ensures consistency no matter how many sites I add in the future.

---

## Why I Use Multiple Tunnel “Classes”

I separate tunnels into:

- **S links** (HK1 ↔ UK1)
- **A links** (UK1 ↔ USA)
- **B links** (HK1 ↔ USA)
- **C/D/E links** (future HK2 connectivity)

This gives me:

- logical grouping for documentation  
- predictable naming conventions  
- flexibility for redundancy (e.g., S1, S2, S3)  
- clean expansion for future sites or regions  

---

## WireGuard as Transport, BIRD as the Control Plane

One of the biggest design principles in my homelab:

**WireGuard handles encryption and transport.  
BIRD handles routing intelligence.**

This separation is intentional:

- WireGuard is extremely good at secure, fast tunnels.
- BIRD is built for dynamic routing, metrics, failover, and path selection.

Letting each component do what it’s best at keeps the architecture simple and resilient.

---

## Documentation Philosophy

This repo is not intended as a polished tutorial — it's a record of how I think  
and how I solve problems. That means:

- some documents intentionally repeat concepts  
- some files act as internal notes rather than user-facing docs  
- I write things in a way future-me can understand without re-learning them  

This is a living document. I’ll update it as the homelab evolves or when I revisit  
certain design decisions with more experience.
