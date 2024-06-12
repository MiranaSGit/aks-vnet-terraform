# create virtual network
resource "azurerm_virtual_network" "aks-vnet" {
  name                = "aks-${var.environment}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  depends_on          = [azurerm_resource_group.aks_rg]

  tags = {
    environment = var.environment
  }
}

# create public subnets
resource "azurerm_subnet" "aks-subnet" {
  name                 = "aks-${var.environment}-public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks-vnet.name
  address_prefixes     = var.subnet_address_prefix
  depends_on           = [azurerm_resource_group.aks_rg]

  # delegation {
  #   name = "delegation"
  #   service_delegation {
  #     name    = "Microsoft.ServiceNetworking/trafficControllers"
  #     actions = ["Microsoft.Network/virtualNetworks/read"]
  #   }
  # }
}

# Create a subnet for application gateway.
# resource "azurerm_subnet" "subnet_appgw" {
#   name                 = "aks-${var.environment}-subnet-appgw"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.aks-vnet.name
#   address_prefixes     = ["192.168.16.0/24"]
#   # delegation {
#   #   name = "delegation"
#   #   service_delegation {
#   #     name    = "Microsoft.ServiceNetworking/trafficControllers"
#   #     actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
#   #   }
#   # }
# }

# create network security group
resource "azurerm_network_security_group" "public_nsg" {
  name                = "aks-${var.environment}-sg"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.aks_rg]

  security_rule {
    name                       = "http_rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https_rule"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
  }
}

# associate NSG to public subnets
resource "azurerm_subnet_network_security_group_association" "nsg_associate_public" {
  subnet_id                 = azurerm_subnet.aks-subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}