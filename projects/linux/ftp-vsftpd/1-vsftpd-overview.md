# 1 — vsftpd Overview

## 🧠 Motivation

I originally set up vsftpd as a simple, lightweight FTP service for situations where Samba performance was unusable over high-latency links.  
Some remote clients needed quick access to files, and FTP (despite being old) performs far better than SMB when latency is high.

Since all of my homelab services sit behind VPN-only access, I did not need a hardened public-facing configuration — just something stable, predictable, and fast for internal use.

---

## 🏗 What I Built

- A minimal vsftpd service running on Linux  
- Authentication handled via PAM (standard system users)  
- Users do not use traditional home directories  
- Instead, every user is mapped into my centralized ZFS dataset at `/zpool/vault`  
- Access is controlled entirely by ZFS ACLs  
- Users are chrooted to prevent directory escape  
- No anonymous access  
- No external encryption layer (VPN already provides secure transport)

The goal was simplicity: a fast, predictable FTP endpoint for remote VPN-connected clients.

---

## 🔐 Security Model

Although vsftpd is often used for public FTP, my setup is strictly internal:

- Accessible only over WireGuard tunnels  
- No direct internet exposure  
- PAM authentication ensures credentials are system-controlled  
- ZFS ACLs determine exactly what each user can see or modify  
- Users are jailed into `/zpool/vault` to maintain isolation

This aligns vsftpd with the rest of my permission model, where ZFS and ACLs act as the single source of truth.

---

## 🗂 Integration With My Storage System

vsftpd is just one of several protocols that sit on top of the same ZFS-backed storage layer.  
All access — Samba, Nextcloud, FTP, SCP, and internal services — ultimately relies on `/zpool/vault`.

ZFS handles:

- ACL inheritance  
- Permissions  
- Dataset structure  
- Reliability and consistency  

Because of this, I don’t create separate FTP “home directories”.  
Instead, users are placed directly inside the ACL-managed folder tree where permissions are already enforced.

---

## 🧩 Where vsftpd Fits in My Homelab

vsftpd fills a very specific need:

- Reliable performance over high-latency connections  
- Much faster than Samba for WAN/VPN-based file access  
- Easy to maintain and debug  
- Works cleanly with existing ACL and PAM models  
- Lightweight and predictable behaviour  

It is not intended to replace Samba or SFTP — it’s a complementary protocol optimized for situations where SMB struggles.

---

## 🔮 Future Improvements

- Enabling TLS (optional, since VPN already encrypts traffic)  
- Defining a passive port range if a client requires it  
- Creating more refined ACL structures within `/zpool/vault`

The setup remains intentionally minimal, scaling only if the use case expands.
