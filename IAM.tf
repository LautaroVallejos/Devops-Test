# IAM Settings
resource "aws_iam_user" "user" {
  name = "test-user"
}

# Role
resource "aws_iam_role" "test_role" {
  name = "DevOps-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    description = "role for devops test"
  }
}

# Group
resource "aws_iam_group" "group" {
  name = "Dev-Group"
}

# Policy
resource "aws_iam_policy" "policy" {
  name        = "devops-test-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Policy Attachment
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "devops-test-attachment"
  users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.test_role.name]
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}

# Profile for EC2 instance
resource "aws_iam_instance_profile" "ec2_role" {
    name = "ec2-user"
    role = aws_iam_role.test_role.name
}
