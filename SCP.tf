## Get root data
data "aws_organizations_organization" "Prod" {
    # count = var.enabled ? 1 : 0
}

##OU Unit
resource "aws_organizations_organizational_unit" "Prod" {
    name = "Prod"
    parent_id = data.aws_organizations_organization.Prod.roots.0.id
    #  count = var.enabled ? 1 : 0
}

## Attaching policy to OU
resource "aws_organizations_policy_attachment" "demoscp" {
  policy_id = aws_organizations_policy.demoscp.id
  target_id = aws_organizations_organizational_unit.Prod.id
}

##Create SCP - to stop users from disabling AWS config
resource "aws_organizations_policy" "demoscp" {
  name = "demoscp"
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": [
        "config:DeleteConfigRule",
        "config:DeleteConfigurationRecorder",
        "config:DeleteDeliveryChannel",
        "config:StopConfigurationRecorder"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

## Attaching policy to OUnits
resource "aws_organizations_policy_attachment" "ec2scp" {
  policy_id = aws_organizations_policy.ec2scp.id
  target_id = aws_organizations_organizational_unit.Prod.id
}

##Create SCP - to stop users from disabling AWS config
resource "aws_organizations_policy" "ec2scp" {
  name = "ec2scp"
  content = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Deny",
        "Action": "ec2:RunInstances",
        "Resource": "arn:aws:ec2:*:*:instance/*",
        "Condition": {
            "StringNotEquals": {
                "ec2:InstanceType": "t2.micro"
            }
        }
    }
}
EOF
}

