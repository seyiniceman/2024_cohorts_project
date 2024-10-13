
provider "aws" {
  region  = "eu-west-1"
  profile = "Seyi"
}


# Create a VPC
resource "aws_vpc" "ProdVpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "Production_VPC"
  }
}

# Create a subnet
resource "aws_subnet" "ProdSubnet" {
  vpc_id                  = aws_vpc.ProdVpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "Subnet.ID"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ProdVpc.id

  tags = {
    Name = "Prod_igw"
  }
}

# Create a Route Table
resource "aws_route_table" "Prodroute" {
  vpc_id = aws_vpc.ProdVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.ProdSubnet.id
  route_table_id = aws_route_table.Prodroute.id
}

# Create a Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow inbound traffic for Jenkins and Tomcat"
  vpc_id      = aws_vpc.ProdVpc.id

  ingress {
    description = "Allow SSH inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["${var.my_ip}/32"]
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

ingress {
    description = "HTTP"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow traffic for Jenkins and Tomcat"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "HTTP"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Jenkins Server
resource "aws_instance" "first_ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.large"
  key_name               = "June2024"          # Key pair for SSH access
  availability_zone      = "eu-west-1a"
  subnet_id              = aws_subnet.ProdSubnet.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  user_data              = file("install_jenkins.sh")
  tags = {
    Name = "Jenkins Server"
  }
}

# Tomcat Server
resource "aws_instance" "Second_ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "June2024"          # Key pair for SSH access
  availability_zone      = "eu-west-1a"
  subnet_id              = aws_subnet.ProdSubnet.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  user_data              = file("install_tomcat.sh")
  tags = {
    Name = "Tomcat Server"
  }
}

resource "aws_instance" "thirdinstance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  subnet_id              = aws_subnet.ProdSubnet.id
  key_name               = "June2024"
  availability_zone      = "eu-west-1a"
  user_data              = file("install_sonarqube.sh")
  


  tags = {
    Name = "SonarQube_Server"
  }
}

resource "aws_instance" "fourthinstance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  subnet_id              = aws_subnet.ProdSubnet.id
  key_name               = "June2024"
  availability_zone      = "eu-west-1a"
  user_data              = file("install_nexus.sh")

  tags = {
    Name = "Nexus_Server"
  }
}
# Output Jenkins Server URL
output "jenkins_url" {
  value       = "http://${aws_instance.first_ubuntu.public_ip}:8080"
  description = "Jenkins Server URL"
}

# Output Tomcat Server URL
output "tomcat_url" {
  value       = "http://${aws_instance.Second_ubuntu.public_ip}:8080"
  description = "Tomcat Server URL"
}

# print the url of the SonaQube server
output "SonaQube_website_url3" {
  value     = join ("", ["http://", aws_instance.thirdinstance.public_ip, ":", "9000"])
  description = "SonaQube Server is thirdinstance"
}

# print the url of the Nexus server
output "Nexus_website_url4" {
  value     = join ("", ["http://", aws_instance.fourthinstance.public_ip, ":", "8081"])
  description = "Nexus Server is fourthinstance"
}






