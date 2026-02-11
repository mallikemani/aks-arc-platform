output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "get_credentials_command" {
  value = "az aks get-credentials -g ${data.azurerm_resource_group.rg.name} -n ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
}
