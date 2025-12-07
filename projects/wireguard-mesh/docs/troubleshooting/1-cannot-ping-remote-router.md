# Troubleshooting — Cannot Ping Remote Site Router

## Symptoms

- Can ping remote **servers**, but NOT the **remote router**
- Traceroute stops at the remote site router (10.188.X.1)
- Remote router receives packets but does not return them
- WireGuard tunnels appear healthy

## Cause (Summary)

WireGuard uses `/30` point-to-point transit networks (10.255.X.0/30).  
Edge routers **do not know these networks exist**.

They receive traffic from the mesh, but cannot return it.

## Quick Fix

Add static routes on the **edge router (10.188.X.1)** of the affected site.

Example:

```bash
ip route replace 10.255.1.0/30 via 10.188.X.10
ip route replace 10.255.2.0/30 via 10.188.X.10
ip route replace 10.255.3.0/30 via 10.188.X.10
ip route replace 10.255.4.0/30 via 10.188.X.10
ip route replace 10.255.5.0/30 via 10.188.X.10
ip route replace 10.255.6.0/30 via 10.188.X.10
```

but in this case it can also be summarized to:

```bash
ip route replace 10.255.0.0/16 via 10.188.X.10
```

Where:

- `10.188.X.1` = edge router  
- `10.188.X.10` = CORE server of that site  

## Verification

After adding routes:

```bash
ping 10.188.X.1
traceroute 10.188.X.1
```

If return path works, routing is fixed.

## Permanent Location

See full explanation in:  
➡️ `/docs/architecture/6-routing-quirks.md`
