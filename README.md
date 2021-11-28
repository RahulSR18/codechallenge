# Introduction 
Deploys three tier Environment Virtual Machines to your provided VNet
# Getting Started
This Terraform module deploys Virtual Machines in Azure with the following characteristics:
* Network terraform scripts deploy virtual network and create three subnet for web, app and db
* Ability to deploy windows and linux virtual machines
* VM nics attached to a single virtual network subnet of your choice (web,app and db subnet) based on env value
# Module Usage
```
terraform {
  backend "azurerm" {
    resource_group_name     = "Resourcegroupname"
    storage_account_name    = "storageaccountname"
    container_name          = "containername"
    key                     = "terraform.tfstate"
  }
  required_providers {
    azurerm                 = {
    source                  = "hashicorp/azurerm"
    version                 = ">= 2.80.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vmdeploy"{
    source                  = "./azurevm"
    resource_group_name     = "Resourcegroupname"
    location                = "Central US"
    env                     = "Dev"
    vmname                  = "terrachallengevm01"
    os_type                 = "Linux"
    vm_count                = 2
    tier                    = "app"
    vm_sku                  = "Standard_B1s"
}
```