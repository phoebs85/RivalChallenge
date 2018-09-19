#Required Variables
variable "environment" {
  default = "Sandbox"
}

variable "lambda_pkg" {
  default = "MAIN.zip"
}

variable "git_tags" {
  default = "V1.0.0"
} //Tag in Git

variable "is_debug" {
  default = "false"
}

variable "region" {
  default = "us-west-2"
}

variable "prefix" {
  default = "PTO"
} //No spaces please

variable "client_name" {
  default = "PTO"
}

variable "s3_bucket" {
  default = "phoebe.to"
}

variable "s3_key" {
  default = "test.csv"
}