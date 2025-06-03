## Why Amazon
amazon top innovator, with its products and how they are delivered , 
i want to work for an organization that constantly Moving forward, 
i love coding i do it my free time, i even have a youtube channel with content on how to build your redis form scratch in java
and so i want to be able to utilize those talents over at large projects, enterprise grade solutions that other people rely on
I love some leader ship principles like you guy tell us to Have Backbone; Disagree and Commit and have Bias for Action. 
so stuff like that i feel resonates well with 
you guys clearly nurture an environment to be creative and innovative, especially with how important the leader ship principles are , so i would love an opportunity to work in that environment

it would be great to have a fulfilling role in a reputable company that provides a service to the local and wider community

## Tell me about a time you had to work in a team

crowdstrike compliance issues. multiple issues that needed to be fixed, so it was a team of 4 people reportng to a fifth VP
at first my manager delegated the work to each individual person and asked us to do some exploratory analysis.
by the end of the week we would try to implement those solutions on the DEV environment to minimize development and testing issues.
we broke dev. none of the schema migrators were working and none of the frontend apps were working
it turned out that our solution worked in silos but not together, we immediately rolled back our changes and took the weekend to analyze what we were doing wrong, as it so happened my team mates solution interfered with mine and mine interfered with my managers and so on.
ultimately we had pool our solutions together find ways to ties them together handle each others requirement in our individual solutions 

for example my team mate was tasked with dropping all security context capabilities but that interfered with frontend apps because they were hosted on nginx which requires chown and chomod. and i was required to make root file ssytem hosted in read only mode for all pods, but that interfered with schema migrators because we were creating ~/.pgpass file on runtime and that required write permissions, my manager was working on removing setuid and setgid permissions for each non root user of the pod and privilege escalation bits of binaries but that again interfered with nginx pods,

## The most difficult situation of your life and how did you overcome it.
nginx non root user and read only root filesystem mounting
required me to learn about linux in depth because we needed the binaries to be able to bind to privileged ports, solved via authbind. and i learned a lot about nginx entrypoint because when we did read only root file system i saw errors related to MKDIR CHOWN CHMOD SETUID SETGID so i had to go to the official nginx github and read through the entrypoint shell script to figure out what all would be required to solve the problem

## Have you been ever put into a situation where you and to make an important decision without asking or consulting your manager/TL? 
we were under strict instructions from our VP to stop doing manual deployments, but when our CICD solution faced an unforseen issue, i made the decision to deploy to production manually because we were under a strict timeline because a job was about to trigger into execution and it needed to send out data from the latest POWER bi reports

the unforseen issue being the file that the power bi pipeline was supposed to promote to the prod environment was edited manually in test by the development team as they had the access and power bi only considers promotion of files that have been promoted from lower environments if there is git integration enabled

we had to setup a process to allow developers to commit the changes to source control as well if they make any changes,
that way the workspace and Git stay in sync
## How to handle extreme work pressure?
team work
## what about a time you had to influence a group of people to reach a goal
migrate-mongo
rdl reports in house tool for deployment because the Billing team needed autonomy form the release and change managemnt process
the fact that i was the one who had worked primarily on the CICD solution for deployments via APIs helped a lot because i had  already gained some trust among the team members
the issue with the CICD solution was that the datasources were not named consistently across the environments
so if were using a config file for deployments to lower test environments the same could not be used for deployments to prod.
the billing team needed autonomy from that, they didnt want the deployment config to managed separately for different environments
i was the one who identified this problem when there was a hotfix deployment in the queue, so that led to my credibility other wise the deployment would have failed in the deployment window
so i proposed a very simple web based tool that could be built inhouse which would deploy the rdl reports using the APIs 
the reason we could not use the microsoft provided GUI was the billing team needed to be able to change datasources for reports as per requirements, so the edit access would also permit them to see the passwords in the connection strings, which the info sec team didnt want, since only the name of the datasource was required to change the datasource using an api i was able to build a simple drop down select the datasource that should be used in the in-house tool to configure data sources.
with this new solution and a working prototype for the same I was able to convince the Billing team representatives to use this approach whenever the needed to update reports
## what is growth for you, how you would you quantify you are growing in this organization
ownership
accountability
proactive 
Customer Obsession
Team player

## Weak ness
0-100
solution team player

## Did you have a conflict with your manager in the past, how did you resolve it

### Earn trust

We were assigned to set up distributed load testing infrastructure Using K6 operator.
K6 operator allows us to schedule cron jobs to run pods in a distributed fashion across nodes as long as all the nodes dont have a taint on them.
but the pod needs to have have a .js script to run, it can take it as a config map

but we also had an option to be able to mount the script via a persistent volume.

which is what i suggested. but my manager did not agree with that approach. he wanted the test scripts t0 be the build artifacts of some build pipeline.

which did not seem right to me because i had gone through the documentation and no where did it say we needed a build step, basically the image that they use was able to run the .js file like we would on our local system with node index.js

so i told him that we did not need the build pipeline to build the artifacts, but he did not agree,  he was occupied with some other work as well

so i made a full change management process diagram and set up a one to one call with him and showed him the entire plan i had in mind, so i used build pipelines as well but it was only being used to update the Persistent Volume
maybe i cn show you 

## Where do you see yourself in 5 years
i Love coding, i do it in my free time, i like building stuff from scratch, all in all my entire life revolves around software engineering and i love it. so in the next 5 years i want to be a better engineer. i love to build things like redis from scratch in java. so i want to be able to contribute to projects like that, low level stuff in the amazon tech ecosystem if opportunity presents itself.
i would consider it a privilege, to contribute to the tech at amazon, hands on large projects.

## Most challenging project that your worked on
crowdstrike compliance
## Most enjoyable project
k6 operator
## Hardest problem ever solved
nginx readonly
## Did you miss a deadline if yes how did you handle it
**Sonar docker pipeline no comments " Yes, I have missed a deadline once. Early in my career, I underestimated the time required for a project because I didn’t account for some unexpected technical challenges. As soon as I realized I might not make the deadline, I immediately informed my manager and the team, explained the situation, and proposed a revised timeline. I also prioritized my tasks and worked overtime to minimize the delay. In the end, the project was only a day late, and my manager appreciated my transparency and proactive communication. Since then, I’ve become much better at estimating timelines and always build in a buffer for unexpected issues."**

## Which Amazon leadership principle do you resonate most with?
have a backbone disagree and commit
## What do you think the seventeenth principle should be?
nurture a caring meritocracy 
## How do you resonate with the principle, _'Are right, a lot'_?"
so are right a lot is not about that their decision is final, instead it means that their subordinates believe in their decision making and they also do, as most of their decisions are not out of ay whim but out of good judgement and have tried their beliefs and acted as the devils advocate
## Tell me about an out-of-the-box idea you had or decision you made that had a big impact on the business.
rdl reports in house tool
## Tell me about the toughest decision you had to make in the past 6 months?
Took responsibility of all the DevOps stuff
## Tell me about a time you took a calculated risk.
Sonar Qube integration commitment
## When were you able to remove a serious roadblock preventing your team from making progress.
Postgres migration permission script failed as we were granting postgres role to users, but that is no longer supported in postgres 16, so i fixed that, i granted read create update and then created schema level functions to drop tables and database and granted execute permissions
## When did you make a mistake?
sonar
## Tell me about a goal you failed to achieve.
sonar
## Tell me about a time you had an unhappy customer. What was the problem? What did you do to address it? What was their reaction?
power bi workspace ci
## difficult interaction wiht a customer
## When did you get some negative feedback?
sonar