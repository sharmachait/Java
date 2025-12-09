- Global service
- we can create users and groups, the root account is stored in the IAM as well
- groups can only contain users and not other groups
- users dont need to belong to a group
- users can belong to multiple groups
- we can assign users and groups policies/permissions using simple json format
![[Pasted image 20251114004139.png]]
![[Pasted image 20251114010749.png]]
- the ID and the Sid are optional
- the principal tells us which account or group should the policy be applied to
- we can also add conditions optionally

- instead of root user we should create Admin accounts
- in the IAM we can create an account alias so that the sign in URL (for non root users) becomes pretty
![[Pasted image 20251114005232.png]]
- to login as a non root user, you either need the account ID or the account alias
- if we go into policies section and open a policy we can see it is defined
![[Pasted image 20251114090709.png]]
- the Admin Access Policy all0ws all resources and all actions on them
- we can create out own policies by choosing the service the resource and the action
![[Pasted image 20251114092818.png]]
### password policy
- we can create password policies for users
	- minimum password length
	- specific character types, upper case lower case letters, numbers , special characters
	- password expiration
	- allow users to change their passwords
- We can setup MFA for users
- we can set password policies from account settings
![[Pasted image 20251114094513.png]]
to setup MFA go to user> security credentials
### Roles
- like service accounts to be used by aws services
- a service assumes a role temporarily to do something on aws
- if we want lambda do something on aws then the lambda should assume the role with
- common roles
	- EC2
	- Lambda
	- Cloud-formation
- roles are accessible under access management on the IAM page
- there are 5 types of roles we can create
![[Pasted image 20251115204921.png]]
- most commonly used is the AWS service role
- when creating a role we can select the service we want to create the role for
- then we need to choose a policy for the Role
### Credentials report
account level report that contains all users and status of their credentials
we can generate credential report from IAM dashboard under access reports
### Access Advisor / Last Accessed
shows service permissions granted to a user and when they accessed those services
this can be used to remove permissions that are not being used by someone
can be accessed under each user > Last Accessed
## Shared Responsibility Model
![[Pasted image 20251116143210.png]]