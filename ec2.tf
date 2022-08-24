module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name                   = "demo-instance"
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  key_name               = "anhquach"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Type        = "my-test-backup"
  }
}