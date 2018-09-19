
# API Gateway 

resource "aws_api_gateway_rest_api" "gateway" {
  name        = "${var.prefix}-gateway"
  description = ""
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  stage_name  = "Production"
}

resource "aws_api_gateway_gateway_response" "default_4XX" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  response_type = "DEFAULT_4XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_gateway_response" "default_5XX" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  response_type = "DEFAULT_5XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
  }
}


//---API Gateway - Base
resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.execute_base.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.gateway.id}/*/*/*"
}

resource "aws_api_gateway_resource" "base" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.gateway.root_resource_id}"
  path_part   = "base"
}

// must use OPTIONS method to enable CORS
resource "aws_api_gateway_method" "OPTIONS_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id   = "${aws_api_gateway_resource.base.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_resource.base.id}"
  http_method = "${aws_api_gateway_method.OPTIONS_method.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = ["aws_api_gateway_method.OPTIONS_method"]
}

resource "aws_api_gateway_integration" "OPTIONS_integration" {
  rest_api_id          = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id          = "${aws_api_gateway_resource.base.id}"
  http_method          = "${aws_api_gateway_method.OPTIONS_method.http_method}"
  type                 = "MOCK"
  depends_on           = ["aws_api_gateway_method.OPTIONS_method"]
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = <<EOF
{"statusCode":200}
EOF
  }
}

resource "aws_api_gateway_integration_response" "OPTIONS_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_resource.base.id}"
  http_method = "${aws_api_gateway_method.OPTIONS_method.http_method}"
  status_code = "${aws_api_gateway_method_response.options_200.status_code}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Auth-Token,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = "Empty"
  }

  depends_on = ["aws_api_gateway_method_response.options_200"]
}

//GET
resource "aws_api_gateway_method" "base_GET_tableau" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id   = "${aws_api_gateway_resource.base.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "base_GET_method_response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_resource.base.id}"
  http_method = "${aws_api_gateway_method.base_GET_tableau.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = ["aws_api_gateway_method.base_GET_tableau"]
}

resource "aws_api_gateway_integration" "base_GET_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id             = "${aws_api_gateway_resource.base.id}"
  http_method             = "${aws_api_gateway_method.base_GET_tableau.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.execute_base.arn}/invocations"
}
