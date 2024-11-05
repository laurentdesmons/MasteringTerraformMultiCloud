#
# main config
#
terraform {
  required_version = ">= 1.9.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.8.0"
    }
  }
}

#
# azure provider
#
provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "main"
  subscription_id                 = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

