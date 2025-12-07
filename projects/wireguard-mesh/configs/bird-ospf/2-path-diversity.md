# HK1 ↔ UK1 “S Links” — Purpose and Design Philosophy

The S-links between HK1 and UK1 aren’t just simple redundant tunnels.  
I built them to serve a very different purpose: **to increase stability, enforce path diversity, and improve throughput by routing traffic through completely different physical locations across the planet.**

In other words, each S link is an intentional attempt to route traffic over a variety of different upstream servers.
Even though HK1 and UK1 are fixed endpoints, the *middle of the path* changes dramatically depending on which S link the traffic uses.

---

## Why I Created Multiple S Links

When I originally connected HK1 and UK1, I noticed that a single WireGuard tunnel — even if it had excellent performance — still had a few inherent limitations:

- A link is only as stable as the physical and network path it travels through.
- Congestion or poor routing on the intermediate hops could degrade performance.
- Throughput was capped by whatever routing that single path happened to take at that moment.
- If a single VPS or transit provider had a bad day, the whole inter-site connection suffered.

So instead of treating S links as *1 tunnel + 1 backup*, I started treating them as **parallel transport paths**, each one taking a different journey across the globe.

One might travel:
- Over the USA → Europe  
Another might go:
- Through Singapore → Middle East → Europe  
And another might take:
- A completely different Tier-1 carrier or backbone.

This gives me something that resembles “poor man’s MPLS TE” but built entirely with simple WireGuard links.

---

## What Multiple Paths Give Me

### 1. **Path Diversity**
If any upstream provider develops latency, packet loss, or congestion, only that specific S-link is impacted.  
OSPF then naturally starts preferring the links with:
- Lower cost  
- Faster response  
- Cleaner metrics  

This means the mesh can route *around* a bad part of the internet.

### 2. **Higher Aggregate Throughput**
Since OSPF supports ECMP (Equal Cost Multi-Path), and WireGuard can push hundreds of Mbps per tunnel, multiple S-links allow traffic to be shared across them.

When I move large files between HK1 and UK1, or when many services are active at once, the system can use several links simultaneously.

### 3. **Better Real-World Stability**
Instead of depending on a single VPS or hosting provider, I’m spreading risk across multiple independent upstreams.  
This has already proven useful when one of the VPS nodes had inconsistent routing—only one S link degraded, while the others stayed smooth.

### 4. **Improved Monitoring Insight**
With multiple parallel paths, it becomes extremely obvious when one of them degrades.  
A single S-link dropping latency or increasing jitter becomes visible in traffic patterns, BIRD metrics, and even Nextcloud transfer speeds.

This helps me “see” internet routing issues long before they become major outages.

---

## How These Links Fit Into the Homelab Mesh

HK1 ↔ UK1 is the most critical path in my network:  
- HK1 hosts central storage and family services  
- UK1 is my daily-use environment  
- Both sites sync, replicate, and back up each other  

So improving this single segment multiplies reliability across the *entire* mesh.

The S links form the backbone of that connection, giving the two sites:

- Multiple independent long-haul routes  
- Automatic load balancing  
- Automatic failover  
- A measurable increase in responsiveness  

All without adding any unnecessary complexity.

---

## Summary

The S links aren’t “redundant tunnels.”  
They’re **multiple global transport paths**, each intentionally built to ride different internet routes so that HK1 and UK1 never depend on a single backbone, a single VPS, or a single IP transit provider.

This design gives me:

- Path diversity  
- Higher throughput  
- Smoother long-distance performance  
- Resilience against global transit instability  

And it does all of that using nothing more than WireGuard + BIRD + thoughtful topology design.

Also see 3-multipath-hashing.md where I talk about an extra setting needed to properly enable multipath to take advantage of all WG links.
