## v1.9 Notes
The TF module now supports `Zip` and `Image` deployment package types. When you use the `Image` package type, you must not specify any value for the `handler`, `runtime` and `layers` input variables.

## v1.8 Notes
AWS annouced the [AWS parameters and secrets lambda extension](https://aws.amazon.com/about-aws/whats-new/2022/10/aws-parameters-secrets-lambda-extension/) on Oct 18, 2022. The extension is offered as a lambda layer and can be enabled by setting the `use_parameters_and_secrets_layer` variable to `true`.

## Usage

```hcl
module "function" {
  source = "github.com/globeandmail/aws-lambda-function?ref=1.9"

  function_name      = "my-lambda-function"
  tags               = var.tags

  # enable a dead letter queue
  dead_letter_config = {
    target_arn = "SQS or SNS arn"
  }

}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | Creates an alias that points to the specified Lambda function version | `string` | `"live"` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | n/a | <pre>object({<br>    target_arn = string<br>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for this Lambda Function | `string` | `"Created by Terraform"` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | A map that defines environment variables for this Lambda function. | `map` | `null` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | Amount of Ephemeral storage(/tmp) in MB this Lambda Function can use at runtime. Defaults to 512 | `number` | `512` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | The zip file to upload containing the function code | `string` | `""` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | A unique name for this Lambda Function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint. Only specify when var.package\_type is Zip | `string` | `"lambda_function.lambda_handler"` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | The ECR image URI containing the function's deployment package. Only specify when var.package\_type is Image | `string` | `""` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to this Lambda Function. Only specify when var.package\_type is Zip | `list` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB this Lambda Function can use at runtime. Defaults to 128 | `number` | `128` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | Lambda deployment package type | `string` | `"Zip"` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version. | `bool` | `true` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Default value for this functions cloudwatch logs group | `number` | `14` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda execution environment language. Only specify when var.package\_type is Zip | `string` | `"python3.7"` | no |
| <a name="input_secret_arn"></a> [secret\_arn](#input\_secret\_arn) | The ARN of the Secrets Manager secret, including the 6 random characters at the end | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Required for running this Lambda function in a VPC | `list` | `[]` | no |
| <a name="input_sns_target_arn"></a> [sns\_target\_arn](#input\_sns\_target\_arn) | SNS arn for the target when there is a failure | `string` | `""` | no |
| <a name="input_sqs_target_arn"></a> [sqs\_target\_arn](#input\_sqs\_target\_arn) | SQS arn for the target when there is a failure | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Required for running this Lambda function in a VPC | `list` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time this Lambda Function has to run in seconds | `number` | `5` | no |
| <a name="input_use_parameters_and_secrets_layer"></a> [use\_parameters\_and\_secrets\_layer](#input\_use\_parameters\_and\_secrets\_layer) | Required to be set to true if using the AWS parameters and secrets lambda extension. Only specify when var.package\_type is Zip | `bool` | `false` | no |
| <a name="input_use_secrets"></a> [use\_secrets](#input\_use\_secrets) | Required to be set to true if using secret\_arn | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the function created |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the function created |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | The ARN to be used for invoking Lambda Function from API Gateway |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the role created |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The name of the role created |
| <a name="output_version"></a> [version](#output\_version) | The version of the function created |
