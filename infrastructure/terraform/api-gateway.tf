resource "aws_api_gateway_rest_api" "inception_backend" {

  description = "Inception Backend API"
  name = "InceptionBackendApi"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.inception_backend.id}"
  parent_id   = "${aws_api_gateway_rest_api.inception_backend.root_resource_id}"
  path_part   = "backend"
}

resource "aws_api_gateway_method" "get_proxy" {

  authorization = "NONE"
  http_method = "GET"
  resource_id = "${aws_api_gateway_resource.proxy.id}"
  rest_api_id = "${aws_api_gateway_rest_api.inception_backend.id}"
}

resource "aws_api_gateway_integration" "get_lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.inception_backend.id}"
  resource_id = "${aws_api_gateway_method.get_proxy.resource_id}"
  http_method = "${aws_api_gateway_method.get_proxy.http_method}"

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "${aws_lambda_function.inception_backend_lambda.invoke_arn}"
}

resource "aws_api_gateway_deployment" "inception_backend" {
  depends_on = [
    aws_api_gateway_integration.get_lambda,
  ]

  rest_api_id = "${aws_api_gateway_rest_api.inception_backend.id}"
  stage_name  = "stage"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.inception_backend_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.inception_backend.execution_arn}/*/*"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.inception_backend.invoke_url}/backend"
}