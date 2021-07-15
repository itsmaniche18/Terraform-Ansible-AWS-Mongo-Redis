# Terraform-Ansible-AWS-Mongo-Redis
Provision secure AWS ec2_instance 3 app server, mongodb with ansible and redis with private IP from terraform.

Change the variables in terraform.tfvars.

terraform init

terraform plan --out="plan.out"

terraform apply "plan.out"