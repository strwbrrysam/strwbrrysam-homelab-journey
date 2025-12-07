# 1 — Link Inventory

This file lists all WireGuard tunnels in my homelab, including planned links for HK2.  
All WireGuard interfaces use /30 point-to-point addressing.  
IP ranges are grouped by link letter (S/A/B/C/D/E), and for each /30 the earlier site in the order  
**HK1 → HK2 → UK1 → USA** always receives the lower host address.

---

## HK1 ↔ UK1 (S Links — 10.255.1.0/24)

| Tunnel | Subnet           | HK1 IP          | UK1 IP          | Notes  |
|--------|------------------|-----------------|-----------------|--------|
| s1     | 10.255.1.0/30    | 10.255.1.1/30   | 10.255.1.2/30   | Active |
| s2     | 10.255.1.4/30    | 10.255.1.5/30   | 10.255.1.6/30   | Active |
| s3     | 10.255.1.8/30    | 10.255.1.9/30   | 10.255.1.10/30  | Active |

Reserved for future S links: `10.255.1.12/30`, `10.255.1.16/30`, etc.

---

## UK1 ↔ USA (A Links — 10.255.2.0/24)

| Tunnel | Subnet           | UK1 IP          | USA IP          | Notes  |
|--------|------------------|-----------------|-----------------|--------|
| a1     | 10.255.2.0/30    | 10.255.2.1/30   | 10.255.2.2/30   | Active |

Reserved for future A links: `10.255.2.4/30`, `10.255.2.8/30`, etc.

---

## HK1 ↔ USA (B Links — 10.255.3.0/24)

| Tunnel | Subnet           | HK1 IP          | USA IP          | Notes  |
|--------|------------------|-----------------|-----------------|--------|
| b1     | 10.255.3.0/30    | 10.255.3.1/30   | 10.255.3.2/30   | Active |

Reserved for future B links: `10.255.3.4/30`, `10.255.3.8/30`, etc.

---

## HK1 ↔ HK2 (C Links — 10.255.4.0/24)

| Tunnel | Subnet           | HK1 IP          | HK2 IP          | Notes   |
|--------|------------------|-----------------|-----------------|---------|
| c1     | 10.255.4.0/30    | 10.255.4.1/30   | 10.255.4.2/30   | Planned |

Reserved for future C links: `10.255.4.4/30`, `10.255.4.8/30`, etc.

---

## HK2 ↔ UK1 (D Links — 10.255.5.0/24)

| Tunnel | Subnet           | HK2 IP          | UK1 IP          | Notes   |
|--------|------------------|-----------------|-----------------|---------|
| d1     | 10.255.5.0/30    | 10.255.5.1/30   | 10.255.5.2/30   | Planned |

Reserved for future D links: `10.255.5.4/30`, `10.255.5.8/30`, etc.

---

## HK2 ↔ USA (E Links — 10.255.6.0/24)

| Tunnel | Subnet           | HK2 IP          | USA IP          | Notes   |
|--------|------------------|-----------------|-----------------|---------|
| e1     | 10.255.6.0/30    | 10.255.6.1/30   | 10.255.6.2/30   | Planned |

Reserved for future E links: `10.255.6.4/30`, `10.255.6.8/30`, etc.

---

## Addressing Rules

```text
Base: 10.255.0.0/16 reserved for WireGuard transport.

Per site-pair:
/24 blocks:
- HK1 ↔ UK1  → 10.255.1.0/24  (S links)
- UK1 ↔ USA  → 10.255.2.0/24  (A links)
- HK1 ↔ USA  → 10.255.3.0/24  (B links)
- HK1 ↔ HK2  → 10.255.4.0/24  (C links)
- HK2 ↔ UK1  → 10.255.5.0/24  (D links)
- HK2 ↔ USA  → 10.255.6.0/24  (E links)

/30 allocation inside each /24:
- Link #1: x.x.x.0/30   (hosts .1 and .2)
- Link #2: x.x.x.4/30   (hosts .5 and .6)
- Link #3: x.x.x.8/30   (hosts .9 and .10)
- and so on in steps of 4.

Site ordering for host assignment:
- For each tunnel, compare the two site names alphabetically.
- The alphabetically first site receives the lower host address (.1, .5, .9, …).
- The alphabetically second site receives the higher host address (.2, .6, .10, …).

I run OSPF over these /30 point-to-point links. WireGuard provides encryption and transport; BIRD/OSPF handles all routing decisions.
```

