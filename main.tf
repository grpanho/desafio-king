provider "aws" {
  region = "sa-east-1"
}

resource "aws_key_pair" "access-key" {
  key_name   = "my-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaxDVQcwUejNKDo33Ej0SVv4PADCkE52JHi0l78b+iao7RHDFvtWdid+0Aq2AcoMRZwc8UyPVZWCRjAmKVbcZU9suuYtDzNtKwx0ebxbmlrGTYE1IKgJ0N3HajtUW4ym/8AG5psW9BPllSB/ULDx3Uk6RRz6//C7A2FCkan9rxLNfnC5kIYrCYthA9pv5HlpC6kCmT9ZVx4XI00m2iqBEDu00UgjS1IwfyvGoz80dZFQw1hRWkiGLC8XyS4JjI2t49MSjnWmlyXHS25X2K2XQ0uXbvZwEBxq1KFcg1LTKpeAjTw7NIx5InWSirl5BmKWP5eZO/EYHkjgKG7ezLOgMNrYW286mB865tvylEpIe6APUdE5z2xZMAbRpJxgUdVf1uiqg15VPJdlXFDl6m1XnN+MEi9bB6Fd4a3q2TE3vxjT05ATCdOz13RDo6t4CW1D3iSlM1yL0iBuIp1bhfBJbXqawiIVlHc7HrzuacR3+VJ0wpfDwGU2DQBM2+9rmbS7s= panho@n1-CW000678"
}

# Instances
resource "aws_instance" "gitlab" {
  ami               = "ami-09b9b17384f68fd7c"
  instance_type     = "t2.micro"
  availability_zone = "sa-east-1a"
  key_name          = aws_key_pair.access-key.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.gitlab-host-nic.id
  }

  depends_on = [aws_internet_gateway.gw_internet]

  tags = {
    Name = "main_gitlab"
    Desc = "Gitlab host"
  }
}

resource "aws_ebs_volume" "gitlab_storage" {
  availability_zone     = "sa-east-1a"
  size                  = 15
  iops                  = 2500
  type                  = "gp3"

  tags = {
    Name = "storage-gitlab"
    Desc = "Persistent storage for gitlab mount points"
  }
}

resource "aws_volume_attachment" "gitlab_disk_att" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.gitlab_storage.id
  instance_id = aws_instance.gitlab.id
}

# Network
resource "aws_vpc" "gitlab_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "gitlab-vpc"
    Desc = "VPC for gitlab related services"
  }
}

resource "aws_internet_gateway" "gw_internet" {
  vpc_id     = aws_vpc.gitlab_vpc.id
  depends_on = [aws_vpc.gitlab_vpc]

  tags = {
    Name = "gw_internet"
    Desc = "Gateway for VPC internet access"
  }
}

resource "aws_route_table" "gitlab_vpc_route_table" {
  vpc_id = aws_vpc.gitlab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_internet.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw_internet.id
  }

  tags = {
    Name = "gitlab_vpc_route_table"
    Desc = "Routing table for gitlab VPC, internet access setted here"
  }
}

resource "aws_subnet" "subnet_gitlab_host" {
  vpc_id            = aws_vpc.gitlab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "Gitlab Host Subnet"
  }
}

resource "aws_route_table_association" "route_subnet_gitlab" {
  subnet_id      = aws_subnet.subnet_gitlab_host.id
  route_table_id = aws_route_table.gitlab_vpc_route_table.id
}

resource "aws_security_group" "web_and_ssh" {
  name        = "allow_web_ssh_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.gitlab_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_and_ssh"
    Desc = "Allow inbound web and ssh"
  }
}

resource "aws_security_group" "all_outbound" {
  name        = "allow_outbound_traffic"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.gitlab_vpc.id

  egress {
    description = "allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "all_outbound"
    Desc = "Allow all outbound traffic"
  }
}

resource "aws_network_interface" "gitlab-host-nic" {
  subnet_id       = aws_subnet.subnet_gitlab_host.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.web_and_ssh.id, aws_security_group.all_outbound.id]
}

resource "aws_eip" "gitlab_public_ip" {
  vpc               = true
  network_interface = aws_network_interface.gitlab-host-nic.id
  depends_on        = [aws_internet_gateway.gw_internet]

  tags = {
    Name = "Gitlab Public IP"
  }
}

output "gitlab_public_ip" {
  value = aws_eip.gitlab_public_ip.public_ip
}
