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
}

resource "aws_lambda_function" "lambda_container_demo" {
  function_name = "lambda_container_demo"
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri = "092318301320.dkr.ecr.ap-southeast-1.amazonaws.com/lambda-sharp:main"
  publish = true
  package_type = "Image"

  tags = {
    "env" = "dev"
  }
}

resource "aws_lambda_function_url" "lambda_container_demo_dev" {
  function_name      = aws_lambda_function.lambda_container_demo.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 300
  }
}

resource "aws_lambda_function_url" "lambda_container_demo_prod" {
  function_name      = aws_lambda_function.lambda_container_demo.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}