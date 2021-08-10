data "aws_ebs_volume" "binance-daemon" {
  most_recent = true

  filter {
    name = "tag:kubernetes.io/created-for/pvc/name" 
    values = ["binance-daemon"]
  }
}

data "aws_ebs_volume" "bifrost" {
  most_recent = true

  filter {
    name = "tag:kubernetes.io/created-for/pvc/name" 
    values = ["bifrost"]
  }
}

data "aws_ebs_volume" "thor-daemon" {
  most_recent = true

  filter {
    name = "tag:kubernetes.io/created-for/pvc/name" 
    values = ["thor-daemon"]
  }
}

data "aws_ebs_volume" "midgard" {
  most_recent = true

  filter {
    name = "tag:kubernetes.io/created-for/pvc/name" 
    values = ["midgard"]
  }
}

locals {
  pvc_snapshot_volume_ids = [
    data.aws_ebs_volume.binance-daemon.id,
    data.aws_ebs_volume.bifrost.id,
    data.aws_ebs_volume.thor-daemon.id,
    data.aws_ebs_volume.midgard.id,
  ]
}

resource "aws_ec2_tag" "pvc_snapshot_volumes" {
  count = length(local.pvc_snapshot_volume_ids)

  resource_id = local.pvc_snapshot_volume_ids[count.index]
  key         = "Snapshot"
  value       = "true"
}