# 📡 Namecheap + ddclient Configuration Guide

This guide explains how to configure **ddclient** to update Dynamic DNS records for a domain hosted on **Namecheap**.

---

## 1. Namecheap Setup

1. Go to **Domain List → Manage** on your chosen domain.  
2. Under the **Domain** tab, remove any existing entries in **Redirect Domain**.  
3. Open the **Advanced DNS** tab:
   - Enable **Dynamic DNS** and note the generated password.
   - Add a new **A Record**:
     - **Host:** `@`  
     - **Value:** `127.0.0.1`  
     *(ddclient will overwrite this with your real IP.)*

---

## 2. Install ddclient

```bash
sudo apt-get install ddclient libio-socket-ssl-perl
```

(Provide any values when prompted by the TUI; they will be overwritten.)

---

## 3. Configure ddclient

Edit `/etc/ddclient.conf`:

```conf
ssl=yes
use=web, web=dynamicdns.park-your-domain.com/getip
protocol=namecheap
server=dynamicdns.park-your-domain.com
login=YOURDOMAIN.COM
password='YOUR-DYNAMIC-DNS-PASSWORD'
YOURHOST
```

- `login` = your full domain (e.g., `example.com`)  
- `YOURHOST` = the host you want to update (e.g., `@`, `home`, etc.)

---

## 4. Test the Configuration

```bash
sudo ddclient -query
sudo ddclient -debug -verbose -noquiet
```

---

## 5. Restart ddclient

```bash
sudo service ddclient restart
```

---

Done! ddclient will now automatically update your Namecheap DNS record whenever your public IP changes.
