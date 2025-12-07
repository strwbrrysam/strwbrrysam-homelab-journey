# 🧭 LAN Addressing Scheme

Every physical site uses a consistent addressing structure:
- Router = .1
- CORE server = .10
- LAN subnet = 10.188.X.0/24 (X = 10, 20, 30)

## LAN Subnets
- HK1: 10.188.10.0/24
- HK2: 10.188.20.0/24
- UK1: 10.188.30.0/24

## CORE Node IPs
- CORE-HK1: 10.188.10.10
- CORE-HK2: 10.188.20.10
- CORE-UK1: 10.188.30.10

## Router IPs
- HK1-Router: 10.188.10.1
- HK2-Router: 10.188.20.1
- UK1-Router: 10.188.30.1

Routers remain simple gateways and do not participate in the WireGuard mesh or OSPF routing.
