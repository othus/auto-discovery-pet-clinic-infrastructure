module "vpc" {
  source = "./module/vpc"
  vpc_name = "${var.projectname}_vpc"
  vpc_cidr_block = var.vpc_cidr
  pub_sub_1 = "${var.projectname}_pub_sub_1"
  pub_sub_2 = "${var.projectname}_pub_sub_2"
  prvt_sub_1 = "${var.projectname}_prvt_sub_1"
  prvt_sub_2 = "${var.projectname}_prvt_sub_2"
  IGW = "${var.projectname}_igw"
  NAT = "${var.projectname}_nat"
  PrvtRT = "${var.projectname}_prvtRT"
  PubRT = "${var.projectname}_pubRT"
  eip = "${var.projectname}_eip"
  pub_sub_1_cidr = var.pub_sub_1_cidr
  pub_sub_2_cidr = var.pub_sub_2_cidr
  prvt_sub_1_cidr = var.prvt_sub_1_cidr
  prvt_sub_2_cidr = var.prvt_sub_2_cidr
  az_1 = var.az_1
  az_2 = var.az_2
  all_cidr = var.all_cidr
  # security group
  Bastion_Ansible_SG = "${var.projectname}_Bastion_Ansible_SG"
  Nexsu_SG = "${var.projectname}_Nexus_SG"
  Docker_SG = "${var.projectname}_Docker_SG"
  Jenkins_SG = "${var.projectname}_SG"
  Sonarqube_SG = "${var.projectname}_Sonarqube_SG"
  RDS_SG = "${var.projectname}_RDS_SG"
  keypair_name = "${var.projectname}_keypair"

}

# configure the data source to retrieve the database
# username and password from vault

data "vault_generic_secret" "my_db_secret" {
  path = "secret/database"
}

module "rds" {
  source = "./module/rds"
  db_name = var.projectname
  db_SG_name = "${var.projectname}_db_subnet"
  identifier = var.identifier
  subnet_ids = [module.vpc.prvt_sub_1, module.vpc.prvt_sub_2]
  RDS_SG = module.vpc.RDS_SG
  username = data.vault_generic_secret.my_db_secret.data["username"]
  password = data.vault_generic_secret.my_db_secret.data["password"]
}  