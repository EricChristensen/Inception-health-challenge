
resource "aws_cloudwatch_event_rule" "every_two_minutes" {
    name = "every-two-minutes"
    description = "Fires every 2 minutes"
    schedule_expression = "rate(2 minutes)"
}

resource "aws_cloudwatch_event_target" "checkin_every_two_minutes" {
    rule = aws_cloudwatch_event_rule.every_two_minutes.name
    target_id = "inception_checkin_lambda"
    arn = aws_lambda_function.inception_checkin_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_checkin" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.inception_checkin_lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_two_minutes.arn
}