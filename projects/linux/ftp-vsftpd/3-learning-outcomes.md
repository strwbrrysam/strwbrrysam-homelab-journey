# 3 — Learning Outcomes (vsftpd)

This section reflects what I learned while integrating vsftpd into my ACL-driven ZFS environment and adapting it for high-latency remote access over VPN.

---

## 1. FTP Performs Better Than SMB Over High Latency

Samba’s performance collapses when latency increases due to SMB’s chatty nature.  
vsftpd, by contrast, handled VPN-based remote access much more smoothly.

This made FTP a practical solution for:
- remote clients  
- long-distance WireGuard links  
- simple file retrieval and upload  

---

## 2. vsftpd Works Cleanly With ZFS ACLs

I learned that:
- vsftpd does not override filesystem rules  
- ZFS ACLs fully determine visibility and write access  
- no extra vsftpd per-directory permissions are needed  

This matched my broader homelab pattern:  
**All access protocols layer on top of one ACL-secured dataset (`/zpool/vault`).**

I didn’t need per-user home folders at all — just proper ACL inheritance.

---

## 3. PAM Authentication Fits My Access Model

Since I already use PAM-authenticated system users for Samba and other services, vsftpd dropped in naturally.

Key takeaway:
- authentication should be centralized  
- authorisation should be done at the filesystem layer (ZFS ACLs)

This keeps everything consistent and predictable.

---

## 4. Chrooting Users Over a Shared Dataset Works Fine

I initially assumed chrooting required unique home directories, but actually:

- a shared, ACL-controlled directory works perfectly  
- `allow_writeable_chroot=YES` is the only required adjustment  
- users remain isolated inside the dataset  
- escaping is impossible due to chroot + ACL boundaries

---

## 5. Services Should Be VPN-Only Whenever Possible

Running vsftpd internally meant:
- no need for TLS initially  
- no passive port range  
- simpler configuration files  
- reduced attack surface  

This reinforced a general rule I follow:
**Expose nothing publicly unless absolutely required.**

---

## 6. FTP Still Has a Place in a Modern Homelab

Even though FTP is old, it has advantages:
- simpler than SMB  
- faster over latency  
- easier to debug  
- great for quick drop-access workflows  

For anything sensitive, I still rely on:
- Samba (LAN only)  
- SFTP  
- Nextcloud  
- rsync / rclone  

But FTP remains a useful tool for lower-importance remote workflows.

---

## Summary

This project taught me how:
- protocol behaviour changes over high latency  
- vsftpd integrates gracefully with ZFS ACLs  
- PAM keeps authentication simple  
- chroot can be applied to a shared dataset  
- VPN-only exposure drastically simplifies service design  

vsftpd became a lightweight, predictable, and well-integrated component of my homelab storage ecosystem.
