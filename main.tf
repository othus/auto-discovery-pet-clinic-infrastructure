module "vpc" {
  source          = "./module/vpc"
  vpc_name        = "${var.projectname}_vpc"
  vpc_cidr_block  = var.vpc_cidr
  pub_sub_1       = "${var.projectname}_pub_sub_1"
  pub_sub_2       = "${var.projectname}_pub_sub_2"
  prvt_sub_1      = "${var.projectname}_prvt_sub_1"
  prvt_sub_2      = "${var.projectname}_prvt_sub_2"
  IGW             = "${var.projectname}_igw"
  NAT             = "${var.projectname}_nat"
  PrvtRT          = "${var.projectname}_prvtRT"
  PubRT           = "${var.projectname}_pubRT"
  eip             = "${var.projectname}_eip"
  pub_sub_1_cidr  = var.pub_sub_1_cidr
  pub_sub_2_cidr  = var.pub_sub_2_cidr
  prvt_sub_1_cidr = var.prvt_sub_1_cidr
  prvt_sub_2_cidr = var.prvt_sub_2_cidr
  az_1            = var.az_1
  az_2            = var.az_2
  all_cidr        = var.all_cidr
  # security group
  Bastion_Ansible_SG = "${var.projectname}_Bastion_Ansible_SG"
  Nexsu_SG           = "${var.projectname}_Nexus_SG"
  Docker_SG          = "${var.projectname}_Docker_SG"
  Jenkins_SG         = "${var.projectname}_SG"
  Sonarqube_SG       = "${var.projectname}_Sonarqube_SG"
  RDS_SG             = "${var.projectname}_RDS_SG"
  # Keypair
  keypair_name = "${var.projectname}_keypair"
}

# # Route53
# module "route53" {
#   source          = "./module/route53"
#   domain_name     = var.domain_name
#   domain_name2    = var.domain_name2
#   domain_name3    = var.domain_name3
#   domain_name4    = var.domain_name4
#   stage_dns_name  = module.env_lb.stage_lb_dns
#   stage_zone_id   = module.env_lb.stage_zone_id
#   prod_dns_name2 = module.env_lb.Prod_lb_dns
#   prod_zone_id2  = module.env_lb.Prod_zone_id
# }



# configure the data source to retrieve the database
# username and password from vault

# data "vault_generic_secret" "my_db_secret" {
#   path = "secret/database"
# }

# module "rds" {
#   source     = "./module/rds"
#   db_name    = var.projectname
#   db_SG_name = "${var.projectname}_db_subnet"
#   identifier = var.identifier
#   subnet_ids = [module.vpc.prvt_sub_1, module.vpc.prvt_sub_2]
#   RDS_SG     = module.vpc.RDS_SG
#   username   = var.rds_username #data.vault_generic_secret.my_db_secret.data["username"]
#   password   = var.rds_pwd      #data.vault_generic_secret.my_db_secret.data["password"]
# }

# module "Jenkins" {
#   source               = "./module/jenkins"
#   redhat_ami           = var.ami_redhat
#   instance_type2       = var.instance_type2
#   jenkins_SG_id        = module.vpc.Jenkins_SG
#   subnet_id            = module.vpc.pub_sub_1
#   keypair_name         = module.vpc.keypair_name
#   nexus_ip             = module.nexus.nexus_ip
#   jenkins_name         = "${var.project_name}_jenkins"
#   newrelic_license_key = var.newrelic_license_key
#   acct_id              = var.acct_id
#   subnet_id2           = module.vpc.pub_sub_1
#   elb_instance         = module.Jenkins.instance
#   elb_name             = "${var.project_name}-jenkins-lb"
#   elb_sg               = module.vpc.Jenkins_SG
# }

