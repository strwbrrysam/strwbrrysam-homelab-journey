# 🎓 Learning Outcomes

Through setting up Samba, configuring ACLs, and testing behaviour across different environments, I learned several important technical concepts:

---

## 1. Samba + Filesystem Permissions
- Samba **fully respects underlying filesystem ACLs**, so correct Linux-side permissions are essential.
- Using tools like `setfacl` and `getfacl` helped me understand how Unix ACLs translate into Windows-style permissions.
- Enabling `acl_xattr` and proper inheritance allowed Windows clients to manage permissions through the Security tab.

---

## 2. smb.conf Structure & Behaviour
- I learned how Samba separates configuration into:
  - **[global]** – server-wide behaviour  
  - **[share] blocks** – per-share access rules, permissions, VFS modules
- Understanding masks, ACL inheritance, and DOS attributes helped me match Windows behaviour more predictably.

---

## 3. Mapping Linux Permissions to Windows Clients
- Group ownership (e.g., `root:services`) and ACL inheritance were key to making access consistent across users.
- I learned how Linux permissions, ACLs, and Samba translation layers interact when viewed from a Windows machine.

---

## 4. Mapping Network Drives via Command Prompt
- I learned to reliably map drives using Windows CMD, which avoids GUI caching issues:

      net use V: \\SERVER-IP\vault /user:sam Password123 /persistent:yes

- `/persistent:yes` ensures reconnection on reboot, and `/user:` allows specifying Samba credentials separately from the Windows login session.

---

## 5. Samba Limitations Over WAN / High Latency
- SMB is a **chatty protocol**, and performance collapses when latency increases.
- This explains slow speeds when accessing Samba shares over long-distance or encrypted tunnels like WireGuard.

---

## 6. Multichannel Limitations
- Multichannel improves throughput only for **multiple simultaneous operations** or **multiple clients**.
- A **single file transfer** cannot exceed the bandwidth of one stream, even with multiple NICs.
- Useful for concurrency, not for boosting one large file copy.

---

# ✅ Summary

Overall, this project taught me how Samba integrates with Linux permissions, how Windows interacts with ACLs, how to manage shares cleanly, and where the protocol’s performance limits appear in real-world use.
