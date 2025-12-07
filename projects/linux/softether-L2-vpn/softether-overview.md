# SoftEther Layer-2 Site-to-Site VPN — Overview

This section documents my first attempt at building a multi-site VPN using **SoftEther** to create a full **Layer-2 bridge** between locations, with **Spanning Tree Protocol (STP)** providing link failover.  
While the setup worked, it exposed several limitations that eventually pushed me toward a routed Layer-3 design instead.

---

## 🧩 Why I Used SoftEther L2 Bridging

My original goals were simple:
- Extend a flat Layer-2 network across all sites  
- Avoid routing at the early stage of my homelab  
- Use STP to choose preferred links and provide automatic backup paths  
- Take advantage of SoftEther’s cross-platform support

SoftEther made the initial setup straightforward:
- Virtual Hubs  
- Local Bridge interfaces  
- L2 tunnels between sites  
- STP enabled on the bridge  
- Path preferences controlled using:

```bash
brctl setpathcost br0 <interface> <value>
```

This allowed me to manually shape failover behaviour.

---

## ⚠️ What Went Wrong (Lessons Learned)

Even though the design functioned, several issues became clear:

### 1. **Layer-2 problems affected the entire network**
Any loop, flapping interface, or unstable bridge state at one site impacted *every* site.  
There was no isolation — everything behaved like a single giant switch.

### 2. **Broadcast traffic flooded the WAN**
Because the network was bridged end-to-end, all broadcast frames crossed the tunnels:
- ARP  
- DHCP  
- mDNS  
- General LAN noise  

This wasted bandwidth and increased jitter.

### 3. **SoftEther’s transport layer limited performance**
SoftEther primarily uses **TCP**, with optional UDP acceleration.  
Even with acceleration enabled:
- Throughput was lower than expected  
- Latency fluctuated  
- TCP recovery amplified small packet-loss events

Performance was noticeably worse than a lean, modern VPN like WireGuard.

### 4. **STP made the design fragile**
Failover relied on STP convergence, which was:
- slow during topology changes  
- sensitive to incorrect path costs  
- prone to unpredictable behaviour if multiple links flapped

This made the setup unreliable over WAN conditions.

---

## 🛠️ What This Folder Contains

The purpose of this section is simply to **archive the configuration files** from my early SoftEther experiment, including:

- Virtual Hub definitions  
- L2 bridging settings  
- The exact `brctl` path-cost values used to establish link priority  
- Notes on how the failover logic worked at the time

This is purely historical documentation — not a recommended approach.

---

## 📌 Summary

The SoftEther Layer-2 solution worked well enough for a first attempt, and it taught me a lot about:
- broadcast domains  
- failure domains  
- spanning-tree behaviour  
- why Layer-3 routing is superior for multi-site setups  

But the drawbacks — noisy traffic, fragile behaviour, and limited performance — made it clear that a routed architecture was the correct long-term path.

This folder serves as a record of that early phase of my homelab development.
