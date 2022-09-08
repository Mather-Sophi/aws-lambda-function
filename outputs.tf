output "role_arn" {
  value       = aws_iam_role.lambda.arn
  description = "The ARN of the role created"
}

output "role_id" {
  value       = aws_iam_role.lambda.id
  description = "The name of the role created"
}

output "function_arn" {
  value       = aws_lambda_function.lambda.arn
  description = "The ARN of the function created"
}

output "function_name" {
  value       = aws_lambda_function.lambda.function_name
  description = "The name of the function created"
}

output "invoke_arn" {
  value       = aws_lambda_function.lambda.invoke_arn
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
}

output "version" {
  value       = aws_lambda_function.lambda.version
  description = "The name of the function created"
}
