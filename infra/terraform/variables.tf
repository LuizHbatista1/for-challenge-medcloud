variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
  default     = "dev"
}

variable "environment_configs" {
  description = "Environment specific configurations"
  type = map(object({
    instance_type     = string
    desired_count     = number
    db_instance_class = string
    vpc_cidr         = string
  }))
  default = {
    dev = {
      instance_type     = "t3.micro"
      desired_count     = 1
      db_instance_class = "db.t3.micro"
      vpc_cidr         = "10.0.0.0/16"
    }
    prod = {
      instance_type     = "t3.small"
      desired_count     = 2
      db_instance_class = "db.t3.small"
      vpc_cidr         = "172.16.0.0/16"
    }
  }
}
