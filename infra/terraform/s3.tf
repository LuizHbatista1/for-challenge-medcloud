resource "aws_s3_bucket" "application_bucket" {
    bucket = "${terraform.workspace}-challenge-medcloud"
}