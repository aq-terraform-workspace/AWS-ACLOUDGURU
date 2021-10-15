#!/bin/bash

terraform state rm 'module.route53'
terraform state rm 'module.alb'