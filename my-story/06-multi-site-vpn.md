# 🏠 Turning Multiple Locations Into One Network

At this point, I had already figured out how to run OpenVPN server on Ubuntu.
I had done it for multiple sites like the noodle shop, my parents apartment in Hong Kong, and also at my house in the UK. 

It was mainly for secure access to CCTV NVR systems because they don't usually have secure streams. 
That and I'm a bit paranoid of sending video streams through to Annke/Hikvision servers.
I created VLANs that blocked WAN access for the NVR and other IOT devices.

But I didn't want to have to keep connecting each and every device to a particular site's VPN server in order to access services.
So I looked into how to create site-to-site VPNs to make them behave like  
one unified private network.

I wanted secured and shared access to:

- CCTV  
- NAS
- services  
- monitoring  
- backups  

The progression looked like:

1. **Basic OpenVPN L3 tunnel**  
2. **SoftEther L2 bridging**
   Initially a daisy chain between three sites,
   but a commercial VPS was added after as a more reliable central hub.
3. **Experiments with:**
   - adding extra SoftEther links between sites
     and using STP for failover (because it was L2).
   - using Linux bonding over two Softether TAP adapters
     as a means of redundancy as well.

This is where I began thinking like an infrastructure engineer.

---

## 👉 To Continue Reading  
➡️ **[07 – WireGuard + Dynamic Routing (BIRD/OSPF)](07-dynamic-routing.md)**

---

## 🔙 Back to Previous  
⬅️ **[05 – Cabling & CCTV](05-cabling-and-cctv.md)**
