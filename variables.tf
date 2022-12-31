# Set Variables
# You should also change the variable names in state.tf
variable region {
  type        = string
  default     = "us-east-1"
  description = "Infrastructure deployment region"
}

variable bucket {
    type = string
    default = "devops-bucktest"
    description = "Name of bucket"
}