#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server

# Networking Information Here
bridge="br0"
eth="eth0"
aLines="uk1"
bLines="core"
cLines="b4"

DAEMON=/etc/softether/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
sleep 10

### START SEQUENCE START ###
# add virtual tap interfaces to the brige

for a in $aLines; do
        brctl addif $bridge tap_$a
        ip addr flush dev tap_$a
        ip link set tap_$a promisc on up
        brctl setpathcost $bridge tap_$a 100
done

for b in $bLines; do
        brctl addif $bridge tap_$b
        ip addr flush dev tap_$b
        ip link set tap_$b promisc on up
        brctl setpathcost $bridge tap_$b 1000
done

for c in $cLines; do
        brctl addif $bridge tap_$c
        ip addr flush dev tap_$c
        ip link set tap_$c promisc on up
        brctl setpathcost $bridge tap_$c 5000
done

# DELETE ANY EXTRA GATEWAYS IF NEEDED
#ip route delete default via 10.68.6.1
brctl setbridgeprio br0 0

;;
stop)

### STOP sequence begin ###
for a in $aLines; do
        ip link set tap_$a down
        brctl delif $bridge tap_$a
done

for b in $bLines; do
        ip link set tap_$b down
        brctl delif $bridge tap_$b
done

for c in $cLines; do
        ip link set tap_$c down
        brctl delif $bridge tap_$c
done
### STOP sequence end ###

$DAEMON stop
rm $LOCK
;;
restart)

### STOP sequence begin ###
for a in $aLines; do
        ip link set tap_$a down
        brctl delif $bridge tap_$a
done

for b in $bLines; do
        ip link set tap_$b down
        brctl delif $bridge tap_$b
done

for c in $cLines; do
        ip link set tap_$c down
        brctl delif $bridge tap_$c
done
### STOP sequence end ###

$DAEMON stop
sleep 5
$DAEMON start
sleep 5

### START SEQUENCE START ###
# add virtual tap interfaces to the brige

for a in $aLines; do
        brctl addif $bridge tap_$a
        ip addr flush dev tap_$a
        ip link set tap_$a promisc on up
        brctl setpathcost $bridge tap_$a 100
done

for b in $bLines; do
        brctl addif $bridge tap_$b
        ip addr flush dev tap_$b
        ip link set tap_$b promisc on up
        brctl setpathcost $bridge tap_$b 1000
done

for c in $cLines; do
        brctl addif $bridge tap_$c
        ip addr flush dev tap_$c
        ip link set tap_$c promisc on up
        brctl setpathcost $bridge tap_$c 5000
done

# DELETE ANY EXTRA GATEWAYS IF NEEDED
#ip route delete default via 10.68.6.1
brctl setbridgeprio br0 0

;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0
