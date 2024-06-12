terraform {
  # 1. Required Version Terraform
  required_version = ">= 1.0"
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.107.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Terraform State Storage to Azure Storage Container
  #   backend "azurerm" {
  #     resource_group_name   = "terraform-storage-rg"
  #     storage_account_name  = "terraformstatexlrwdrzs"
  #     container_name        = "tfstatefiles"
  #     key                   = "terraform.tfstate"
  #   }  
}


# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {
  # tenant_id = "503e0bc9-7bfc-47a9-889d-380d9df0a0fc"
}

# 3. Terraform Resource Block: Define a Random Pet Resource
provider "random" {}