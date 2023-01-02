# Variables Declaration (setted in terraform.tfvars)
# if not exist this file, create it and assign this variables that are below
# You should also change the variable names in State.tf

variable "region" {}

variable "bucket" {}

variable "key_name" {}

variable "public_key" {}

variable "dynamo_table" {}

variable "availability_zone" {}