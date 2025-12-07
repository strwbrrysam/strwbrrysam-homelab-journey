# ECMP Hashing & Path Distribution in My WireGuard Mesh

When I first built the multi-path WireGuard mesh between HK1 ↔ UK1 ↔ USA ↔ HK2, everything *looked* correct on paper:  
- Multiple S-links between HK1 and UK1  
- Equal OSPF costs  
- BIRD exporting multiple next-hops  
- Kernel routing table showing ECMP routes  

But in practice, I kept seeing something weird: **only one S-link actually carried traffic**, and the rest stayed almost idle. Even though I had a full ECMP setup, the load-balancing simply wasn’t happening.

It turned out the missing piece was the kernel’s hashing policy.

---

## Why I Needed to Change the ECMP Hashing Policy

Linux supports Equal-Cost Multi-Path routing (ECMP), but *how* it distributes flows across paths depends entirely on one setting:
net.ipv4.fib_multipath_hash_policy


The kernel decides which next-hop to use based on a hash.  
The problem is: **the default hashing mode is terrible for long-haul WireGuard tunnels.**

### Mode 0 — Layer 3 Hashing (Default)
This only considers **source IP** and **destination IP**.

That’s a huge issue in my setup because:

- HK1 ↔ UK1 traffic often uses the *same* source/destination pair  
- All flows hash to the same tunnel  
- No matter how many S-links I added, only one would actually carry traffic  
- ECMP **existed**, but wasn’t being used  

This explained why all my throughput went through S2 while S1 and S3 barely moved.

---

## Switching to Layer 4 Hashing (The Fix)

To actually utilize all paths, I needed to enable **Layer-4 hashing**:
sudo sysctl -w net.ipv4.fib_multipath_hash_policy=1


Mode `1` includes:

- Source IP  
- Destination IP  
- Source port  
- Destination port  
- Protocol  

This was exactly what I needed.

With L4 hashing enabled:

- Different TCP connections take different S-links  
- Parallel transfers finally distribute properly  
- WireGuard throughput increased massively  
- bmon and wg stats showed all tunnels being utilized  

This change was the difference between “ECMP in theory” and **ECMP actually doing something**.

---

## Validating Kernel Support (CONFIG_IP_ROUTE_MULTIPATH)

The sysctl only works if the kernel was compiled with:
CONFIG_IP_ROUTE_MULTIPATH

I confirmed this with:
grep CONFIG_IP_ROUTE_MULTIPATH /boot/config-$(uname -r)


As expected, my distro already had it enabled (most modern kernels do), so Layer-4 hashing worked immediately.

---

## Why This Matters in My Homelab

My entire design relies on distributing traffic across multiple long-haul links:

- HK1 ↔ UK1 (S-links)
- HK1 ↔ USA
- UK1 ↔ USA
- HK1 ↔ HK2 (future)

Without L4 hashing, **OSPF could install ECMP routes but traffic wouldn’t actually spread across them.**

With L4 hashing:

- Multi-stream transfers (iperf3 `-P`, SMB multi-I/O, Nextcloud chunks) finally use all available paths  
- I get much better throughput on long-distance links  
- Bad or congested paths only affect flows hashed onto them  
- The network behaves the way I designed it  

This small kernel parameter was essential to making my multi-path WireGuard mesh behave like a real routed backbone instead of a single-lane tunnel.

---

## Summary

Switching from L3 hashing to L4 hashing was a required step to unlock **true** ECMP behaviour in my WireGuard mesh.

### Before:
- Only one S-link carried traffic  
- ECMP existed on paper but not in reality  
- Throughput was limited and uneven  

### After:
- All tunnels carry load  
- Multipath routing actually works  
- Long-haul throughput improved dramatically  
- The network behaves predictably and scales with parallel flows  

This is one of those deceptively small changes that completely transforms how a multi-path routed design performs in practice.






