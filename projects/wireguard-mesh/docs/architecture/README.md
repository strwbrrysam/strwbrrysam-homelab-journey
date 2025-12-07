# 🏗️ Architecture Documentation

## Purpose
This folder contains the high-level architectural overview of the entire WireGuard + OSPF mesh network that links HK1, HK2, UK1, and the USA VPS.  
It describes **what exists, how each component fits together, and how the network is structured**, without going into raw configuration details.

Use this folder to understand the big-picture design before diving into specific configurations.

---

## 📂 Contents

### 🔹 sites.md
Overview of all four sites:
- WAN placeholders  
- LAN subnets  
- Router roles  
- CORE server roles  
- Which services run at each location  

### 🔹 lans.md
Main LAN addressing scheme:
- 10.188.x.0/24 site layout  
- Router always `.1`  
- CORE always `.10`  
- Rationale behind consistent addressing  

### 🔹 vlans.md
Guest/IoT and CCTV VLAN design:
- VLAN subnets at each site  
- WAN-blocking behaviour for CCTV  
- How these VLANs remain isolated locally  
- How they still become globally routable via OSPF  

### 🔹 openvpn.md
Site-specific OpenVPN subnets:
- HK1, HK2, UK1, and USA ranges  
- Why OpenVPN pools remain part of the routed topology  
- How these prefixes are advertised in OSPF  

### 🔹 wireguard-topology.md
The full mesh link structure:
- Link families (A/B/S/C/D/E)  
- Why S-links are the preferred HK1↔UK1 path  
- Planned expansion with HK2 link sets  
- How tunnels fit into the overall routing design  

### 🔹 routing-overview.md
High-level routing behaviour:
- How BIRD OSPF interacts with WireGuard tunnels  
- How paths are chosen  
- What prefixes each CORE node advertises  
- Why OSPF creates a predictable, adaptable mesh  

---

## 🧭 How to Use This Folder

Start with **sites.md** and **lans.md** to get familiar with the physical and logical structure of each location.  
Then read **wireguard-topology.md** and **routing-overview.md** to understand how the mesh operates across sites.

The VLAN and OpenVPN files explain how additional networks fit into the global routing domain.

Once the architectural overview is clear, move to:
/projects/wireguard-mesh/docs/configs/
…to explore configuration rationale, link inventories, and detailed example configs.

---

## 🔗 Related Sections

### 📘 High-Level Motivation  
`/projects/wireguard-mesh/README.md`  
Explains why the migration from SoftEther L2 to WireGuard L3 was done.

### ⚙️ Configuration Documentation  
`/projects/wireguard-mesh/docs/configs/`  
Deep dives into WireGuard, OSPF, and example configuration files.

### 🛠️ Troubleshooting  
`/projects/wireguard-mesh/docs/troubleshooting.md`  
Notes, fixes, and behaviours encountered while building the mesh.

---

This folder provides a clean, modular view of the network architecture so that anyone — including future you — 
can quickly understand how the entire system fits together.

