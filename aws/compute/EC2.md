Auto assign public IP to make sure we are able to SSH to it
in Security Group allow ssh from Anywhere
it also needs to be on a public subnet

if we make our EC2 private we wont even be able to update our packages

we need a way to reach out to the internet but not allow access to EC2
we can do that with a NAT gateway (Network Address Translation)

the NAT gateway must be created in the public subnet
and a route entry must be created in the public route table to point to the NAT gateway
going from 0.0.0.0/0 to the nat gateway

each EC2 is associated with a security group
