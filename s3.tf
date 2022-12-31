#S3 Bucket Config
resource "aws_s3_bucket" "terraform-state" {
 bucket = var.bucket

 tags = {
    Name = "Gol-ball"
    Owner = "InfraTeam"
 }
}

resource "aws_s3_bucket_acl" "acl" {
 bucket = aws_s3_bucket.terraform-state.id
 acl = "private"
}