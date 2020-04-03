#VPC
resource "aws_vpc" "musketeer" {
    cidr_block = "172.0.0.0/22"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        Name = "musketeer"
    }
}

#SUBNET
resource "aws_subnet" "public-1"{
    vpc_id = aws_vpc.musketeer.id
    cidr_block = "172.0.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AWS_REGION["second"]}a"   
    tags = {
	Name = "m-public-1"
    }
}
resource "aws_subnet" "public-2"{
    vpc_id = aws_vpc.musketeer.id
    cidr_block = "172.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AWS_REGION["second"]}b"   
    tags = {
	Name = "m-public-2"
    }
}
resource "aws_subnet" "private-1"{
    vpc_id = aws_vpc.musketeer.id
    cidr_block = "172.0.2.0/24"
    availability_zone = "${var.AWS_REGION["second"]}a"   
    tags = {
	Name = "m-private-1"
    }
}
resource "aws_subnet" "private-2"{
    vpc_id = aws_vpc.musketeer.id
    cidr_block = "172.0.3.0/24"
    availability_zone = "${var.AWS_REGION["second"]}b"   
    tags = {
	Name = "m-private-2"
    }
}

#INTERNET-GATEWAY
resource "aws_internet_gateway" "ig"{
    vpc_id = aws_vpc.musketeer.id
    tags = {
	Name = "m-ig"
    }
}

#ROUTE-TABLE(public)
resource "aws_route_table" "rt-public"{
    vpc_id = aws_vpc.musketeer.id
    route {
	cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.ig.id
    }
    tags = {
	Name = "m-rt-public"
    }
}

#ROUTE-TABLE-ASSOCIATION(public)
resource "aws_route_table_association" "rta-public-1"{
    subnet_id = aws_subnet.public-1.id
    route_table_id = aws_route_table.rt-public.id
}
resource "aws_route_table_association" "rta-public-2"{
    subnet_id = aws_subnet.public-2.id
    route_table_id = aws_route_table.rt-public.id
}

#ELASTIC-IP
resource "aws_eip" "eip"{
    vpc = true
}

#NAT-GATEWAY
resource "aws_nat_gateway" "ng"{
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public-1.id
    depends_on = ["aws_internet_gateway.ig"]
    tags = {
        Name = "m-ng"
    }
}

#ROUTE-TABLE-ASSOCIATION(private)
resource "aws_route_table" "rt-private"{
    vpc_id = aws_vpc.musketeer.id
    route {
	cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.ig.id
    }
    tags = {
	Name = "m-rt-private"
    }
}

#ROUTE-TABLE-ASSOCIATION(private)
resource "aws_route_table_association" "rta-private-1"{
    subnet_id = aws_subnet.private-1.id
    route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "rta-private-2"{
    subnet_id = aws_subnet.private-2.id
    route_table_id = aws_route_table.rt-private.id
}
