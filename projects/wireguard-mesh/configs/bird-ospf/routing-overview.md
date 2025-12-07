# 🧠 Routing Architecture Overview (OSPF + WireGuard)

This network uses a Layer-3 WireGuard mesh as the transport layer and BIRD OSPF as the dynamic routing protocol across all CORE nodes (HK1, HK2, UK1) and the USA VPS.  
WireGuard provides the point-to-point tunnels; OSPF turns those tunnels into a fully dynamic, self-adapting routed network.

This separation keeps the routing layer simple, predictable, and resilient.

---

## 🛰️ WireGuard as the Underlay

All inter-site tunnels are WireGuard interfaces configured with unique /30 subnets.  
OSPF treats each tunnel as a **point-to-point (P2P) interface**, allowing clean adjacency formation and clear path selection.

Benefits:
- Every link is explicit and measurable  
- Failures affect only one tunnel, not the entire network  
- MTU, latency, and performance can be tested per-link  
- Routing is symmetric and intentional rather than emergent  

---

## 📡 What OSPF Advertises

Each CORE node injects several prefix types into the OSPF domain:

### 1. **Site LAN**
Each physical site has its own LAN /24:
- HK1 → 10.188.10.0/24  
- HK2 → 10.188.20.0/24  
- UK1 → 10.188.30.0/24  

These define the core addressing at each location.

### 2. **Guest / IoT VLAN Prefixes**
These VLANs are isolated locally but still routable across the mesh:
- 10.32.10.0/24  
- 10.33.10.0/24  
- 10.34.10.0/24  

### 3. **CCTV (WAN-blocked) VLAN Prefixes**
These networks remain LAN-only at the router level but are globally reachable via OSPF:
- 10.42.10.0/24  
- 10.43.10.0/24  
- 10.44.10.0/24  

### 4. **OpenVPN Subnets**
Each site’s OpenVPN pools are also advertised:
- HK1 → 10.192.x.x  
- HK2 → 10.193.x.x  
- UK1 → 10.194.x.x  
- USA → 10.207.x.x  

These allow remote-access clients to become first-class citizens in the routed topology.

---

## 🧭 How Path Selection Works

OSPF selects paths based on:
- Link cost  
- Interface type (P2P)  
- Adjacent availability  
- Convergence timers  

### **Primary HK1 ↔ UK1 routing path**
The **S-links** (HK1 ↔ UK1) are configured with **lower OSPF costs**, making them the preferred path for Hong Kong ↔ UK communication.

Even when HK1–USA–UK1 latency is similar, the S-links remain the intentionally preferred route.

### **Secondary paths via USA**
If S-links fail:
- HK1 → UK1 traffic can reroute via USA (HK1 ↔ USA ↔ UK1)  
- UK1 → HK1 behaves identically in reverse  

This creates a robust failover without manual intervention.

### **Future HK2 integration**
New C/D/E link families will introduce:
- HK2 ↔ HK1 internal routing  
- HK2 ↔ UK1 direct routing  
- HK2 ↔ USA hub routing  

Each will receive an appropriate OSPF cost to reflect intended traffic flow and redundancy strategies.

---

## 🔄 Failover and Convergence

If any WireGuard tunnel goes down:

1. BIRD detects the interface change  
2. OSPF adjacency drops  
3. OSPF recalculates the topology  
4. Traffic shifts to the next-best available route  

This happens without:
- manual static route changes  
- router configuration updates  
- service downtime at application level  

---

## 🎯 Why OSPF Works So Well Here

- **No static routes** to manage across multiple sites  
- **Automatic discovery** of new networks (e.g., OpenVPN, VLANs)  
- **Automatic failover** using dynamic link recalculation  
- **Predictable behaviour** expressed by metrics and costs  
- **Full visibility** through `birdc`, logs, and trace tools  
- **No reliance on bridging or STP** (unlike the SoftEther design)  

The result is a clean, intentional, Layer-3 mesh that behaves like a simplified enterprise WAN — built entirely on open-source tools.

---

This file is the conceptual foundation for the detailed BIRD configuration docs in:
/projects/wireguard-mesh/docs/configs/bird-ospf/
