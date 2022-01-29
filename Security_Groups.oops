# -------------- Security Group for bastion host -----------------------
resource "aws_security_group" "controller-ssh" {
  name        = "ssh"
  description = "allow SSH from MyIP"
  vpc_id      = module.vpc.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.ssh_location}"]

  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    Name          = "${var.environment}-Controller-SG"
    Stage         = "${var.environment}"
    Owner         = "${var.your_name}"
  }
}

# -------------- Security Group for Web Servers -----------------------
resource "aws_security_group" "web-sg" {
  name        = "Web-SG"
  description = "allow SSH from Controller and HTTP from my IP"
  vpc_id      = module.vpc.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    security_groups  = ["${aws_security_group.controller-ssh.id}"]
    }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
    }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name          = "${var.environment}-web-SG"
    Stage         = "${var.environment}"
    Owner         = "${var.your_name}"
  }
}

resource "aws_security_group" "app-sg" {
  name          = "App-SG"
  description   = "allow HTTP from Load Balancer, & SSH from controller"
  vpc_id      = module.vpc.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.controller-ssh.id}"]
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "APP-SG"
  }
}

resource "aws_security_group" "alb-sg" {
  name          = "LB-SG"
  description   = "allow Http, HTTPS"
  vpc_id      = module.vpc.vpc_id

  ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "ALB-SG"
  }
}

# # -------------- Security Group for MysQL or MariaDB Servers -----------------------
# resource "aws_security_group" "MySQL-sg" {
#   name        = "MySQL-SG"
#   description = "allow SSH from Controller and MySQL from my IP and from web servers"
#   vpc_id      = module.vpc.vpc_id
#   ingress {
#     protocol    = "tcp"
#     from_port   = 22
#     to_port     = 22
#     security_groups  = ["${aws_security_group.controller-ssh.id}"]
#     }

#     ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["${var.ssh_location}"]
#     security_groups  = ["${aws_security_group.web-sg.id}", "${var.ssh_location}"]
#     }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#     }
#     tags = {
#     Name          = "${var.environment}-MySQL-SG"
#     Stage         = "${var.environment}"
#     Owner         = "${var.your_name}"
#   }
# }

# # -------------- Security Group for PostgreSQL Servers -----------------------
# resource "aws_security_group" "PostgreSQL-sg" {
#   name        = "PostgreSQL-SG"
#   description = "allow SSH from Controller and PostgreSQL from my IP and from web servers"
#   vpc_id      = module.vpc.vpc_id
#   ingress {
#     protocol    = "tcp"
#     from_port   = 22
#     to_port     = 22
#     security_groups  = ["${aws_security_group.controller-ssh.id}"]
#     }

#     ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["${var.ssh_location}"]
#     security_groups  = ["${aws_security_group.web-sg.id}", "${var.ssh_location}"]
#     }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#     }
#     tags = {
#     Name          = "${var.environment}-PSQL-SG"
#     Stage         = "${var.environment}"
#     Owner         = "${var.your_name}"
#   }
# }