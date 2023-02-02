# Collector(lambda) module

data "archive_file" "zip" {
  type = "zip"

  source_dir  = "${path.module}/service"
  output_path = "${path.module}/zip/service.zip"
}

resource "aws_s3_bucket" "collector_bucket" {
  bucket = random_pet.collector_bucket_name.id
}

resource "random_pet" "collector_bucket_name" {
  prefix = "${var.app_name}-collector"
  length = 2
}

resource "aws_iam_role" "collector_lambda" {
  name = "${var.app_name}_collector_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_s3_object" "collector_s3_object" {
  bucket = aws_s3_bucket.collector_bucket.id

  key    = "collector_lambda.zip"
  source = data.archive_file.zip.output_path

  etag = filemd5(data.archive_file.zip.output_path)
}

resource "aws_lambda_function" "collector_lambda_function" {
  function_name = "collector_lambda"

  s3_bucket = aws_s3_bucket.collector_bucket.id
  s3_key    = aws_s3_object.collector_s3_object.key

  runtime = "nodejs18.x"
  handler = "api.handler"

  source_code_hash = data.archive_file.zip.output_base64sha256

  role = aws_iam_role.collector_lambda.arn
}



