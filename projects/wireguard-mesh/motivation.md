📌 Motivation & Design Decisions

For several years my homelab sites (UK1, HK1, HK2, and a public USA VPS) were connected using a SoftEther L2 bridge. 
It worked well enough in the early stages of my learning, but as the environment grew — more services, more users, more machines, more storage — the limitations of a Layer-2 VPN became clear.

While SoftEther is an impressive “all-in-one” solution, extending it to a multi-site, always-online network highlighted several constraints that eventually became blockers for me. 
This project represents the redesign of that network using WireGuard at Layer-3 with BIRD providing dynamic routing.



🚧 The Limitations I Hit With SoftEther

My SoftEther deployment used TAP adapters bridged with the physical NIC into br0, making br0 the sole interface with an IP address. 
SoftEther simply forwarded raw Ethernet frames across sites, effectively stretching one Layer-2 domain across HK1, UK1, and the VPS. 
This design worked at small scale but introduced several limitations:

- Global broadcast domain:
  - ARP, DHCP, and general L2 noise were forwarded internationally.
  - More devices meant more unpredictable behaviour.
- Complex failure modes:
  - br0 combined eth0 and multiple TAP adapters, making link behaviour dependent on STP.
  - Reconnections or STP recalculation caused transient outages and MAC flapping.
  - Issues surfaced as Layer-2 forwarding problems instead of clear routing errors.
- Limited path control:
  - I could influence link preference using STP path costs via `brctl setpathcost`, but only in a coarse Layer-2 way.
  - There was no concept of routing metrics, prefixes, or proper path selection.
- Static routing limitations:
  - All inter-site traffic relied on manually configured static routes.
  - Adding new subnets or adjusting topology required hand-editing every gateway.
  - The network did not react to link failures; it simply broke until manually corrected.
- MAC address collisions:
  - Deploying multiple Raspberry Pi devices from the same image sometimes resulted in identical default MAC addresses.
  - On a normal LAN this causes issues, but on a stretched L2 domain it propagated the collision across multiple sites.
  - A single duplicated MAC could destabilise the entire bridged network.
- Redundancy tied to STP:
  - Failover depended entirely on spanning tree, which is slow and ill-suited for high-latency international links.
- Poor observability:
  - Traceroute and diagnostics provided no meaningful path visibility.
  - The network behaved as one opaque segment rather than distinct sites.
 


🚀 Why I Chose WireGuard (And What I Needed From the New Design)
After pushing a stretched Layer-2 SoftEther bridge far beyond what it was designed for, 
it became clear that the next iteration of my network needed proper Layer-3 boundaries. 
I wanted a design that was explicit, scalable, observable, and resilient — 
something that behaved like a real routed network rather than a global broadcast domain held together by STP. 
WireGuard became the ideal foundation for that shift.

- Clean and intentional L3 structure:
  - Each tunnel is a dedicated point-to-point /30 link.
  - AllowedIPs were set to 0.0.0.0/0 on all peers so each tunnel behaved as a simple interface.
  - BIRD OSPF handled all routing decisions, link costs, and convergence.
- A network that is designed — not improvised:
  - No more relying on STP to stabilise a giant L2 bridge.
  - Links, paths, and metrics are explicit and easy to reason about.
  - New subnets and services can be added without hand-editing static routes.
- Strong performance and stability across long-distance links:
  - Lightweight crypto and a small codebase reduce CPU overhead.
  - Throughput between HK1 and UK1 improved noticeably compared to SoftEther.
  - Tunnel recovery is fast and predictable, and failures are isolated.
- Better security and maintainability:
  - Minimal attack surface — no legacy protocols or “all-in-one” services.
  - Strict key-based authentication keeps the design simple and robust.
  - Firewall rules are easier to reason about because behaviour is explicit.
- A proper platform for dynamic routing:
  - WireGuard provides the stable L3 underlay needed for BIRD OSPF.
  - Each interface behaves like a real routed link with measurable characteristics.
  - Routing becomes explicit and reactive instead of relying on STP behaviour.
- Meaningful observability and troubleshooting:
  - Traceroute reveals actual paths instead of hiding everything behind bridging.
  - Per-tunnel testing (latency, throughput, MTU) is simple and isolated.
  - Failures affect only a specific tunnel instead of the entire network.



🔚 Closing

This migration was more than a change of VPN software — it was a move toward a network that is intentional, observable, and built on proper routing principles. 
Replacing the stretched L2 bridge with a clean L3 design gave me a foundation I can grow, troubleshoot, and refine without the fragility of the old setup. 
With WireGuard providing the transport and BIRD handling routing, the network now behaves the way I always wanted it to: predictable, scalable, and designed rather than improvised.
