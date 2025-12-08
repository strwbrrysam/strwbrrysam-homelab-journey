# Samba Server Setup

## 🧠 Motivation
I needed a simple, reliable way to share files across my network with proper permissions and ACL control. 
Samba gave me Windows-friendly file sharing on my Linux NAS.

## 🏗 What I Built
- Samba server running on Linux  
- Shares mapped to ZFS datasets  
- ACL-based permission model  
- Guest access disabled, authenticated users only

## ⚙ Key Configuration
For config examples please check out the rest of this folder


## 🔍 Process
1. Installed Samba  
2. Created users + groups  
3. Mapped datasets to shares  
4. Adjusted ACLs for proper access  
5. Restarted service and tested from Windows

## 📚 What I Learned
- Samba respects filesystem ACLs  
- smb.conf structure  
- Mapping Linux permissions to Windows behaviour  
- How to map Network Drive in Windows using Command Prompt

## 🔮 Future Work
- Add SMB Multichannel  
- Improve performance tuning
