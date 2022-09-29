# sep/29/2022 07:55:43 by RouterOS 7.5
# software id = RYKN-PKG2
#
/routing ospf instance
add disabled=no name=default router-id=10.10.1.2
add disabled=no name=ospf-instance-1 originate-default=always router-id=\
    OSPF_ID
/routing ospf area
add disabled=no instance=default name=backbone
add disabled=no instance=ospf-instance-1 name=Backbone
/routing ospf interface-template
add area=backbone disabled=no interfaces=br_loopback networks=10.10.1.0/24
add area=Backbone auth=md5 auth-key=12345678 disabled=no interfaces=ether1 \
    networks=10.10.10.0/30 type=ptp
