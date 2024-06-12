resource "random_string" "random" {
  length  = 12
  special = false
}

resource "azurerm_container_registry" "acr-registry" {
  name                = "acr${random_string.random.id}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "acr-aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr-registry.id
  skip_service_principal_aad_check = true
  depends_on                       = [azurerm_container_registry.acr-registry]
}