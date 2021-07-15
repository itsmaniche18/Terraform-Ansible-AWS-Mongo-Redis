resource "aws_instance" "app-landing" {
  ami           = var.IMAGE_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME
  tags = {
    Name = "app-landing"
  }
  vpc_security_group_ids = [aws_security_group.app-webapp.id]
  root_block_device {
    volume_size = 20
  }
  private_ip = "10.10.10.10"
  subnet_id  = aws_subnet.app-subnet-public.id

  #Install Docker and dockerCompose
  provisioner "file" {
    source      = var.SOURCE
    destination = var.DESTINATION
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/files/install.sh",
      "sudo /tmp/files/install.sh",
    ]
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "app-front" {
  ami           = var.IMAGE_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME
  tags = {
    Name = "app-front"
  }
  vpc_security_group_ids = [aws_security_group.app-webapp.id]
  root_block_device {
    volume_size = 10
  }
  private_ip = "10.10.10.11"
  subnet_id  = aws_subnet.app-subnet-public.id
  #Install Docker and dockerCompose
  provisioner "file" {
    source      = var.SOURCE
    destination = var.DESTINATION
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/files/install.sh",
      "sudo /tmp/files/install.sh",
    ]
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "app-back" {
  ami           = var.IMAGE_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME
  tags = {
    Name = "app-back"
  }
  vpc_security_group_ids = [aws_security_group.app-webapp.id]
  root_block_device {
    volume_size = 50
  }
  private_ip = "10.10.10.12"
  subnet_id  = aws_subnet.app-subnet-public.id
  #Install Docker and dockerCompose
  provisioner "file" {
    source      = var.SOURCE
    destination = var.DESTINATION
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/files/install.sh",
      "sudo /tmp/files/install.sh",
    ]
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }

}

resource "aws_instance" "app-mongo" {
  ami           = var.IMAGE_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME
  tags = {
    Name = "app-mongo"
  }
  vpc_security_group_ids = [aws_security_group.app-mongo.id]
  root_block_device {
    volume_size = 50
  }
  private_ip = "10.10.10.13"
  subnet_id  = aws_subnet.app-subnet-public.id

  provisioner "remote-exec" {
    inline = ["sudo apt-get update && sudo apt install python apt-transport-https -y"]
  }

  connection {
    host        = self.public_ip
    private_key = file(var.PRIVATE_KEY)
    user        = var.USER
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.USER} -i '${aws_instance.app-mongo.public_ip},' --private-key ${var.PRIVATE_KEY} ${path.module}/provision/roles/mongodb/tasks/main.yml"
  }
}

resource "aws_instance" "app-redis" {
  ami           = var.IMAGE_ID
  instance_type = var.INSTANCE_TYPE_REDIS
  key_name      = var.KEY_NAME
  tags = {
    Name = "app-redis"
  }
  vpc_security_group_ids = [aws_security_group.app-redis.id]
  root_block_device {
    volume_size = 10
  }
  private_ip = "10.10.10.14"
  subnet_id  = aws_subnet.app-subnet-public.id
  #Install Redis
  provisioner "file" {
    source      = var.SOURCE
    destination = var.DESTINATION
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/files/redis.sh",
      "sudo /tmp/files/redis.sh",
    ]
    connection {
      user        = var.USER
      private_key = file(var.PRIVATE_KEY)
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "app-webapp" {
  name        = "app-webapp"
  description = "Allow ssh and webport"
  vpc_id      = aws_vpc.app-vpc.id
  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-mongo" {
  name        = "app-mongo"
  description = "Allow ssh and db port"
  vpc_id      = aws_vpc.app-vpc.id

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow mongoDB Port"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    #    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.app-webapp.id}"]
  }
  egress {
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-redis" {
  name        = "app-redis"
  description = "Allow ssh and redisPort"
  vpc_id      = aws_vpc.app-vpc.id

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow redis Port"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    #    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.app-webapp.id}"]
  }
  egress {
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip_association" "eip-app-landing" {
  instance_id   = aws_instance.app-landing.id
  allocation_id = aws_eip.eip-app-landing.id
}

resource "aws_eip_association" "eip-app-front" {
  instance_id   = aws_instance.app-front.id
  allocation_id = aws_eip.eip-app-front.id
}

resource "aws_eip_association" "eip-app-back" {
  instance_id   = aws_instance.app-back.id
  allocation_id = aws_eip.eip-app-back.id
}

resource "aws_eip" "eip-app-landing" {
  vpc = true
}

resource "aws_eip" "eip-app-front" {
  vpc = true
}

resource "aws_eip" "eip-app-back" {
  vpc = true
}
output "app-landing" {
  value = aws_instance.app-landing.public_ip

}

output "app-front" {
  value = aws_instance.app-front.public_ip
}

output "app-back" {
  value = aws_instance.app-back.public_ip
}
