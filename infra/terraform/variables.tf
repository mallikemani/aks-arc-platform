variable "location" {
  type        = string
  description = "Azure region (example: eastus2)"
}

variable "resource_group_name" {
  type        = string
  description = "Existing resource group where AKS will be created (you created this in the Portal)"
}

variable "project" {
  type        = string
  description = "Short project name used in resource naming"
  default     = "arcaks"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "vnet_cidr" {
  type        = string
  default     = "10.60.0.0/16"
}

variable "aks_subnet_cidr" {
  type        = string
  default     = "10.60.1.0/24"
}

variable "system_node_vm_size" {
  type        = string
  default     = "Standard_D2s_v5"
}

variable "tags" {
  type        = map(string)
  default = {
    project = "aks-arc"
    env     = "dev"
  }
}
