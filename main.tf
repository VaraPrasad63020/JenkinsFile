#provider
/*
provider "aws" {

    region ="ap-south-1"
      

}*/

#Resource of multiple applications

resource "aws_instance" "multiple_applications" {

    ami="ami-0c42696027a8ede58"

    instance_type = "t2.micro"

    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    depends_on = [ aws_key_pair.tf-key-pair ]

    tags = {

        Name="RaptrApp"

    }

    key_name = "tf-key-pair"

    connection {

    type = "ssh"

    host = self.public_ip

    user = "ec2-user"

    //private_key = file("Multiple-keypair")    
    private_key = file(var.keypair)    


 }

 provisioner "remote-exec" {

  inline = [

"sudo yum update –y",

"sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo",

"sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",

"sudo yum upgrade",

"sudo dnf install java-17-amazon-corretto -y",

"sudo yum install jenkins -y",

"sudo systemctl enable jenkins",

"sudo systemctl start jenkins",

"jenkins --version",

"sudo dnf update",

"sudo dnf install docker -y",

"sudo systemctl enable docker",

"sudo systemctl start docker.service",

"docker --version",

"sudo dnf install -y redis6",

"sudo systemctl enable redis6",

"sudo systemctl start redis6",

"sudo systemctl is-enabled redis6",

"redis6-server --version",

   ]

    }  

   

  }

resource "aws_db_instance" "RDS_DB" {

  identifier           = "mysql-db-01"

  engine               = "mysql"

  engine_version       = "5.7"

  instance_class       = "db.t2.micro"  

  username             = "admin"

  password             = "admin_123"

  allocated_storage    = 20

  parameter_group_name = "default.mysql5.7"

  skip_final_snapshot  = true

  publicly_accessible = true
 
  vpc_security_group_ids = [aws_security_group.allow_sql.id]

}

resource "aws_security_group" "allow_sql" {
  
  name="RaptrDBSecGrp"

  description = "Allow sql connections"

  ingress {

    # SSH Port 3306 allowed from any IP

    from_port   = 3306

    to_port     = 3306

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_security_group" "allow_ssh" {

  name        = "RaptrAppSecGrp"

  description = "Allow SSH and other  traffic"

  #vpc_id      = aws_vpc.vpc_demo.id

 

  ingress {

    # SSH Port 22 allowed from any IP

    from_port   = 22

    to_port     = 22

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

 

  ingress {

    # SSH Port 80 allowed from any IP

    from_port   = 80

    to_port     = 80

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    # SSH Port 3000 allowed from any IP

    from_port   = 3000

    to_port     = 3000

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    # SSH Port 80 allowed from any IP

    from_port   = 8080

    to_port     = 8080

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  

  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  

}