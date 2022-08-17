# --- examples/central_inspection_without_egress/modules/compute/variables.tf ---

variable "identifier" {
  type        = string
  description = "Project identifier."
}

variable "vpc_name" {
  type        = string
  description = "VPC name."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the instances."
}

variable "vpc_subnets" {
  type        = map(string)
  description = "Subnets in the VPC to create the instances."
}

variable "number_azs" {
  type        = number
  description = "Number of AZs to place instances."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "ec2_iam_instance_profile" {
  type        = string
  description = "EC2 instance profile to attach to the EC2 instance(s)"
}

variable "ec2_security_group" {
  type        = any
  description = "Information about the Security Groups to create."
}