resource "aws_s3_bucket" "bucket" {
    bucket = "tfstatestorage-projectpoc"
    object_lock_enabled = true 
}


resource "aws_s3_bucket_versioning" "mystate-storage-versioning" {
  bucket = aws_s3_bucket.bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "myobjectlock" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mySSEconfig" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

/*
resource "aws_s3_bucket_acl" "mybucketacl" {
  bucket = aws_s3_bucket.aws_s3_bucket.bucket.bucket
  acl    = "private"
}
*/

