resource "aws_s3_bucket" "example" {
 bucket = "<YOUR_BUCKET_NAME>"

 tags = {
    Name        = "example-s3-bucket"
    Environment = "dev"
 }

 versioning {
    enabled = true
 }

 lifecycle_rule {
    id      = "expire_after_90_days"
    enabled = true

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      days = 30
    }
 }
}

resource "aws_s3_bucket_policy" "example" {
 bucket = aws_s3_bucket.example.id

 policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = "${aws_s3_bucket.example.arn}/*"
      }
    ]
 })
}

resource "aws_s3_bucket_public_access_block" "example" {
 bucket = aws_s3_bucket.example.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}