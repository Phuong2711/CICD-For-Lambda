data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../files/lambda_functions/lambda-to-deploy/lambda_function.py"
  output_path = "${path.module}/../../files/lambda_functions/lambda-to-deploy/lambda_function.zip"
}

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "${var.stage}-iam-role-for-lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "iam_policy_for_lambda" {
  name = "${var.stage}-iam-policy-for-lambda"
  role = aws_iam_role.iam_role_for_lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "none:null"
      Resource = "*"
    }]
  })
}

resource "aws_lambda_function" "lambda_to_deploy" {
  function_name    = "${var.stage}-lambda-to-deploy"
  role             = aws_iam_role.iam_role_for_lambda.arn
  runtime          = "python3.12"
  handler          = "lambda_function.lambda_handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 150
  memory_size      = 128
}