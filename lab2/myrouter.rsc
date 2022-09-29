# sep/29/2022 07:53:58 by RouterOS 7.5
# software id = RYKN-PKG2
#
/interface bridge
add name=Loopback
add name=br_loopback
/interface ethernet
set [ find default-name=ether1 ] advertise=\
    10M-half,10M-full,100M-half,100M-full disable-running-check=no speed=\
    100Mbps
/interface wireguard
add listen-port=41194 mtu=1420 name=wireguard1
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing id
add disabled=no id=172.16.0.1 name=OSPF_ID
add disabled=no id=172.16.0.1 name=OSPF_ID select-dynamic-id=""
add disabled=no id=172.16.0.1 name=OSPF_ID select-dynamic-id=""
/routing ospf instance
add disabled=no name=default router-id=10.10.1.2
add disabled=no name=ospf-instance-1 originate-default=always router-id=\
    OSPF_ID
/routing ospf area
add disabled=no instance=default name=backbone
add disabled=no instance=ospf-instance-1 name=Backbone
/routing table
add disabled=no fib name=wg-mark
/interface list member
add interface=br_loopback
/interface wireguard peers
add allowed-address=192.168.6.0/24 endpoint-address=51.250.5.32 \
    endpoint-port=41194 interface=wireguard1 public-key=\
    "vD0ApmwW69Qx48oLTBEvk5ows4fMec3GEPxwSw9BrTY="
/ip address
add address=192.168.6.68/24 interface=wireguard1 network=192.168.6.0
add address=10.10.1.3/24 interface=br_loopback network=10.10.1.0
add address=172.16.100.1/24 interface=ether1 network=172.16.100.0
add address=172.16.0.1 interface=Loopback network=172.16.0.1
add address=10.10.10.1/30 interface=ether1 network=10.10.10.0
/ip dhcp-client
add add-default-route=special-classless default-route-distance=2 interface=\
    ether1
/ip firewall address-list
add address=192.168.88.0/24 list=full_wg
/ip firewall mangle
add action=mark-routing chain=prerouting new-routing-mark=wg-mark \
    passthrough=no src-address-list=full_wg
/ip firewall nat
add action=masquerade chain=srcnat out-interface=wireguard1
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=wireguard1 \
    routing-table=wg-mark suppress-hw-offload=no
/routing ospf interface-template
add area=backbone disabled=no interfaces=br_loopback networks=10.10.1.0/24
add area=Backbone auth=md5 auth-key=12345678 disabled=no interfaces=ether1 \
    networks=10.10.10.0/30 type=ptp
/system identity
set name=R_1
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.ru.pool.ntp.org
