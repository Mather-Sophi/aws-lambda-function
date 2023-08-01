data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_region = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
  datetime   = formatdate("YYYYMMDDhhmmss", timestamp())
  env_vars   = var.env_vars[*]
  aws_parameters_and_secrets_lambda_extension_arn = {
    us-east-1      = "arn:aws:lambda:us-east-1:177933569100:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    us-east-2      = "arn:aws:lambda:us-east-2:590474943231:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    us-west-1      = "arn:aws:lambda:us-west-1:997803712105:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    us-west-2      = "arn:aws:lambda:us-west-2:345057560386:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ca-central-1   = "arn:aws:lambda:ca-central-1:200266452380:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    eu-central-1   = "arn:aws:lambda:eu-central-1:187925254637:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    eu-west-1      = "arn:aws:lambda:eu-west-1:015030872274:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    eu-west-2      = "arn:aws:lambda:eu-west-2:133256977650:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    eu-west-3      = "arn:aws:lambda:eu-west-3:780235371811:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    eu-north-1     = "arn:aws:lambda:eu-north-1:427196147048:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    eu-south-1     = "arn:aws:lambda:eu-south-1:325218067255:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    cn-north-1     = "arn:aws-cn:lambda:cn-north-1:287114880934:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    cn-northwest-1 = "arn:aws-cn:lambda:cn-northwest-1:287310001119:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-east-1      = "arn:aws:lambda:ap-east-1:768336418462:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-northeast-1 = "arn:aws:lambda:ap-northeast-1:133490724326:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-northeast-3 = "arn:aws:lambda:ap-northeast-3:576959938190:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-northeast-2 = "arn:aws:lambda:ap-northeast-2:738900069198:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-southeast-1 = "arn:aws:lambda:ap-southeast-1:044395824272:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-southeast-2 = "arn:aws:lambda:ap-southeast-2:665172237481:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-southeast-3 = "arn:aws:lambda:ap-southeast-3:490737872127:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    ap-south-1     = "arn:aws:lambda:ap-south-1:176022468876:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    sa-east-1      = "arn:aws:lambda:sa-east-1:933737806257:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    af-south-1     = "arn:aws:lambda:af-south-1:317013901791:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    me-central-1   = "arn:aws:lambda:me-central-1:858974508948:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    me-south-1     = "arn:aws:lambda:me-south-1:832021897121:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    us-gov-east-1  = "arn:aws-us-gov:lambda:us-gov-east-1:129776340158:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2",
    us-gov-west-1  = "arn:aws-us-gov:lambda:us-gov-west-1:127562683043:layer:AWS-Parameters-and-Secrets-Lambda-Extension:2"
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  description   = var.description != "Created by Terraform" ? var.description : "${var.description} at ${local.datetime}"
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  role          = aws_iam_role.lambda.arn
  handler       = var.handler
  publish       = var.publish
  layers        = (
    var.use_parameters_and_secrets_layer ?
    concat([lookup(local.aws_parameters_and_secrets_lambda_extension_arn, local.aws_region)], var.layers) :
    var.layers
  )
  package_type = var.package_type
  // Use empty_function.zip if no other file is specified
  filename = var.package_type == "Zip" ? length(var.filename) > 0 ? var.filename : "${path.module}/files/empty_function.zip" : null
  image_uri = var.package_type == "Image" ? var.image_uri : null

  dynamic "environment" {
    for_each = local.env_vars
    content {
      variables = environment.value
    }
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  tags = var.tags
}

resource "aws_lambda_alias" "alias" {
  name             = var.alias
  function_name    = aws_lambda_function.lambda.arn
  function_version = "$LATEST"
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com","edgelambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "Lambda-${var.function_name}-Role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "secrets_manager" {
  count = var.use_secrets == true ? 1 : 0
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]

    resources = [
      replace(var.secret_arn, "/-.{6}$/", "-??????")
    ]
  }
}

resource "aws_iam_role_policy" "secrets_manager" {
  count  = var.use_secrets == true ? 1 : 0
  name   = "${var.function_name}-secretsmanager-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.secrets_manager[count.index].json
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  // If no subnet_ids are listed, this isn't in VPC
  count      = length(var.subnet_ids) > 0 ? 0 : 1
  role       = aws_iam_role.lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  // If subnet_ids are defined, use the VPC Access Execution Role
  count      = length(var.subnet_ids) > 0 ? 1 : 0
  role       = aws_iam_role.lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.retention_in_days

  tags = var.tags
}

data "aws_iam_policy_document" "sns_target" {
  count = var.sns_target_arn != "" ? 1 : 0
  statement {
    actions = [
      "sns:Publish"
    ]

    resources = [
      var.sns_target_arn
    ]
  }
}

resource "aws_iam_role_policy" "sns_target" {
  count  = var.sns_target_arn != "" ? 1 : 0
  name   = "${var.function_name}-sns-target-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.sns_target[count.index].json
}

data "aws_iam_policy_document" "sqs_target" {
  count = var.sqs_target_arn != "" ? 1 : 0
  statement {
    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      var.sqs_target_arn
    ]
  }
}

resource "aws_iam_role_policy" "sqs_target" {
  count  = var.sqs_target_arn != "" ? 1 : 0
  name   = "${var.function_name}-sqs-target-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.sqs_target[count.index].json
}
