# WireGuard Template Files — How to Use These Configs

This folder contains **sanitised example WireGuard configs** for my homelab mesh.  
They are safe to share publicly because all keys have been replaced with placeholders.

These files are meant to teach you:

- how my tunnel naming works  
- how WireGuard interfaces are created  
- how systemd automatically brings up tunnels based on filenames  
- how to convert a template into a real working configuration

---

## 📌 Why filenames matter (`wg-quick` + systemd)

WireGuard (via `wg-quick`) treats the **filename** as the **interface name**.

For example:

```
/etc/wireguard/s1.conf   →   interface name "s1"
/etc/wireguard/a1.conf   →   interface name "a1"
/etc/wireguard/b1.conf   →   interface name "b1"
```

This means:

```
sudo systemctl start wg-quick@s1
sudo systemctl enable wg-quick@s1
sudo wg show s1
```

All of these commands refer directly to the filename.

Because of this, in production I always keep filenames extremely simple:

```
s1.conf
s2.conf
s3.conf
a1.conf
b1.conf
```

This prevents mistakes and keeps commands predictable.

---

## 📄 Why templates use `.conf.example`

All example configs in this folder end with:

```
.conf.example
```

Example:

```
wg-s1-hk1.conf.example
wg-s1-uk1.conf.example
```

This makes two things clear:

1. **These files are not live configs.**  
2. You must rename them before systemd will recognise them.

---

## 🛠️ Converting a template into a real WireGuard tunnel

1. **Copy the template to your server**

```
cp wg-s1-hk1.conf.example /etc/wireguard/s1.conf
```

2. **Open the file and replace the placeholders:**

```
<HK1_S1_PRIVATE_KEY>
<UK1_S1_PUBLIC_KEY>
```

with real, freshly generated keys.

3. **Bring the tunnel up:**

```
sudo systemctl start wg-quick@s1
```

4. **Enable it so it automatically starts on reboot:**

```
sudo systemctl enable wg-quick@s1
```

That’s it — the filename becomes the interface name.

---

## 🔑 Reminder about key usage

Every WireGuard interface needs:

- **Your own private key** → `[Interface]`  
- **The peer’s public key** → `[Peer]`  

Private keys stay on their own device.  
Public keys are exchanged.

For a full explanation, see:

```
../5-key-concepts.md
```

---

## 📦 Template Files Included

- `wg-s1-hk1.conf.example` — HK1 side of S1 tunnel  
- `wg-s1-uk1.conf.example` — UK1 side of S1 tunnel  
- `wg-site-to-site.conf.example` — generic tunnel template

More templates can be added as the homelab grows.

---

If you want to build your own WireGuard mesh, these templates show:

- consistent IP addressing  
- consistent naming conventions  
- clear key-handling rules  
- how systemd wires everything together through filenames

Use them however you like.
