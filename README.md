# AWS-CICD-pipeline
#Author: Okey McOkoli
#Version: v1
#Date: 3/25/24
######################
Deploying AWS  CICD pipeline using Codepipline
Utilizing code-pile to deploy multi services on AWS
#######################################################################################
##Services that would be deployed includes:
1. Codecommit stored files for codepipeline buildspec_validate, buildspec_plan, buildspec_apply and buildspec_destroy (feel free to disable destroy on the console if you do not need it)
2. AWS Organizations from control tower landing Zone
3. Seerice Control Policies
4. IAM priviledges for Audit and Log Archieve Accounts
5. S3 for backend terraform statefile storage
6. Dynamodb for statefile locking
7. Cloudwatch for Security Hub config changes monitoring and notification (sns)
8. SNS and  Lambda functions (apply CRON JOB if needed)
9. Eventbridge
###update account id on each code to suite your project.

########################################################################################
