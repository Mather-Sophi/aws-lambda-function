## Usage

```hcl
module "function" {
  source = "github.com/globeandmail/aws-lambda-function?ref=1.0"

  function_name      = my-lambda-function
  tags               = var.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| function\_name | A unique name for this Lambda Function | string | n/a | yes |
| alias | Creates an alias that points to the specified Lambda function version | string | `"live"` | no |
| description | A description for this Lambda Function | string | `"Created by Terraform"` | no |
| env\_vars | A map that defines environment variables for this Lambda function. | map | `{}` | no |
| filename | The zip file to upload containing the function code | string | `""` | no |
| handler | The function entrypoint | string | `"lambda_function.lambda_handler"` | no |
| layers | List of Lambda Layer Version ARNs \(maximum of 5\) to attach to this Lambda Function | list | `[]` | no |
| memory\_size | Amount of memory in MB this Lambda Function can use at runtime. Defaults to 128 | string | `"128"` | no |
| publish | Whether to publish creation/change as new Lambda Function Version. | bool | `"true"` | no |
| retention\_in\_days | Default value for this functions cloudwatch logs group | string | `"14"` | no |
| runtime | Lambda execution environment language | string | `"python3.7"` | no |
| secret\_arn | The ARN of the Secrets Manager secret, including the 6 random characters at the end | string | `"null"` | no |
| security\_group\_ids | Required for running this Lambda function in a VPC | list | `[]` | no |
| subnet\_ids | Required for running this Lambda function in a VPC | list | `[]` | no |
| tags | A mapping of tags to assign to the resource | map | `{}` | no |
| timeout | The amount of time this Lambda Function has to run in seconds | string | `"5"` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_arn | The ARN of the function created |
| function\_name | The name of the function created |
| role\_arn | The ARN of the role created |
| role\_id | The name of the role created |

