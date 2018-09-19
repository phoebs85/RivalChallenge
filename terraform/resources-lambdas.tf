# Project Lambda Functions -----------------------------------------------------------
resource "aws_lambda_function" "execute_base" {
  filename         = "${var.lambda_pkg}"
  function_name    = "${var.prefix}-main-execute",
  description      = "(${var.git_tags})"
  role             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.client_name}-stack-iam"
  handler          = "index.handler"
  runtime          = "nodejs6.10"
  timeout		       = "300"
  memory_size	     = "128"
  source_code_hash = "${base64sha256(file("${var.lambda_pkg}"))}"
  tags {
    Client = "${var.client_name}"
    Prefix = "${var.prefix}"
  }
  environment {
    variables = {
      environment                     = "${var.environment}"
      is_debug                        = "${var.is_debug}"
      S3_BUCKET                       = "${var.s3_bucket}"
      S3_KEY                          = "${var.s3_key}"
    }
  }
}
//Cloudlog
resource "aws_cloudwatch_log_group" "execute_base_cloudlog" {
  name = "/aws/lambda/${aws_lambda_function.execute_base.function_name}"
  retention_in_days = 180
  tags {
    Client = "${var.client_name}"
    Prefix = "${var.prefix}"
  }
}