# module "sonarqube" {
#   source               = "./module/sonarqube"
#   ubuntu_ami           = var.ami_ubuntu
#   instance_type2       = var.instance_type2
#   subnet_id            = module.vpc.pub_sub_2
#   sonarqube_name       = "${var.project_name}_sonarqube"
#   Sonarqube_SG         = module.vpc.Sonarqube_SG
#   keypair_name         = module.vpc.keypair_name
#   newrelic_license_key = var.newrelic_license_key
#   acct_id              = var.acct_id
# }

module "nexus" {
  source               = "./module/nexus"
  redhat_ami           = var.ami_redhat
  instance_type        = var.instance_type2
  subnet_id            = module.vpc.pub_sub_2
  Nexus_SG             = module.vpc.Nexsu_SG
  keypair_name         = module.vpc.keypair_name
  nexus_name           = "${var.project_name}_nexus"
  newrelic_license_key = var.newrelic_license_key
  acct_id              = var.acct_id
}

# module "ansible" {
#   source                   = "./module/ansible"
#   ami_redhat2               = var.ami_redhat2
#   ansible_name             = "${var.projectname}_ansible_server"
#   keypair                  = module.vpc.keypair
#   keypair_name             = module.vpc.keypair_name
#   subnet_id                = module.vpc.pub_sub_1
#   ansible_SG               = module.vpc.Bastion_Ansible_SG
#   nexus_ip                 = module.nexus.nexus_ip
#   staging_discovery_script = "${path.root}/module/ansible/stage-env-bash-script.sh"
#   staging_playbook         = "${path.root}/module/ansible/stage-env-playbook.yml"
#   prod_discovery_script    = "${path.root}/module/ansible/prod-env-bash-script.sh"
#   prod_playbook            = "${path.root}/module/ansible/prod-env-playbook.yml"
#   newrelic_license_key     = var.newrelic_license_key
#   acct_id                  = var.acct_id
# }

module "Bastion" {
  source             = "./module/bastion_host"
  ami_redhat2         = var.ami_redhat2
  instance_type      = "t2.micro"
  privatekey         = module.vpc.keypair_name
  pub_sub_1          = module.vpc.pub_sub_1
  Bastion_Ansible_SG = module.vpc.Bastion_Ansible_SG
  keypair_name       = module.vpc.keypair_name
  bastion_name       = "${var.project_name}_bastion"
}

# module "env_lb" {
#   source        = "./module/env_lb"
#   vpc_name      = module.vpc.vpc_name
#   vpc_SG_ids    = [module.vpc.Docker_SG]
#   subnet_id     = [module.vpc.pub_sub_1, module.vpc.pub_sub_2]
#   # cert_arn      = module.route53.cert_arn
#   stage-lb-name = "${var.project_name}-${var.env}-docker-lb"
#   Prod-lb-name  = "${var.project_name}-${var.env1}-docker-lb"

# }

# module "autoscaling" {
#   source                = "./module/autoscaling"
#   ami_id                = var.ami_redhat
#   instance_type         = var.instance_type2
#   key_name              = module.vpc.keypair_name
#   lt_sg                 = [module.vpc.Docker_SG]
#   vpc_zone_identifier   = [module.vpc.prvt_sub_1, module.vpc.prvt_sub_2]
#   stage_tg_arn          = [module.env_lb.stage_tg_arn]
#   stage_asg_name        = "${var.project_name}_${var.env}_asg"
#   stage_asg_policy_type = "${var.project_name}_${var.env}_asg_policy"
#   stage_lt_name         = "${var.project_name}_${var.env}_launch_template"
#   prod_tg_arn           = [module.env_lb.Prod_tg_arn]
#   prod_asg_name         = "${var.project_name}_${var.env1}_asg"
#   prod_asg_policy_type  = "${var.project_name}_${var.env1}_asg_policy"
#   prod_lt_name          = "${var.project_name}_${var.env1}_launch_template"
#   nexus_ip              = module.nexus.nexus_ip
#   newrelic_license_key  = var.newrelic_license_key
#   acct_id               = var.acct_id
# }

