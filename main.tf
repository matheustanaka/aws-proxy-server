#
# Networking
#

module "networking" {
  source            = "./modules/networking/"
  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  availability_zone = var.availability_zone
}

module "server" {
  source                 = "./modules/server/"
  project_name           = var.project_name
  region                 = var.region
  public_key             = var.public_key
  vpc_security_group_ids = module.networking.vpc_security_group_ids
  subnet_id              = module.networking.subnet_id
}
