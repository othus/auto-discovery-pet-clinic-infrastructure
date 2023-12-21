provider "aws" {
  profile = var.profilename
  region  = var.region
}

# # Vault provider
# provider "vault" {
#   address = "https://${var.domain}"
#   token   = var.token
# }