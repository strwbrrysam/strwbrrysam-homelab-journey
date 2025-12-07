# 🔑 OpenVPN Addressing

Each CORE node also runs OpenVPN services for remote access or internal control-plane functions. 

## HK1 OpenVPN Subnets
- 10.192.1.0/24
- 10.192.2.0/24

## HK2 OpenVPN Subnets
- 10.193.1.0/24
- 10.193.2.0/24

## UK1 OpenVPN Subnets
- 10.194.1.0/24
- 10.194.2.0/24

## USA VPS OpenVPN Subnets
- 10.207.1.0/24
- 10.207.2.0/24

These subnets are advertised into BIRD OSPF from the node that owns them.
