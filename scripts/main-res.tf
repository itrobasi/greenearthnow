provider "aws" {
    region = "us-east-1"
}


// 1. Jenkins Server
resource "aws_instance" "srv_jenkins" {
    ami = "ami-0e472ba40eb589f49"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "next"
    security_groups = [aws_security_group.sg_ports_traffic-1.name]

user_data = "${file("jenkins.sh")}"

    tags = {
        "Name" = "Jenkins Server"
    }
}

// 2. App/Tomcat Server
resource "aws_instance" "srv_appserv" {
    ami = "ami-0e472ba40eb589f49"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "next"
    security_groups = [aws_security_group.sg_ports_traffic-2.name]

user_data = "${file("tomcat-server.sh")}"

    tags = {
        "Name" = "Application TomCat Server"
    }
}

// 32. S3 Bucket

resource "aws_s3_bucket" "myS3bucket" {
  bucket = "www.green.myntblack.com"

  tags = {
    Name        = "www.green.myntblack.com"
  }
}

// Security Groups

resource "aws_security_group" "sg_ports_traffic-1" {
  name        = "wwwSecGrp1"
  description = "Limits Traffic"

  ingress {
    description      = "Jenkins"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["47.18.23.252/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["47.18.23.252/32"]
   
  }

  egress {
    description      = "OutBound_Traffic-Any"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wwwSecGrp1"
  }
}

resource "aws_security_group" "sg_ports_traffic-2" {
  name        = "wwwSecGrp2"
  description = "Limits Traffic"

  ingress {
    description      = "AppServer"
    from_port        = 10000
    to_port          = 10100
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["47.18.23.252/32"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "OutBound_Traffic-Any"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wwwSecGrp2"
  }
}
output "JEPI" {
    value = "${aws_instance.srv_jenkins.private_ip}"
}

output "SQPI" {
    value = "${aws_instance.srv_sonar.private_ip}"
}


output "DOCPI" {
    value = "${aws_instance.srv_Docker.private_ip}"
}
