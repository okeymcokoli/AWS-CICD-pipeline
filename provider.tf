#AWS provider
provider "aws" {
  region     = var.region
}
provider "aws" {
region     = var.region
alias = "audit-account"
assume_role {
 role_arn = "arn:aws:iam::123456789012:role/cross-account-audit-CP"
}
}

