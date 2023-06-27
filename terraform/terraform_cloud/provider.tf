terraform {

  cloud {
    organization = "optimus"

    workspaces {
      name = "TerraformCloudOnboarding"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.45.0"
    }
  }
}

provider "tfe" {
  # Configuration options
}


