resource "aws_iam_role" "worker_nodes_role" {
  name = "ns2312-cluster-worker-node-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "worker_nodes_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "worker_nodes_ecr_read_only_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "worker_nodes_eks_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "worker_nodes_ebs_csi_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.worker_nodes_role.name
}



resource "aws_eks_node_group" "worker_nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "ns2312-cluster-worker-node-group"
  node_role_arn   = aws_iam_role.worker_nodes_role.arn
  subnet_ids      = module.network.private_subnet_ids
  ami_type        = "AL2_x86_64"
  instance_types  = ["t2.medium"]
  remote_access {
    ec2_ssh_key = "ns2312-cluster-kp"
  }
  # launch_template {
  #   id      = aws_launch_template.worker_nodes_launch_template.id
  #   version = aws_launch_template.worker_nodes_launch_template.latest_version
  # }
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.worker_nodes_eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.worker_nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker_nodes_ecr_read_only_policy_attachment,
    aws_iam_role_policy_attachment.worker_nodes_ebs_csi_policy_attachment
  ]
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "worker_nodes_launch_template" {
  name          = "ns2312-cluster-worker-nodes-launch-template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"
  key_name      = "ns2312-cluster-kp"
}