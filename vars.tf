variable "AWS_ACCESS_KEY" {

}
variable "AWS_SECRET_KEY" {
    
}
variable "AWS_REGION" {
    type = map
    default = {
	first = "us-east-1"
	second = "us-east-2"
    }
}
variable "AMIS" {
    type = map
    default = {
	linux = "ami-0fc20dd1da406780b"
	windows = "ami-07f3715a1f6dbb6d9"
    }
}
