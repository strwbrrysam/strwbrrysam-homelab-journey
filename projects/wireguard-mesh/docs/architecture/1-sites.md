# 🏠 Site Overview

This mesh network connects four main sites. 
Three of them (HK1, HK2, UK1) are physical locations with consumer routers and CORE servers. 
The fourth is a VPS in the USA acting as a hub for increased redundancy in the event any of the direct links between sites fail,
possibly due to dynamic IP and DDNS issues.

## 🇭🇰 HK1
- WAN IP (placeholder): **111.111.111.111**
- LAN subnet: 10.188.10.0/24
- Router: HK1-Router → 10.188.10.1
- CORE server: CORE-HK1 → 10.188.10.10
- Runs WireGuard, BIRD OSPF, and OpenVPN on the CORE node.

## 🇭🇰 HK2
- WAN IP (placeholder): **222.222.222.222**
- LAN subnet: 10.188.20.0/24
- Router: HK2-Router → 10.188.20.1
- CORE server: CORE-HK2 → 10.188.20.10
- Runs WireGuard, BIRD OSPF, and OpenVPN on the CORE node.

## 🇬🇧 UK1
- WAN IP (placeholder): **333.333.333.333**
- LAN subnet: 10.188.30.0/24
- Router: UK1-Router → 10.188.30.1
- CORE server: CORE-UK1 → 10.188.30.10
- Runs WireGuard, BIRD OSPF, and OpenVPN on the CORE node.

## 🇺🇸 USA VPS
- Public IP (placeholder): **444.444.444.444**
- No separate router — the VPS itself is the CORE node
- Runs WireGuard, BIRD OSPF, and OpenVPN directly
