variable "function_name" {
  type        = string
  description = "A unique name for this Lambda Function"
}

variable "description" {
  type        = string
  default     = "Created by Terraform"
  description = "A description for this Lambda Function"
}

variable "publish" {
  type        = bool
  default     = true
  description = "Whether to publish creation/change as new Lambda Function Version."
}

variable "alias" {
  type        = string
  default     = "live"
  description = "Creates an alias that points to the specified Lambda function version"
}

variable "filename" {
  type = string
  default     = ""
  description = "The zip file to upload containing the function code"
}

variable "image_uri" {
  type = string
  default = ""
  description = "The ECR image URI containing the function's deployment package. Only specify when var.package_type is Image"
}

variable "handler" {
  default     = "lambda_function.lambda_handler"
  description = "The function entrypoint. Only specify when var.package_type is Zip"
}

variable "runtime" {
  type        = string
  default     = "python3.7"
  description = "Lambda execution environment language. Only specify when var.package_type is Zip"
}

variable "memory_size" {
  default     = 128
  description = "Amount of memory in MB this Lambda Function can use at runtime. Defaults to 128"
}

variable "ephemeral_storage" {
  default     = 512
  description = "Amount of Ephemeral storage(/tmp) in MB this Lambda Function can use at runtime. Defaults to 512"
}

variable "timeout" {
  default     = 5
  description = "The amount of time this Lambda Function has to run in seconds"
}

variable "env_vars" {
  type        = map
  default     = null
  description = "A map that defines environment variables for this Lambda function."
}

variable "retention_in_days" {
  default     = 14
  description = "Default value for this functions cloudwatch logs group"
}

variable "subnet_ids" {
  type        = list
  default     = []
  description = "Required for running this Lambda function in a VPC"
}

variable "security_group_ids" {
  type        = list
  default     = []
  description = "Required for running this Lambda function in a VPC"
}

variable "use_secrets" {
  type        = bool
  default     = false
  description = "Required to be set to true if using secret_arn"
}

variable "secret_arn" {
  type        = string
  default     = null
  description = "The ARN of the Secrets Manager secret, including the 6 random characters at the end"
}

variable "layers" {
  type        = list
  default     = []
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to this Lambda Function. Only specify when var.package_type is Zip"
}

variable "package_type" {
  type = string
  default = "Zip"
  description = "Lambda deployment package type"
}

variable "tags" {
  type        = map
  default     = {}
  description = "A mapping of tags to assign to the resource"
}

variable "sns_target_arn" {
  type        = string
  default     = ""
  description = "SNS arn for the target when there is a failure"
}

variable "sqs_target_arn" {
  type        = string
  default     = ""
  description = "SQS arn for the target when there is a failure"
}

variable "dead_letter_config" {
  type = object({
    target_arn = string
  })
  default = null
}

variable "use_parameters_and_secrets_layer" {
  type        = bool
  default     = false
  description = "Required to be set to true if using the AWS parameters and secrets lambda extension. Only specify when var.package_type is Zip"
}