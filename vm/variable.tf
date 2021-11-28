# define variables
variable "resource_group_name" {
    description        = "Name of the Resource Group"
    type               = string
}

variable "location" {
    description        = "Name of the location"
    type               = string
}

variable "env" {
    description        = "Name of the Environment"
    type               = string
}

variable "vmname" {
    description        = "virtual machine name"
    type               = string
}

variable "os_type" {
    description        = "Virtual Machine OS Type | Windows | Linux"
    type               = string
}

variable "vm_count" {
    description        = "Number of VM to be deployed"
    type               = number
}

variable "tier" {
    description        = "Virtual Machine Tier Type | Web | App | Db "
    type               = string
}

variable "vm_sku" {
    description        = "Virtual Machine Size | Standard_B1s"
    type               = string
}