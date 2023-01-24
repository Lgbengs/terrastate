resource "random_id" "random_string" {
  byte_length = 8
}

resource "aws_s3_bucket" "state_storage" {
  bucket = "bootcamp29-${random_int.random_number.result}-gbengs"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "alias/aws/s3"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "random_int" "random_number" {
  min = 1000
  max = 1050
}