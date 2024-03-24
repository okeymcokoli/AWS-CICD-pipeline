# AWS-CICD-pipeline
Deploying AWS  CICD pipeline using Codepipline
Utilizing code-pile to deploy multi services on AWS
##Services that would be deployed includes:
Codecommit stored files for codepipeline buildspec_validate, buildspec_plan, buildspec_apply and buildspec_destroy (feel free to disable destroy on the console if you do not need it)
AWS Organizations from control tower landing Zone
Seerice Control Policies
IAM priviledges for Audit and Log Archieve Accounts
S3 for backend terraform statefile storage
Dynamodb for statefile locking
Cloudwatch for Security Hub config changes monitoring and notification (sns)
SNS and  Lambda functions (apply CRON JOB if needed)
Eventbridge
###update account id on each code to suite your project.
