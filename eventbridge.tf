##Eventbridge for Audit-account

resource "aws_cloudwatch_event_rule" "securityhub_events" {
  provider = aws.audit-account
  name = "securityhub_events"
  event_bus_name = "default"
  #schedule_expression = "rate(2 minutes)"
  schedule_expression = "cron(0 10 ? * MON *)"
  event_pattern = <<EOF
  {
    "source": ["aws.securityhub"],
      "detail-type": ["Security Hub Findings"]  
    }
  EOF

}
resource "aws_cloudwatch_event_target" "lambda_target" {
  provider = aws.audit-account
  rule = aws_cloudwatch_event_rule.securityhub_events.name
  arn = aws_lambda_function.audit_lambda_func.arn
  depends_on = [ aws_lambda_function.audit_lambda_func ]
} 

##adding lambda permissions
resource "aws_lambda_permission" "allow_eventbridge" {
  provider = aws.audit-account
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.audit_lambda_func.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.securityhub_events.arn
}