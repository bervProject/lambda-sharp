variables {
  lambda_image = "test"
}

run "valid_image" {

  command = plan

  assert {
    condition     = aws_lambda_function.lambda_container_demo.image_uri == "test"
    error_message = "AWS Lambda Function Image URI did not match"
  }

}

run "valid_function_name" {

  command = plan

  assert {
    condition     = aws_lambda_function.lambda_container_demo.function_name == "lambda_container_demo"
    error_message = "AWS Lambda Function Name did not match"
  }

}

run "valid_lambda_timeout" {

  command = plan

  assert {
    condition     = aws_lambda_function.lambda_container_demo.timeout == 60
    error_message = "AWS Lambda timeout did not match"
  }

}

run "valid_dynamo_db_capacity" {

  command = plan

  assert {
    condition     = aws_dynamodb_table.lambda_container_demo_dev.read_capacity == 20
    error_message = "Dynamo DB read capacity did not match"
  }

  assert {
    condition     = aws_dynamodb_table.lambda_container_demo_dev.write_capacity == 20
    error_message = "Dynamo DB write capacity did not match"
  }

}
