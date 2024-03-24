#Resources to be  deployed
resource "aws_s3_bucket" "test_bucket" {
    provider = aws.audit-account
     bucket = "coolfmremotestatedev4ertyu"
}

resource "aws_organizations_organization" "mgt_account" {
  aws_service_access_principals = ["securityhub.amazonaws.com"]
  feature_set                   = "ALL"
}

resource "aws_securityhub_organization_admin_account" "audit_acct" {
  count = var.enabled ? 1 : 0 
  admin_account_id = "123456789012"
  
  
}

resource "aws_securityhub_organization_configuration" "auditacct_config" {
  depends_on = [aws_securityhub_organization_admin_account.audit_acct]
  auto_enable = true
  provider = aws.audit-account
  count = var.enabled ? 1 : 0
 
}

resource "aws_securityhub_account" "auditsechub" {
  provider = aws.audit-account
  count = var.enabled ? 1 : 0
}


resource "aws_guardduty_detector" "audit_guardduty" {
  provider = aws.audit-account
  count = var.enabled ? 1 : 0
}

resource "aws_guardduty_organization_admin_account" "audit_guardduty" {
  depends_on = [aws_organizations_organization.mgt_account]
  provider = aws.audit-account
  count = var.enabled ? 1 : 0 
  admin_account_id = "123456789012"
}


resource "aws_guardduty_detector" "gd_detector" {
  enable = true
}



data "aws_iam_policy_document" "bucket_pol" {
  statement {
    sid = "Allow PutObject"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.gd_bucket.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow GetBucketLocation"
    actions = [
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.gd_bucket.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}

#SNS subscription with policy updated for Audit account
resource "aws_sns_topic" "audit_sns_topic" {
  name = var.audit_sns_name
  provider = aws.audit-account
  #count = var.enabled ? 1 : 0
}

resource "aws_sns_topic_policy" "audit_sns_topic_policy" {
    provider = aws.audit-account
  arn = aws_sns_topic.audit_sns_topic.arn
  policy = data.aws_iam_policy_document.audit_custom_sns_policy_document.json
}

data "aws_iam_policy_document" "audit_custom_sns_policy_document" {
  provider = aws.audit-account
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.audit_account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.audit_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
   
  }
}

data "aws_sns_topic" "audit_sns_topic" {
  provider = aws.audit-account
  name = var.audit_sns_name
  depends_on = [ aws_sns_topic.audit_sns_topic ]
  #count = var.enabled ? 1 : 0
}
resource "aws_sns_topic_subscription" "audit_updates_sqs_target" {
  provider = aws.audit-account
  topic_arn = data.aws_sns_topic.audit_sns_topic.arn
  protocol  = "email"
  endpoint  = "info@interstylesgroup.com"
}

###Lamda resource

resource "aws_iam_role" "audit_lambda_role" {
  provider = aws.audit-account
 name   = "terraform_aws_audit_lambda_role"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for logging from a lambda

resource "aws_iam_policy" "iam_policy_for_audit_lambda" {
    provider = aws.audit-account

  name         = "aws_iam_policy_for_terraform_aws_audit_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublishSNSMessage",
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:us-east-1:123456789012:audit_sns"
    }
  ]
}
EOF
}

# Policy Attachment on the role.

resource "aws_iam_role_policy_attachment" "audit_iam_role" {
  provider = aws.audit-account
  role        = aws_iam_role.audit_lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_audit_lambda.arn
}

# Generates an archive from content, a file, or a directory of files.
#added zip file

data "archive_file" "auditzip_the_python_code" {
  #provider = aws.audit-account
 type        = "zip"
 source_dir  = "${path.module}/python/"
 output_path = "${path.module}/python/hello-python.zip"
 #depends_on = [ local_file.lambda ]
}

# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "audit_lambda_func" {
 provider = aws.audit-account
 filename                       = "${path.module}/python/hello-python.zip"
 function_name                  = "Audit-Lambda-Function"
 role                           = aws_iam_role.audit_lambda_role.arn
 handler                        = "hello-python.lambda_handler"
 runtime                        = "python3.9"
 depends_on                     = [aws_iam_role_policy_attachment.audit_iam_role]
}