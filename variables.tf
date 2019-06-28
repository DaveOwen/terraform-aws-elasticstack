# --------------- REQUIRED PARAMETERS ---------------
variable "key" {
  description = "Name of the AWS Key Pair to associate with the ELK instance."
}

variable "private_key" {
  description = "Path to the local SSH private key file associated with the AWS Key Pair."
}

variable "ami_id" {
  description = "AMI ID with Ubuntu Server 18.04 installed."
}

# --------------- OPTIONAL PARAMETERS ---------------
variable "instance_name" {
  description = "Name of EC2 instance."
  default     = "Elastic Stack"
}

variable "instance_type" {
  description = "The type of EC2 instance to run."
  default     = "t2.medium"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume."
  default     = "50"
}

variable "root_volume_type" {
  description = "Type of EBS volume to create"
  default     = "gp2"
}

variable "root_volume_delete_on_termination" {
  description = "Delete volume on instance termination. Either true or false"
  default     = "true"
}
