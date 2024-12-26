resource "aws_eks_cluster" "cluster" {
  name     = "ns2312-cluster"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = flatten([
      module.network.private_subnet_ids,
      module.network.public_subnet_ids
    ])
  }
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
  depends_on = [aws_iam_role_policy_attachment.aws_managed_cluster_policy]
}


resource "aws_iam_role" "cluster_role" {
  name = "ns2312-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_managed_cluster_policy" {
  role       = aws_iam_role.cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "aws-ebs-csi-driver"
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

module "alb-controller" {
  source            = "./eks-alb-controller"
  cluster_name      = "ns2312-cluster"
  vpc_id            = module.network.vpc_id
  cluster_endpoint  = aws_eks_cluster.cluster.endpoint
  cluster_ca_cert   = aws_eks_cluster.cluster.certificate_authority[0].data
  oidc_provider_arn = aws_iam_openid_connect_provider.oidc.arn
  oidc_provider_url = aws_iam_openid_connect_provider.oidc.url
}