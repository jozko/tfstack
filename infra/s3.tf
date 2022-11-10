/*
Create a S3 bucket with an ACL
*/

resource "aws_s3_bucket" "test-bucket" {
  bucket = "my-test-bucket"
}

resource "aws_s3_bucket_acl" "test-bucket" {
  bucket = aws_s3_bucket.test-bucket.id
  acl    = "private"
}
