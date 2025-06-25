requires a CIDR range like 10.0.0.0/16
this gives us 255 * 254 ip addresses*

in the subnet mask where ever we have 255 that will be the part of network id and wherer ever we have 0 that will be host id

in VPCs we can have subnets - defined set of ip ranges
we have a public subnet and a private subnet in our VPC
our VPC 10.0.0.0/16 can be divided into 10.0.0.0/17 and 10.0.128.0/17

the VPC is always within a region only
it can not span across regions

availability zones are within regions
a subnet can not span across availability zones

a subnet can only be part of one availability zone

we only interact with the VPC router using route tables

takes care of all routing going out of a subnet, maybe to another subnet or out to the internet

to be able to connect to the internet we also need an internet gateway to connect our VPC to the internet

we need to configure a route in the route table to direct the traffic to the internet gateway

A NAT gateway can connect your private-subnet EC2 to the internet (managed by AWS)

Security group is an instance-level firewall

NACL is a subnet level firewall

to make a subnet public the VPC needs to be connected to an [[internet gateway]]
and the subnet needs to have a route entry in its route table to the internet gateway

create a new route table for the each of the subnet, dont use the main one for the route to the internet gateway, all the route tables need to be associated with the respective subnets

in the route table for the public subnet add a route from 0.0.0.0/0 to the target internet gateway

only after this will we be able to connect to the EC2 instance

we need a way to reach out to the internet but not allow access to EC2
we can do that with a NAT gateway (Network Address Translation)

the NAT gateway must be created in the public subnet
and a route entry must be created in the public route table to point to the NAT gateway
going from 0.0.0.0/0 to the nat gateway
  
![[Pasted image 20250623182156.png]]