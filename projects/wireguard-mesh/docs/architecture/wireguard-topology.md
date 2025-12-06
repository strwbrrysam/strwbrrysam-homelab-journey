# 🛰️ WireGuard Topology

The inter-site connectivity in this homelab is built using a Layer-3 WireGuard mesh. 
Each link is a dedicated point-to-point tunnel configured with a unique /30 subnet. 
All CORE nodes (HK1, HK2, UK1) and the USA VPS participate in the mesh.

To keep things organised, each tunnel belongs to a named “link family” (A, B, S, C, D, E). 
The letter encodes which sites are connected and loosely reflects how important that link is expected to be in normal operation.

---

## 🔗 Link Families and Their Roles

### 🟢 S-links — HK1 ↔ UK1 (Primary International Path)

S-links represent the **direct path between HK1 and UK1** and are intended to be the *preferred* route for traffic between these two sites.

- Site pair: **HK1 ↔ UK1**
- Examples: `S1`, `S2`, `S3`, ...
- Role:
  - Primary routing path between Hong Kong and the UK.
  - Will be given **lower OSPF costs** so that BIRD prefers S-links over going via the USA.
  - Direct HK1 ↔ UK1 latency (~200 ms) is preferred even if USA-based paths have similar RTT.

In practice, S-links are the “main road” between HK1 and UK1. The A/B links via USA act more like backup or alternative paths.

---

### 🔵 A-links — UK1 ↔ USA

A-links connect the UK site directly to the USA VPS.

- Site pair: **UK1 ↔ USA**
- Examples: `A1`, `A2`, `A3`, ...
- Role:
  - Provide international connectivity between the UK and the USA.
  - Serve as alternative paths for HK1↔USA or HK1↔UK1 traffic if direct links are down (depending on OSPF costs and deployment).
  - Represent one half of the “hub-style” paths via USA.

---

### 🟣 B-links — HK1 ↔ USA

B-links connect the primary Hong Kong site to the USA VPS.

- Site pair: **HK1 ↔ USA**
- Examples: `B1`, `B2`, `B3`, ...
- Role:
  - Provide direct connectivity between Hong Kong and the USA.
  - Can be used as an alternative path for HK1↔UK1 traffic if S-links fail (via HK1 → USA → UK1).
  - Together with A-links, form a secondary/backup path between HK1 and UK1 through the USA hub.

While these paths might have similar latency to the direct S-links, they are **not** intended to be primary for HK1↔UK1. 
OSPF costs will be tuned accordingly.

---

## 🧱 Planned Future Link Families

The following link families are planned but not necessarily active yet. They extend the same naming convention to HK2.

### 🟡 C-links — HK2 ↔ HK1

- Site pair: **HK2 ↔ HK1**
- Examples: `C1`, `C2`, ...
- Role:
  - Direct Hong Kong–to–Hong Kong backbone between the two HK sites.
  - Likely to receive low OSPF cost to keep HK-internal traffic local.

### 🟠 D-links — HK2 ↔ UK1

- Site pair: **HK2 ↔ UK1**
- Examples: `D1`, `D2`, ...
- Role:
  - Secondary international path between HK2 and the UK.
  - Can act as a backup or alternative route depending on cost tuning.

### 🔴 E-links — HK2 ↔ USA

- Site pair: **HK2 ↔ USA**
- Examples: `E1`, `E2`, ...
- Role:
  - Direct connectivity between HK2 and the USA VPS.
  - Forms part of the HK2 hub-style connectivity via the USA.

---

## 🔤 Naming Philosophy

The link names are:

- **Alphabetical** (A, B, C, D, E, S)
- **Grouped by site pairs**
- **Loosely ordered by perceived importance**

In practice:
- **S-links** are treated as the most important path between HK1 and UK1 (primary route).
- A-links and B-links form secondary/backup paths between regions via the USA.
- C/D/E extend the same idea to HK2 as the network grows.

This naming scheme makes it easy to look at a link name (e.g., `S1` or `B2`) and immediately know:
- Which two sites are connected
- Roughly what the link is used for
- How it is likely to be costed in OSPF

---

## 🗺️ Addressing and Config Details

Each link is implemented as a WireGuard interface with a unique /30 subnet allocated from a dedicated addressing pool (e.g. 10.255.0.0/16).

Per-link details such as:
- Exact /30 subnet
- IP assignment at each end
- Interface names and configuration

…are documented in:

```text
/projects/wireguard-mesh/docs/configs/wireguard/README.md
