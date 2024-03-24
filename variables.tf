
variable "region" {
    type = string
    default = "us-east-1"
description = "region"
}

variable "backend-dynamodb-name" {
  type = string
  default = "remote-terraform-state-lock"
}

variable "backend-s3-name" {
  type = string
  default = "coolfmremotestatedev2024"
}

variable "enabled" {
  type = bool
  default = false
}

#delegating guardduty
variable "account_admin_id" {
  description = "Delegated account ie Audit account number"
  default = "123456789012"
}

variable "logging_acc_s3_bucket_name" {
  description = "Name of S3 bucket to store logs in the logging account"
  type        = string
  default     = "coolfmremotestatedev2024"
}

variable "audit_account_role_arn" {
  description = "audit account role arn"
  type        = string
  default     = "arn:aws:iam::123456789012:role/cross-account-audit-CP"
}

variable "log_archive_account_role_arn" {
  description = "log archive account role arn"
  type        = string
  default     = "arn:aws:iam::123456789012:role/cross-account-okey"
}


variable "currentaccount_id" {
  description = "current account account role arn"
  type        = string
  default     = "123456789012"
}


variable "gdkey_alias" {
  description = "guardduty KMS key alias"
  default     = "alias/guarddutykey"
}

#SNS subscription variable
variable "sns_name" {
        description = "Name of the SNS Topic to be created"
        default = "my_first_sns"
}

variable "account_id" {
        description = "My Accout Number"
        default = "123456789012"
}

#SNS subscription variable for audit account lambda
variable "audit_sns_name" {
        description = "Name of the SNS Topic to be created"
        default = "audit_sns"
}

variable "audit_account_id" {
        description = "My Accout Number"
        default = "123456789012"
}
#For SG
variable "sg_name" {
  description = "My ec2 security group name"
  default = "sg-okey-ec2"
}

variable "ingress_rules" {
  default = [{
       from_port   = 443
       to_port     = 443
       description = "Port 443"
   },
   {
       from_port   = 80
       to_port     = 80
       description = "Port 80"
   }]
}