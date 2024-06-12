# https://www.terraform.io/docs/configuration/variables.html

# Azure Location
variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "Germany West Central"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type        = string
  description = "This variable defines the Resource Group"
  default     = ""
}

# Azure AKS Environment Name
variable "environment" {
  type        = string
  description = "This variable defines the Environment"
  default     = "dev"
}

# Azure AKS Cluster Name
variable "cluster_name" {
  type        = string
  description = "This variable defines the AKS Cluster Name"
  default     = ""
}

# vnet CIDR
variable "address_space" {
  type        = list(string)
  description = "CIDR of the vnet"
}

# subnet CIDRs
variable "subnet_address_prefix" {
  type        = list(string)
  description = "CIDR of subnet"
}

# AKS Service CIDR
variable "service_cidr" {
  type        = string
  default     = ""
  description = "This variable defines the AKS service CIDR block"
}

# AKS DNS Service IP
variable "dns_service_ip" {
  type        = string
  default     = ""
  description = "This variable defines the AKS DNS Service IP"
}

# Node VM size
variable "node_vm_size" {
  type        = string
  description = "Worker nodes size"
}

# max node count in systempool
variable "systempool_max_node_count" {
  type        = number
  description = "Maximum node count for worker node"
}

# min node count in systempool
variable "systempool_min_node_count" {
  type        = number
  description = "Minimum node count for worker node"
}

# Number of worker nodes in systempool
variable "systempool_desired_node_count" {
  type        = number
  description = "Number of worker nodes"
}

# max node count in userpool
variable "userpool_max_node_count" {
  type        = number
  description = "Maximum node count for worker node"
}

# min node count in userpool
variable "userpool_min_node_count" {
  type        = number
  description = "Minimum node count for worker node"
}

# Number of worker nodes in userpool
variable "userpool_desired_node_count" {
  type        = number
  description = "Number of worker nodes"
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type        = string
  default     = "azureuser"
  description = "This variable defines the Windows admin username k8s Worker nodes"
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type        = string
  default     = "PassW0rd@230110"
  description = "This variable defines the Windows admin password k8s Worker nodes"
}