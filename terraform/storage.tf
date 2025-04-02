resource "aws_s3_bucket" "codepipeline_bucket_dev" {
  bucket = "dardelean-codepipeline-bucket-2024-v2-dev"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_dev_pab" {
  bucket = aws_s3_bucket.codepipeline_bucket_dev.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "codepipeline_bucket_prod" {
  bucket = "dardelean-codepipeline-bucket-2024-v2-prod"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_prod_pab" {
  bucket = aws_s3_bucket.codepipeline_bucket_prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}