resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default_subnet_1" {
  availability_zone = var.az1
}

resource "aws_default_subnet" "default_subnet_2" {
  availability_zone = var.az2
}


module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster_name
  subnets      = [aws_default_subnet.default_subnet_1.id, aws_default_subnet.default_subnet_2.id]
  vpc_id       = aws_default_vpc.default.id
  tags         = merge({ "Name" = var.cluster_name }, var.tags)

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = var.node_group_settings["disk_size"]
  }

  node_groups = {
    "main-0" = {
      subnets          = [aws_default_subnet.default_subnet_1.id]
      desired_capacity = var.node_group_settings["desired_capacity"]
      max_capacity     = var.node_group_settings["max_capacity"]
      min_capacity     = var.node_group_settings["min_capacity"]
      instance_types   = var.node_group_settings["instance_types"]

      k8s_labels = {
        Environment = "${var.cluster_name}-${var.region}"
      }
      additional_tags = var.tags
    }
  }

  enable_irsa = true
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  cluster_version  = var.cluster_version
  write_kubeconfig = true
}

