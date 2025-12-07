# 🐦 BIRD + OSPF Overview

This folder contains everything related to how I run **BIRD OSPF** on top of my WireGuard mesh.  
It focuses purely on the routing layer — separate from the VPN configuration and separate from the mesh documentation.

## 📌 Purpose of This Folder
- Keep all BIRD configuration files in one place  
- Document my OSPF interface structure and cost design  
- Track how routing behaves across multi-site, multi-tunnel links  
- Serve as a clean landing page for the dynamic-routing side of the homelab

## ⭐ Why I Use OSPF
The full reasoning already lives in the WireGuard mesh documentation, but the short summary is:

- My mesh has many point-to-point tunnels across multiple sites  
- Static routes became difficult to maintain as the topology expanded  
- I needed automatic route advertisement and fast failover  
- OSPF adjusts instantly to link changes and discovers new paths on its own  
- BIRD is lightweight, simple, and ideal for Linux WireGuard environments  

In short:  
**WireGuard provides the encrypted links; OSPF decides the best paths between them.**

## 📂 What’s Inside
- Site-specific BIRD configuration files  
- Interface mappings and naming conventions  
- Notes on OSPF cost tuning and multi-tunnel behaviour  
- Debugging commands, observations, and future improvements

## 🚀 How This Fits Into the Homelab
This folder represents the *routing layer* of my homelab.  
Other sections handle storage, services, or VPN transport — this one is focused purely on how packets choose their path through the mesh.

