variable "region" {
  description = "AWS region"
  type        = string
  default = "eu-west-2"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.21"
}

variable "az1" {
  description = "AZ in which to deploy the node"
  type        = string
  default     = "eu-west-2a"
}

variable "az2" {
  description = "AZ in which to deploy the node"
  type        = string
  default     = "eu-west-2b"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    Terraform = true
    THORNode  = true
  }
}

variable "node_group_settings" {
  description = "Cluster node group settings"
  type = object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_types   = list(string)
    disk_size        = number
  })
  default = {
    desired_capacity = 1
    max_capacity     = 1
    min_capacity     = 1
    instance_types   = ["m5a.2xlarge"] # 8CPU/32GB
    disk_size        = 100
  }
}
