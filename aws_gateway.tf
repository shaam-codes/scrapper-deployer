# Gateway related configutaions

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.app_name}_gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_gateway" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  name        = "${var.app_name}_gateway"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

resource "aws_apigatewayv2_integration" "api_gateway" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri    = module.aws-collector.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "api_gateway" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "GET /collector/health"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.aws-collector.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}