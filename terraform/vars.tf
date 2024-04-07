variable "lambda_image" {
  type     = string
  nullable = false
}

variable "function_name" {
  type     = string
  nullable = false
  default  = "lambda_container_demo"
}

variable "lambda_timeout" {
  type     = number
  nullable = false
  default  = 60
}

variable "dynamodb_read_capacity" {
  type     = number
  default  = 20
  nullable = false
}

variable "dynamodb_write_capacity" {
  type     = number
  default  = 20
  nullable = false
}

variable "dynamodb_global_read_capacity" {
  type     = number
  default  = 20
  nullable = false
}

variable "dynamodb_global_write_capacity" {
  type     = number
  default  = 20
  nullable = false
}


