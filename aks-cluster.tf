# RSA key of size 4096 bits
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# storing the private-key locally
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.cluster_name}-privatekey.pem"
}

# storing the public-key locally
resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${var.cluster_name}-publickey.pub"
}

# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.cluster_name}-nrg"
  # sku_tier            = "Standard"  Possible values are Free, Standard (which includes the Uptime SLA) and Premium. Defaults to Free
  automatic_channel_upgrade = patch # patch is (recommended) Possible values are patch, rapid, node-image and stable. Omitting this field sets this value to none

  default_node_pool {
    name                         = "systempool"
    vm_size                      = var.node_vm_size
    vnet_subnet_id               = azurerm_subnet.aks-subnet.id
    orchestrator_version         = data.azurerm_kubernetes_service_versions.current.latest_version
    zones                        = [1, 2, 3]
    enable_auto_scaling          = true
    max_count                    = var.systempool_max_node_count
    min_count                    = var.systempool_min_node_count
    node_count                   = var.systempool_desired_node_count
    os_disk_size_gb              = 30
    type                         = "VirtualMachineScaleSets"
    only_critical_addons_enabled = true
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "dev"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = "dev"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
  }

  # Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  # RBAC and Azure AD Integration Block
  # Microsoft Entra ID authentication with Kubernetes RBAC
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [azuread_group.aks_administrators.id]
  }

  # # Application Gateway Ingress Controller
  # ingress_application_gateway {
  #   gateway_name = "${var.cluster_name}-ingress-appgateway"
  #   subnet_id    = azurerm_subnet.subnet_appgw.id
  # }

  # Windows Profile
  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
  }

  # Linux Profile
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = tls_private_key.ssh_key.public_key_openssh
    }
  }

  # Network Profile
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr   # (Optional) The Network Range used by the Kubernetes service.
    dns_service_ip    = var.dns_service_ip # (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns).
    /* outbound_type = "userDefinedRouting" The outbound (egress) routing method which should be used for this Kubernetes Cluster. 
    Possible values are loadBalancer, userDefinedRouting, managedNATGateway and userAssignedNATGateway. Defaults to loadBalancer */
  }

  # AutoScaler Profile
  auto_scaler_profile {
    balance_similar_node_groups = true
  }

  tags = {
    Environment = var.environment
  }
}