#!/bin/bash

terraform state rm 'module.alb'
terraform state rm 'module.ssh_key'
terraform state rm 'module.ec2-instance'
terraform state rm 'module.eks'
terraform state rm 'module.base_network'
terraform state rm 'module.postgres'
terraform state rm 'module.sg_dmz'
terraform state rm 'module.sg_alb'
terraform state rm 'module.sg_eks'
terraform state rm 'module.sg_database'
terraform state rm 'module.monitoring_ecs'
terraform state rm 'random_integer.random'