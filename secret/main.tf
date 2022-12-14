provider "aws" {
  region = "eu-west-2"
}

variable "vaulttoken" {
  type = string
  
}

provider "vault" {
  token  = var.vaulttoken
}

data "vault_generic_secret" "credentials" {
  path = "secret/Database"
}

resource "aws_db_instance" "myRDS" {
  db_name             = "myRD"
  identifier          = "my-first-rds"
  instance_class      = "db.t2.micro"
  engine              = "mariadb"
  engine_version      = "10.2.21"
  username            = data.vault_generic_secret.credentials.data["dbuser"]
  password            = data.vault_generic_secret.credentials.data["dbpassword"]
  port                = 3306
  allocated_storage   = 20
  skip_final_snapshot = true
}
