# RivalChallenge

__Notes__:
1) Running Lambda Locally:  The idea is to use SAM CLI to test each lambda function. I have a mock template.yaml, and the idea is to run SAM CLI to invoke each lambda function to test.  For function#2, we can generate a mock event_file.json that has the S3 file event.  Unfortunately I couldn't get SAM to run properly on my current machine (My docker is throwing exceptions when I tried to invoke the lambdas).
2) CI/CD: This repo is hooked up to Circle CI.  I used terraform in this case to push to AWS.
3) The first function is supposed to be triggered through http (API gateway), second one is trigger with and S3 createobject event.  I didn't have enough time to test this live though.

__Learning/Challenges__:
1) I haven't fully incorporate CI/CD yet in my current work projects.  I rely mostly on Terraform, and since our projects are all one off for clients and with only 2 team members, we deploy test & deployment manually through make scripts.  Haven't yet automate all of these in a CI/CD system. CircleCI is new to me, so I have to spend some time learning CircleCI just now and created a pretty simple config script.  Overall I still say the CI/CD is still fairly new to me.
2) I didn't go with SAM CLI simply because I still don't like the speed of CloudFormation.  That said, knowing SAM has improved quite a lot the past year, I am going to review and see if its worth switch part of the setup from terraform to Cloudformation.  Again, SAM CLI isn't something I am super hands on just yet.  Our testing right now goes in our AWS Sandbox environment (or we simply run unit tests on our script functions on our local machines).

__Content Explaination__
1) .circleci:  Circle CI config file.
2) /lambda : This folder has 2 subfolder, each foldre represent a node.js lambda function package.  MAIN is first function (create files in S3), MAIN2 is second function (display file name created)
3) /terraform folder:  terraform script that creates all AWS resources.

Hopefully this gives you an idea on my skillset.  Definitely had some fun on this one!  

Thanks again!   
Phoebe  
