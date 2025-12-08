# 2 — vsftpd Setup

This file documents how I deployed vsftpd as a lightweight, VPN-only FTP service integrated with my ZFS ACL model.  
Users authenticate via PAM and are chrooted directly into the central dataset at `/zpool/vault` rather than traditional home directories.

---

## 1. Install vsftpd

sudo apt update
sudo apt install -y vsftpd

Check that the service installed correctly:

systemctl status vsftpd

---

## 2. Configuration Reference

For all configuration files, please check:

/ftp-vsftpd/configs/

This keeps the setup documentation clean and places the actual config files in one dedicated location.

---

## 3. User Management (PAM-backed)

vsftpd uses PAM, so users are standard Linux accounts.

Create a system user without a login shell:

sudo useradd -M -s /usr/sbin/nologin ftpuser1
sudo passwd ftpuser1

All users authenticate via PAM and then land inside `/zpool/vault`.

---

## 4. Binding Users Into the ZFS Dataset

Instead of creating home folders under `/home/*`, I point every FTP user directly into my shared ZFS-backed dataset:

sudo usermod -d /zpool/vault ftpuser1

Access control is entirely handled by ZFS ACLs.

Example ACL:

setfacl -m u:ftpuser1:rwx /zpool/vault/somefolder
setfacl -m d:u:ftpuser1:rwx /zpool/vault/somefolder

Check ACLs:

getfacl /zpool/vault/somefolder

No vsftpd-specific permission rules are required — the filesystem determines allowed actions.

---

## 5. Chroot Behaviour

Because the config uses chrooting:

- users cannot escape `/zpool/vault`
- directory traversal is restricted
- only ACL-permitted subdirectories are visible

This makes FTP access predictable and secure, even without individual home directories.

---

## 6. VPN-Only Exposure

vsftpd is never exposed publicly.

All connections occur over WireGuard tunnels which already provide:
- encryption
- authentication
- isolation  

As a result, no TLS or passive port configuration was required at this stage.

---

## 7. Testing

### CLI:
ftp SERVER-IP

or with lftp:

lftp ftp://ftpuser1@SERVER-IP

### FileZilla:
- Host: ftp://SERVER-IP  
- User: ftpuser1  
- Starting directory: `/zpool/vault`  

Test:
- upload/download operations  
- directory visibility  
- ensuring the user cannot escape the chroot directory  

---

## 8. Future Expansion

- Optional TLS  
- Passive port ranges for certain clients  
- More granular ACL structures inside `/zpool/vault`

The core setup stays intentionally minimal while leaving room to grow.
