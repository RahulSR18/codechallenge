terraform {
  required_providers {
    azurerm                         = {
    source                          = "hashicorp/azurerm"
    version                         = ">= 2.80.0"
    }
  }
}

locals{
    subnet_name = {
        "web"                       = "web-subnet"
        "app"                       = "app-subnet"
        "db"                        = "db-subnet"
    }
}

data "azurerm_virtual_network" "virtual_network" {
    name                              = var.vnetname
    resource_group_name               = var.vnet_rg
}

data "azurerm_subnet" "subnet" {
    name                              = lookup("${local.subnet_name}", var.tier, "error")
    resource_group_name               = var.vnet_rg
    virtual_network_name              = var.vnetname
}

data "azurerm_key_vault" "kvvault" {
    name                                = "vmpasskey"
    resource_group_name                 = "codechallenge"
}

resource "random_password" "vmpassword" {
    count                             = var.vm_count
    length                            = 20
    special                           = true
}

resource "azurerm_key_vault_secret" "kvsecret" {
    count                             = var.vm_count
    name                              = "vmpassword${count.index}"
    value                             = random_password.vmpassword[count.index].result
    key_vault_id                      = data.azurerm_key_vault.kvvault.id
}

resource "azurerm_resource_group" "resource_group_name" {
    name                              = var.resource_group_name
    location                          = var.location
    tags = {
        Env                             = var.env
    }
}

resource "azurerm_network_interface" "network_interface" {
    count                             = var.vm_count
    name                              = "eth-${var.vmname}${count.index}-nic01"
    location                          = azurerm_resource_group.resource_group_name.location
    resource_group_name               = azurerm_resource_group.resource_group_name.name

    ip_configuration {
        name                            = "ipconfig"
        subnet_id                       = data.azurerm_subnet.subnet.id
        private_ip_address_allocation   = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "virtual_machine" {
    count                             = "${(lower(var.os_type) == "linux" ? var.vm_count : 0)}"
    name                              = "${var.vmname}${count.index}"
    resource_group_name               = azurerm_resource_group.resource_group_name.name
    location                          = azurerm_resource_group.resource_group_name.location
    size                              = var.vm_sku
    admin_username                    = "adminuser"
    admin_password                    = azurerm_key_vault_secret.kvsecret[count.index].value
    disable_password_authentication   = false
    network_interface_ids = [
        azurerm_network_interface.network_interface[count.index].id,
    ]

    os_disk {
        caching                         = "ReadWrite"
        storage_account_type            = "Standard_LRS"
    }

    source_image_reference {
        publisher                       = "Canonical"
        offer                           = "UbuntuServer"
        sku                             = "18.04-LTS"
        version                         = "latest"
    }
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
    count                             = "${(lower(var.os_type) == "windows" ? var.vm_count : 0)}"
    name                              = "${var.vmname}${count.index}"
    resource_group_name               = azurerm_resource_group.resource_group_name.name
    location                          = azurerm_resource_group.resource_group_name.location
    size                              = var.vm_sku
    admin_username                    = "adminuser"
    admin_password                    = azurerm_key_vault_secret.kvsecret[count.index].value
    network_interface_ids = [
        azurerm_network_interface.network_interface[count.index].id,
    ]

    os_disk {
        caching                         = "ReadWrite"
        storage_account_type            = "Standard_LRS"
    }

    source_image_reference {
        publisher                       = "MicrosoftWindowsServer"
        offer                           = "WindowsServer"
        sku                             = "2016-Datacenter"
        version                         = "latest"
    }
}
