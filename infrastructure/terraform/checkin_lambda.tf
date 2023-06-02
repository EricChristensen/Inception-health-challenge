variable "checkin_function_name" {
  default = "inception_checkin_lambda"
}

resource "aws_lambda_function" "inception_checkin_lambda" {
  function_name = var.checkin_function_name
  role = "${aws_iam_role.inception_checkin_lambda_iam_role.arn}"

  image_uri = "478135184665.dkr.ecr.us-east-1.amazonaws.com/inception_health_repository:latest"
  package_type = "Image"
  image_config {
    command = ["index.checkin"]
  }

  environment {
    variables = {
      DYNAMO_TABLE_NAME = var.dynamodb_checkin_table_name
      REGION = "us-east-1"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.inception_checkin_lambda_iam_role_policy_attachment,
    aws_cloudwatch_log_group.inception_checkin_lambda_cloudwatch_log_group,
  ]
}

resource "aws_cloudwatch_log_group" "inception_checkin_lambda_cloudwatch_log_group" {
  name              = "/aws/lambda/${var.checkin_function_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "inception_checkin_lambda_iam_policy" {
  name        = "inception_checkin_lambda_iam_policy"
  path        = "/"
  description = "IAM policy for logging and dynamo access for the checkin lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:478135184665:table/Checkin",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "inception_checkin_lambda_iam_role" {
  name = "inception_checkin_lambda_iam_role"

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

resource "aws_iam_role_policy_attachment" "inception_checkin_lambda_iam_role_policy_attachment" {
  role       = aws_iam_role.inception_checkin_lambda_iam_role.name
  policy_arn = aws_iam_policy.inception_checkin_lambda_iam_policy.arn
}