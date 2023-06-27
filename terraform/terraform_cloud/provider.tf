terraform {

  cloud {
    organization = "optimus"

    workspaces {
      name = "TerraformCloudOnboarding"
    }
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.62.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.45.0"
    }
  }
}

provider "tfe" {
  # Configuration options
}


provider "azurerm" {
  # Configuration options
  features {
  }
}
