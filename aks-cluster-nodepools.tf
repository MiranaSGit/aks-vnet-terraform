#Create Linux Azure AKS Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "linux" {
  zones                 = [1, 2, 3]
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vnet_subnet_id        = azurerm_subnet.aks-subnet.id
  max_count             = var.userpool_max_node_count
  min_count             = var.userpool_min_node_count
  node_count            = var.userpool_desired_node_count
  mode                  = "User"
  name                  = "linux"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 30
  os_type               = "Linux" # Default is Linux, we can change to Windows
  vm_size               = var.node_vm_size
  priority              = "Regular" # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "java-apps"
  }
  tags = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "java-apps"
  }
}

# Create Windows Azure AKS Node Pool
# resource "azurerm_kubernetes_cluster_node_pool" "win101" {
#   zones                 = [1, 2, 3]
#   enable_auto_scaling   = true
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
#   vnet_subnet_id        = azurerm_subnet.aks-default.id
#   max_count             = 3
#   min_count             = 1
#   node_count            = 1
#   mode                  = "User"
#   name                  = "win101"
#   orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
#   os_disk_size_gb       = 60        # Update June 2023
#   os_type               = "Windows" # Default is Linux, we can change to Windows
#   vm_size               = "Standard_DS2_v2"
#   priority              = "Regular" # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
#   node_labels = {
#     "nodepool-type" = "user"
#     "environment"   = var.environment
#     "nodepoolos"    = "windows"
#     "app"           = "dotnet-apps"
#   }
#   tags = {
#     "nodepool-type" = "user"
#     "environment"   = var.environment
#     "nodepoolos"    = "windows"
#     "app"           = "dotnet-apps"
#   }
# }