variable "vnet" {
    description        = "Name of the Virtual Network"
    type               = string
}

variable "resource_group" {
    description        = "Name of the Resource Group"
    type               = string
}

variable "location" {
    description        = "Location where resource to be deployed"
    type               = string
}

variable "cidrvnet" {
    description         = "CIDR for the Virtual Network"
    type                = string
}

variable "subnet" {
    type = list(string)
    default = [
    
        "10.1.0.0/28",
        "10.1.1.0/28",
        "10.1.2.0/28"    
    ]
}