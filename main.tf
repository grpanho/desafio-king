provider "aws" {
  region = "sa-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaxDVQcwUejNKDo33Ej0SVv4PADCkE52JHi0l78b+iao7RHDFvtWdid+0Aq2AcoMRZwc8UyPVZWCRjAmKVbcZU9suuYtDzNtKwx0ebxbmlrGTYE1IKgJ0N3HajtUW4ym/8AG5psW9BPllSB/ULDx3Uk6RRz6//C7A2FCkan9rxLNfnC5kIYrCYthA9pv5HlpC6kCmT9ZVx4XI00m2iqBEDu00UgjS1IwfyvGoz80dZFQw1hRWkiGLC8XyS4JjI2t49MSjnWmlyXHS25X2K2XQ0uXbvZwEBxq1KFcg1LTKpeAjTw7NIx5InWSirl5BmKWP5eZO/EYHkjgKG7ezLOgMNrYW286mB865tvylEpIe6APUdE5z2xZMAbRpJxgUdVf1uiqg15VPJdlXFDl6m1XnN+MEi9bB6Fd4a3q2TE3vxjT05ATCdOz13RDo6t4CW1D3iSlM1yL0iBuIp1bhfBJbXqawiIVlHc7HrzuacR3+VJ0wpfDwGU2DQBM2+9rmbS7s= panho@n1-CW000678"
}
resource "aws_instance" "gitlab" {
  ami               = "ami-09b9b17384f68fd7c"
  instance_type     = "t2.micro"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "main-gitlab"
    Desc = "Gitlab host"
  }
}

resource "aws_ebs_volume" "gitlab-storage" {
  availability_zone = "sa-east-1a"
  size              = 15
  iops              = 2999
  type              = "gp3"

  tags = {
    Name = "storage-gitlab"
    Desc = "Persistent storage for gitlab"
  }
}

resource "aws_volume_attachment" "gitlab_disk_att" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.gitlab-storage.id
  instance_id = aws_instance.gitlab.id
}