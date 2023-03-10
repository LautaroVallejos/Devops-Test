# Terraform backend config
terraform {
  backend "s3" {
    bucket         = "devops-bucktest"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/bucket-key"
    dynamodb_table = "terraform-state"
  }
}

# Bucket Key
resource "aws_kms_key" "bucket-key" {
  description             = "This key is used to encrypt bucket objects"
}

resource "aws_kms_alias" "key-alias" {
 name          = "alias/bucket-key-master"
 target_key_id = aws_kms_key.bucket-key.key_id
}