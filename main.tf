resource "random_id" "random_string" {
  byte_length = 8
}

resource "aws_kms_key" "kms1key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "bootcamp29-${random_integer.random_number.result}-gbengs"
  acl    = "private"


  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse1" {
  bucket = "bootcamp29-${random_integer.random_number.result}-gbengs"

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms1key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "random_integer" "random_number" {
  min = 1000
  max = 1050
}





#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#         kms_master_key_id = "alias/aws/s3"
#       }
#     }
#   }