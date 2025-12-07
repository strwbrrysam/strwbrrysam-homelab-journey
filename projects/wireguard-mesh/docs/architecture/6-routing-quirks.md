# 6 — Routing Quirks & Static Routes for WireGuard Transit Links

## Overview

Although the WireGuard mesh routes perfectly between all CORE servers, 
each **site’s edge router** (always `10.188.X.1`) does *not* automatically 
understand the `/30` WireGuard transit networks used between tunnel endpoints.

This leads to a very specific routing behaviour:

- Server → remote server = **works**  
- Server → remote **router** = ❌ **fails**  
- The remote **edge router receives the packet but has no return route**
- Traceroutes stop at the remote site's router interface

Nothing is wrong with WireGuard or BIRD — the **edge router simply has no idea where those /30 networks live**.

This is expected behaviour due to how WireGuard creates isolated point-to-point interfaces.

---

## Why Edge Routers Need Static Routes

Your site routers:

- do **not** participate in WireGuard  
- do **not** receive dynamic routes from BIRD/OSPF/BGP  
- only understand LAN networks unless manually instructed otherwise  

Because the WireGuard mesh uses `/30` point-to-point links such as:

```
10.255.1.0/30
10.255.2.0/30
...
10.255.6.0/30
```

the edge routers must be explicitly told:

> “If traffic is headed to any of the WireGuard transit nets, send it to the CORE server on this site.”

This is a one-time configuration per site.

---

## Where These Commands Go

These routes must be added **on the edge routers (10.188.X.1)** of each site.

They do **not** belong on:

- CORE servers  
- LAN hosts  
- WireGuard interfaces  
- BIRD/FRR configs  

Only the WAN/edge router needs these rules.

---

# Static Route Examples (HK1, HK2, UK1)

Below are examples using your consistent addressing convention:

- Edge router IPs: **10.188.X.1**  
- CORE servers:      **10.188.X.10**  

---

## 📍 HK1 Edge Router (10.188.10.1)

CORE-HK1: **10.188.10.10**

```bash
# Add on the HK1 edge router (10.188.10.1)
# Forward all WireGuard transit subnets to CORE-HK1
ip route replace 10.255.1.0/30 via 10.188.10.10
ip route replace 10.255.2.0/30 via 10.188.10.10
ip route replace 10.255.3.0/30 via 10.188.10.10
ip route replace 10.255.4.0/30 via 10.188.10.10
ip route replace 10.255.5.0/30 via 10.188.10.10
ip route replace 10.255.6.0/30 via 10.188.10.10
```

---

## 📍 HK2 Edge Router (10.188.20.1)

CORE-HK2: **10.188.20.10**

```bash
# Add on the HK2 edge router (10.188.20.1)
# Forward all WireGuard transit subnets to CORE-HK2
ip route replace 10.255.1.0/30 via 10.188.20.10
ip route replace 10.255.2.0/30 via 10.188.20.10
ip route replace 10.255.3.0/30 via 10.188.20.10
ip route replace 10.255.4.0/30 via 10.188.20.10
ip route replace 10.255.5.0/30 via 10.188.20.10
ip route replace 10.255.6.0/30 via 10.188.20.10
```

---

## 📍 UK1 Edge Router (10.188.30.1)

CORE-UK1: **10.188.30.10**

```bash
# Add on the UK1 edge router (10.188.30.1)
# Forward all WireGuard transit subnets to CORE-UK1
ip route replace 10.255.1.0/30 via 10.188.30.10
ip route replace 10.255.2.0/30 via 10.188.30.10
ip route replace 10.255.3.0/30 via 10.188.30.10
ip route replace 10.255.4.0/30 via 10.188.30.10
ip route replace 10.255.5.0/30 via 10.188.30.10
ip route replace 10.255.6.0/30 via 10.188.30.10
```

---

## Summary Table

| Site | Edge Router | CORE Server | Required Routes |
|------|-------------|-------------|-----------------|
| **HK1** | 10.188.10.1 | 10.188.10.10 | All 10.255.[1–6].0/30 → 10.188.10.10 |
| **HK2** | 10.188.20.1 | 10.188.20.10 | All 10.255.[1–6].0/30 → 10.188.20.10 |
| **UK1** | 10.188.30.1 | 10.188.30.10 | All 10.255.[1–6].0/30 → 10.188.30.10 |

---

## Final Notes

- These static routes fix a **router → WireGuard mesh** visibility gap  
- Without them, the routers cannot return ICMP/traffic to remote sites  
- The behaviour is normal for point-to-point VPN meshes  
- This file records the exact solution so the issue never needs rediscovering

