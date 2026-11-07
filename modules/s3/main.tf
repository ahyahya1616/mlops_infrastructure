# ==============================================================================
# Amazon S3 Bucket: Financial Data Lake & Artifact Storage
# ==============================================================================

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true # Allows clean terraform destroy for learning lab

  tags = {
    Name = var.bucket_name
  }
}

# ==============================================================================
# Server-Side Encryption (AES256)
# ==============================================================================

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ==============================================================================
# S3 Bucket Versioning (Protects Against Accidental Dataset Deletion)
# ==============================================================================

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ==============================================================================
# Strict Public Access Block (CIS AWS Benchmark Standard)
# Blocks all forms of public access to raw market datasets
# ==============================================================================

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
