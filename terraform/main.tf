resource "aws_s3_bucket" "new_bucket_provision" { 
  bucket = var.bucket_name #Update the bucket name in the variables/dev~local~prod!test.tfvars files
  tags = {
    Name = "New S3 Bucket Provision" # Can update the tage here
  }
}

resource "aws_iam_role_policy_attachment" "s3_access_role_policy" {
  role       = data.aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" 
}

resource "aws_s3_bucket_policy" "new_bucket_policy" {
  bucket = aws_s3_bucket.new_bucket_provision.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.s3_access_role.arn
        }
        Action = "s3:*"
        Resource = [
          "${aws_s3_bucket.new_bucket_provision.arn}",
          "${aws_s3_bucket.new_bucket_provision.arn}/*"
        ]
      }
    ]
  })
}