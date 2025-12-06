# ⚡ The Big Leap — WireGuard + Dynamic Routing

SoftEther served it's purpose. It was reliable, secure, and had a GUI for easy tweaks.
But for things like CCTV streams, and with long distance links between Hong Kong and the UK, it really wasn't ideal
because it was HTTP / TCP based. Even though it had UDP Acceleration, it still choked occasionally.

WireGuard changed everything for me: fast, simple, efficient.

But static routes didn’t scale.

So I moved into **dynamic routing** using BIRD and OSPF.

This was when everything clicked:

- automated failover  
- clean route convergence  
- no more manual static routes  
- proper multi-site architecture  

This was the first time my homelab felt like *real* infrastructure.

---

## 👉 To Continue Reading  
➡️ **[08 – Self-Hosting (Nextcloud, LAMP/LEMP)](08-self-hosting.md)**

---

## 🔙 Back to Previous  
⬅️ **[06 – Multi-Site VPNs](06-multi-site-vpn.md)**
