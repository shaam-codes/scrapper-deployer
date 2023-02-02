# System level outputs
output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.api_gateway.invoke_url
}