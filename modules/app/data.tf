data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "RHEL-9-DevOps-Practice"
  owners = ["973714476881"]
}
data "vault_generic_secret" "my_secret" {
  path = "common/vault"
}
