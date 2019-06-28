# Terraform AWS Elastic Stack Module

This is a Terraform module that will provision Elastic Stack (Elasticsearch, Beats, Logstash, and Kibana) on an AWS EC2 instance.
This module is based on [admintome/elk/aws](https://registry.terraform.io/modules/admintome/elk/aws/0.2.0).

## Usage
### Terraform configuration file
Create a configuration file with the following contents:
```
terraform {
  required_version = "0.11.14"
}

provider "aws" {
  access_key = "AWS ACCESS KEY"
  secret_key = "AWS SECRET KEY"
  region     = "AWS REGION"
}

module "terraform-elastic-stack-aws" {
  source      = "github.com/DaveOwen/terraform-elastic-stack-aws"

  key         = "AWS KEYPAIR NAME"
  private_key = "${file("PATH TO AWS KEY")}"
  ami_id      = "AMI-ID"
}
```

### AWS Keys
Find these under 'Your Security Credentials' in the AWS Console.

### AMI
Any AMI in your region with Ubuntu Server 18.04 is fine.

### Optional Parameters
Take a look at variables.tf and change the optional parameters as you see fit. They all have sensible defaults.

### Elasticsearch, Filebeat, Logstash & Kibana configurations
The YAML files for each of the services needs to be configured before applying. Check out the documentaiton for each of the services below.

* [Elastic Stack Documentation](https://www.elastic.co/guide/index.html)
* [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
* [Beats Documentation](https://www.elastic.co/guide/en/beats/libbeat/current/index.html)
* [Filebeat Documentation](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
* [Logstash Documentation](https://www.elastic.co/guide/en/logstash/current/index.html)
* [Kibana Documentation](https://www.elastic.co/guide/en/kibana/current/index.html)
