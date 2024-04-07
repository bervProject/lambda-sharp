resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  inline_policy {
    name = "lambda-custom"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
        }, {
        Effect = "Allow",
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListTables",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = ["*"]
    }] })
  }
}

resource "aws_lambda_function" "lambda_container_demo" {
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri     = var.lambda_image # please update with your image
  publish       = true
  package_type  = "Image"

  tags = {
    "env" = "dev"
  }

  tracing_config {
    mode = "Active"
  }

  timeout = var.lambda_timeout

}

resource "aws_lambda_function_url" "lambda_container_demo_dev" {
  function_name      = aws_lambda_function.lambda_container_demo.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 300
  }
}

resource "aws_dynamodb_table" "lambda_container_demo_dev" {
  name           = "Notes"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Message"
    type = "S"
  }

  global_secondary_index {
    name               = "NoteMessageIndex"
    hash_key           = "Message"
    write_capacity     = var.dynamodb_global_write_capacity
    read_capacity      = var.dynamodb_global_read_capacity
    projection_type    = "INCLUDE"
    non_key_attributes = ["Id"]
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "dev"
  }
}

output "lambda_url" {
  value = aws_lambda_function_url.lambda_container_demo_dev.function_url
}

check "health_check" {
  data "http" "terraform_io" {
    url = "${output.lambda_url}/api/notes"
  }

  assert {
    condition     = data.http.terraform_io.status_code == 200
    error_message = "${data.http.terraform_io.url} returned an unhealthy status code"
  }
}
