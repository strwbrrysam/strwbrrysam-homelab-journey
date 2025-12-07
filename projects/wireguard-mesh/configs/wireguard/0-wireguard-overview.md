# 0 — WireGuard Overview

This document explains how I use WireGuard across my multi-site homelab. It sets the context for the configs inside this folder and how they fit into my overall networking design.

## 🌐 What I Use WireGuard For

My WireGuard setup forms the encrypted backbone between my three main locations:

- HK1 — my parent's apartment, houses a simple storage server, integrated into CORE-HK1
- UK1 — my main workstation + lab, wireguard will be running on a raspberri Pi here, with dedicated storage on a different device.
- USA VPS — a public anchor point for NAT traversal, routing stability, and fallback connectivity

The mesh gives me:

- Reliable site-to-site encrypted links
- Multiple redundant paths
- A clean transport layer for BIRD dynamic routing
- A stable way to run Unison, SMB, Nextcloud, SSH, CCTV, and general sync traffic across sites

## 🔗 My Tunnel Naming Scheme

My tunnel names use simple letters (S, A, B, C, etc.). The letters themselves do **not** define
whether the tunnel is primary or backup — they’re just labels that let me sort tunnels by
importance in my own head.

For example:

- **S tunnels are my main HK1 ↔ UK1 backbone.** These are the highest-priority links and carry
  most of the cross-site traffic.
- **A, B, C… tunnels** are additional or alternative paths. I use them for redundancy,
  testing, special routing behaviour, or future expansions.

This means:

S1 = HK1 ↔ UK1 primary data tunnel  
A1 = USA ↔ UK1 path, used for redundancy or routing experiments  
B1 = HK1 ↔ USA path, used for redundancy or routing experiments
C, D E....  = planned paths for future expansion.

All confs are stored in /etc/wireguard/, and also contains a simple .md serving as a quick reminder which link points where.
Although I do keep a separate reference diagram/map of all the links.

## 🔒 How I Handle Keys

I generate one private key per tunnel, not per host.

That means:

- Every .conf file is self-contained
- No private key is reused anywhere else
- If I need to rotate or revoke something, I only touch that specific tunnel

This reduces blast radius, avoids shared secrets, and keeps key rotation clean.
Although it seems that with wireguard I am unable to reuse keys for multiple tunnels anyway.
Second tunnel will error out if brought online after another tunnel using the same key.


## 📡 My WireGuard IP Scheme

All my WireGuard links use a simple, structured **/30 point-to-point** addressing model.

Each site-pair gets its own `/24` block under `10.255.0.0/16`, and every individual tunnel inside that block is assigned the next available `/30` (in steps of 4). This keeps things predictable and easy to document.

I assign host addresses based on **alphabetical order** of the site names:

- The alphabetically first site always gets the **lower** IP in the /30 (.1, .5, .9, …)
- The alphabetically second site gets the **higher** IP (.2, .6, .10, …)

Example layout:

- HK1 ↔ UK1 (S links) → 10.255.1.0/24
- UK1 ↔ USA (A links) → 10.255.2.0/24
- HK1 ↔ USA (B links) → 10.255.3.0/24
- HK1 ↔ HK2 (C links) → 10.255.4.0/24
- HK2 ↔ UK1 (D links) → 10.255.5.0/24
- HK2 ↔ USA (E links) → 10.255.6.0/24

Inside each `/24`, the first tunnel uses `.0/30` (hosts .1 and .2),
the second uses `.4/30`, the third `.8/30`, and so on:

10.255.X.0/30   → tunnel #1 (.1 ↔ .2)
10.255.X.4/30   → tunnel #2 (.5 ↔ .6)
10.255.X.8/30   → tunnel #3 (.9 ↔ .10)

This system gives every WireGuard link a dedicated, easily recognizable subnet and keeps the addressing consistent across the entire mesh.


## 🔀 How Routing Works in My Setup

WireGuard’s job is encryption and transport.

I handle all routing decisions with BIRD.

My design philosophy:

- WireGuard = tunnel
- BIRD = control plane
- Redundancy comes from advertising the same prefixes through multiple tunnels
- Failover is handled by BIRD metrics, not WireGuard tricks

This keeps the network flexible, clean, and scalable.
