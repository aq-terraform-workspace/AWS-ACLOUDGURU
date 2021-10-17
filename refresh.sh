#!/bin/bash

terraform state rm 'module.base_network'
terraform state rm 'module.route53'
terraform state rm 'module.lb'
terraform state rm 'module.monitoring_ecs'