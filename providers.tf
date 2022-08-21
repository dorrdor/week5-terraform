# Configure the Azure provider.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "RG"
  #   storage_account_name = "Account0528799210"
  #   container_name       = "StorageContainer"
  #   key                  = "Dorrdor55.tfstate"
  # }
}


# This block specifies the cloud provider as Azure.
provider "azurerm" {
  features {}
}

  