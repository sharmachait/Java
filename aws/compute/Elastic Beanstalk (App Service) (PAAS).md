## Environment
1. Web - for we apps
	1. creates an Auto Scaling Group (ASG)
	2. Elastic Load Balancer (ELB)
	3. Two Types of Web environments
		1. Load-Balanced (uses the ELB)
		2. Single-Instance (uses a public IP address)
			1. still uses an ASG but with capacity 1
2. worker - for background jobs
	1. creates an Auto Scaling Group (ASG)
	2. SQS queue
	3. installs the SQS Daemon on the EC2 instances
	4. creates CloudWatch Alarm to dynamically scale instances based on health
## Deployment Policies
![[Pasted image 20250719221149.png]]
#### All at once
- deploys new code to all the instances
- requires down time
- default one if none specified
- fastest method of deployment
#### Rolling
- Deploys new code to a batch of instances at a time
- then moves on to the next batch
#### Rolling with additional batch
- basically rolling but a new extra (green) batch is deployed before killing any blue batch
