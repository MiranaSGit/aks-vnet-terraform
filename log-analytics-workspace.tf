resource "random_pet" "aksrandom" {
}

# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "insights" {
  name                = "logs-${random_pet.aksrandom.id}"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = 30
  depends_on          = [azurerm_resource_group.aks_rg]
}