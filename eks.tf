resource "aws_eks_cluster" "demo" {
    name = "m-cluster"
    role_arn = "arn:aws:iam::351441645959:role/eks-cluster-role"

}
