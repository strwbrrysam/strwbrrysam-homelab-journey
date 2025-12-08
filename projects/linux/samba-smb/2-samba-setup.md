# 🔍 Process — Detailed Walkthrough With Example Commands

## 1. Install Samba
# Update package list and install Samba + tools
sudo apt update
sudo apt install samba samba-common-bin -y

# Verify installation
smbd --version


## 2. Create Users + Groups
# Create the main group that will own your datasets (example: "services")
sudo groupadd services

# Create a Unix user that will access Samba
sudo useradd -m -G services sam
sudo passwd sam

# Add the same user to Samba's internal password database
sudo smbpasswd -a sam
sudo smbpasswd -e sam   # enable account


## 3. Map Datasets to Shares
# Ensure directories exist
sudo mkdir -p /zpool/vault

# Assign group ownership so Samba users share access
sudo chown -R root:services /zpool/vault

# Set base permissions (ACLs will refine this later)
sudo chmod -R 770 /zpool/vault


## 4. Adjust ACLs for Proper Access
# Give the 'services' group full control
sudo setfacl -R -m g:services:rwx /zpool/vault

# Ensure new files inherit ACLs
sudo setfacl -R -m d:g:services:rwx /zpool/vault

# Confirm ACL structure
getfacl /zpool/vault


## 5. Add Samba Share Definition
# Edit Samba config
sudo nano /etc/samba/smb.conf

# (Insert your cleaned-up share block here)


## 6. Restart Samba & Apply Changes
sudo systemctl restart smbd
sudo systemctl restart nmbd

# Check status
systemctl status smbd


## 7. Test Connectivity from Linux
# Check share visibility
smbclient -L //localhost/vault -U sam

# Connect to the share interactively
smbclient //localhost/vault -U sam


# 🖥️ Point 8 — Mapping a Network Drive from Windows CMD

## 1. Open Command Prompt
Press **Win + R**, type **cmd**, press **Enter**.

---

## 2. Map the network drive using `net use`
Use the format:

net use <DriveLetter>: \\<SERVER-IP>\<SHARE> <password> /user:<username> /persistent:yes

### Example:
# Map drive V: to the Samba share "vault"
net use V: \\192.168.1.10\vault MyPassword123 /user:sam /persistent:yes

---

## 3. Remove an existing mapping (if needed)
net use V: /delete /y

---

## 4. Verify mapped drives
net use

# You should now see drive V: listed as "OK"

# Verify:
# - Can browse directory
# - File creation/deletion works
# - ACLs behave correctly (Windows properties → Security tab)


## 9. Optional: Troubleshooting Commands
# Check Samba logs
sudo journalctl -u smbd -f

# Test configuration syntax
testparm

# See active connections
sudo smbstatus
