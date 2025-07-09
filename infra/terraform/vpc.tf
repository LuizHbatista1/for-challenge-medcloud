resource "aws_vpc" "vpc" {
    cidr_block = lookup(var.environment_configs[terraform.workspace], "vpc_cidr", "10.0.0.0/16")
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "${terraform.workspace}-vpc"
        Environment = terraform.workspace
    }
}

resource "aws_subnet" "sn1" {
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
    vpc_id = aws_vpc.vpc.id
    availability_zone = "sa-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "${terraform.workspace}-subnet-1"
        Environment = terraform.workspace
    }
}

resource "aws_subnet" "sn2" {
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
    vpc_id = aws_vpc.vpc.id
    availability_zone = "sa-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "${terraform.workspace}-subnet-2"
        Environment = terraform.workspace
    }
}

resource "aws_subnet" "sn3" {
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 3)
    vpc_id = aws_vpc.vpc.id
    availability_zone = "sa-east-1c"
    map_public_ip_on_launch = true

    tags = {
        Name = "${terraform.workspace}-subnet-3"
        Environment = terraform.workspace
    }
}

resource "aws_security_group" "sg" {
    name = "${terraform.workspace}-sg"
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${terraform.workspace}-security-group"
        Environment = terraform.workspace
    }
    ingress {

        description = "https"
        from_port = "443"
        to_port = "443"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        description = "http"
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Adicione regra para MySQL
    ingress {
        description = "MySQL"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        self = true
    }

    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "app-igw"
  }
}

# Route Table
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "app-rtb"
  }
}

# Route Table Association para cada subnet
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sn2.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.sn3.id
  route_table_id = aws_route_table.rtb.id
}