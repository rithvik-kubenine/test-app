terraform {
  backend "s3" {
    bucket       = "rithvik-tf-statelockbucket"
    key          = "t349/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
