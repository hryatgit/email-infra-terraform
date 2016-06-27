# Mail Server Infrastructure

## Objective

I'm currently running [Mail-in-a-box](https://mailinabox.email/) and hosting this single server on DigitalOcean. The goal of this project is to migrate this mail server to AWS and manage the infrastructure with Terraform. Ideally, this will enable me to easily create and destroy the environment, move between regions or add regional redundancy for the servers.

This will also provide an opportunity to break out Mail-in-a-box components into different servers (instances).

Proposed environment:

![aws infra](https://nickcharlton.net/resources/images/aws_terraform_network_diagram.png)

Source: [(Amazon) Scenario 2: VPC with public and private subnets](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Scenario2.html)
## Getting Started

You will need to create a file called `terraform.tfvars` to store some variables. The file should look like this:

```
aws_access_key = ""
aws_secret_key = ""
aws_key_path = "~/path/to/keys.pem"
aws_key_name = "aws-keypair-name"
```

Then you can run the following commands to get started:

```
$ terraform plan
$ terraform apply
```

## Tools

- Terraform
- Chef
- AWS
- Ubuntu Linux
