# All cloudwatch related configurations

resource "aws_cloudwatch_log_group" "api_gateway" {
  name = "/aws/api_gateway/${aws_apigatewayv2_api.api_gateway.name}"

  retention_in_days = 1
}
