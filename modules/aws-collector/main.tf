# Collector(lambda) module

data "archive_file" "zip" {
  type = "zip"

  source_dir  = "${path.module}/service"
  output_path = "${path.module}/zip/service.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.scrapper_bucket_name.id
}

resource "random_pet" "scrapper_bucket_name" {
  prefix = "scrapper"
  length = 2
}

resource "aws_iam_role" "iam_lambda" {
  name = "lambda"

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

resource "aws_s3_object" "lambda_scrapper" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-scrapper.zip"
  source = data.archive_file.zip.output_path

  etag = filemd5(data.archive_file.zip.output_path)
}

resource "aws_lambda_function" "hello_scrapper" {
  function_name = "HelloScrrapper"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_scrapper.key

  runtime = "nodejs18.x"
  handler = "api.handler"

  source_code_hash = data.archive_file.zip.output_base64sha256

  role = aws_iam_role.iam_lambda.arn
}



