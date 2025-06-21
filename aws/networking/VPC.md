Virtual private Network

requires a CIDR range like 10.0.0.0/16
this gives us 255 * 254 ip addresses*

in VPCs we can have subnets - defined set of ip ranges
we have a public subnet and a private subnet in our VPC
our VPC 10.0.0.0/16 can be divided into 10.0.0.0/17 and 10.0.128.0/17

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
![[Pasted image 20250620212516.png]]