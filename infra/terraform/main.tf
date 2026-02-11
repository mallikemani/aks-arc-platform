resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

locals {
  name_prefix = "${var.project}-${var.env}-${random_string.suffix.result}"
}

# Use the RG you created in the Portal (so CI doesn't need permission to create RGs).
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.name_prefix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${local.name_prefix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "dns-${local.name_prefix}"

  # Important for later: Key Vault + workload identity patterns.
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name            = "system"
    vm_size         = var.system_node_vm_size
    vnet_subnet_id  = azurerm_subnet.aks.id
    type            = "VirtualMachineScaleSets"
    os_disk_size_gb = 50

    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3
    max_pods             = 30
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    outbound_type  = "loadBalancer"
  }

  role_based_access_control_enabled = true
  tags                              = var.tags
}

