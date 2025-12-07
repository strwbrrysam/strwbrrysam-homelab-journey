# 🌐 VLAN Segmentation

Each FreshTomato router hosts two additional VLAN-backed subnets used for Guest/IoT devices and CCTV networks. 
These VLANs do not run WireGuard or BIRD, but they are still fully reachable across the mesh because their subnets are:

- added as static routes on the site routers, pointing to the local CORE node  
- advertised into BIRD OSPF by the CORE node  

This makes all VLAN networks globally routable across HK1, HK2, UK1, and the USA VPS while maintaining local isolation rules.

---

## Guest / IoT Networks
These VLANs have WAN access but are isolated from the main LAN at each site.

- HK1: **10.32.10.0/24**
- HK2: **10.33.10.0/24**
- UK1: **10.34.10.0/24**

---

## CCTV / WAN-blocked Networks
These VLANs are used for cameras and NVR devices. They are blocked from reaching the WAN at the router level, but remain fully routable through the WireGuard mesh for cross-site access and centralised storage.

- HK1: **10.42.10.0/24**
- HK2: **10.43.10.0/24**
- UK1: **10.44.10.0/24**

---

## How VLANs Integrate Into the Mesh

Even though VLAN devices do not participate in the VPN layer:

- The router sends all inter-site traffic for these VLANs to the local CORE node.
- The CORE node advertises the VLAN prefixes to other sites via OSPF.
- Other CORE nodes learn these routes and forward traffic correctly through the WireGuard tunnels.

This allows:
- Remote CCTV access (e.g., HK1 → HK2 cameras)
- Remote IoT/Guest network management
- Centralised cross-site monitoring
- VLAN reachability across the entire homelab mesh

The important distinction is that **the VLANs are routed, not tunneled** — they rely on the CORE nodes as their gateway into the mesh.
