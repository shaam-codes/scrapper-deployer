# Collector(lambda) outputs only

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.collector_lambda_function.function_name
}

output "invoke_arn" {
  description = "Collector lambda function invoke arn"

  value = aws_lambda_function.collector_lambda_function.invoke_arn
}
