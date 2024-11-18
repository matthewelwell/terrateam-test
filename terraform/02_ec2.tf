resource "aws_instance" "coreapi" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  key_name = "orange-example-keypair"
  user_data = data.cloudinit_config.core_api_config.rendered

  vpc_security_group_ids = [
    aws_security_group.flagsmith_orange_external_sg.id
  ]
  availability_zone = data.aws_availability_zones.available.names[0]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "core_api"
  }
}
