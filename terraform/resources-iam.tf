#Standard AWS Connects -------------------------------------------------------
provider "aws" {
  access_key = "${var.access_key[var.environment]}"
  secret_key = "${var.secret_key[var.environment]}"
  region     = "${var.region}"
}

data "aws_caller_identity" "current" {}

# IAM Role -------------------------------------------------------------------
resource "aws_iam_role" "iam_role" {
  name = "${var.client_name}-stack-iam"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# KMS Keys -------------------------------------------------------------------
resource "aws_kms_key" "kms_key" {
  description   = "${var.client_name}-kms-key"
  deletion_window_in_days = 7
  tags {
    Client = "${var.client_name}"
  }
}
resource "aws_kms_alias" "kms_key_alias" {
  name          = "alias/${var.client_name}-kms-key-alias"
  target_key_id = "${aws_kms_key.kms_key.key_id}"
}

# Additional Role Policy And Attach -----------------------------------------------------
resource "aws_iam_role_policy" "proj-inline-policy-1" {
  name = "${var.prefix}-stack-iam-policy"
  role = "${var.client_name}-stack-iam"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${var.s3_bucket}/*"
            ]
        }
    ]
}
EOF
}