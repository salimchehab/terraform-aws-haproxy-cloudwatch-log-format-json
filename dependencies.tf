data "aws_instance" "haproxy" {
  instance_tags = {
    Terraform = true
  }
  filter {
    name = "tag:Name"
    values = [
    "HAProxy"]
  }
}
