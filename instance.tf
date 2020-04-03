resource "aws_instance" "demo" {
    ami = var.AMIS["linux"]
    instance_type = "t2.micro"
    subnet_id = "subnet-0c26575ca74b2e05d"
    tags = {
        Name = "demo"
    }
}
