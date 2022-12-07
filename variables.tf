variable "resource_group_name" {
  type = string

  default = "<your-resource-group-name>" 
}

variable "location" {
  type = string

  default = "<your-location>"
}

variable "tags" {
   type        = map(string)
   default = {
      environment = "<your-tag>"
   }
}

variable "fe_application_port" {
  type = string

  default = "<number-of-frontend-port>"
}

variable "be_application_port" {
  type = string

  default = "<number-of-backend-port"
}

variable "admin_user" {
  type = string

  default = "<your-vms-user>"
}

variable "admin_password" {
  type = string

  default = "<your-vms-password>"
}

variable "publisher" {
  type = string
  description = "publisher to use for the source image"
  default = "<your-publisher>"
}

variable "offer" {
  type = string
  description = "offer to use for the source image"
  default = "<your-offer>"
}

variable "sku" {
  type = string
  description = "sku to use for the source image"
  default = "<your-sku>"
}

variable "ver" {
  type = string
  description = "version to use for the source image"
  default = "<your-version-to-use>"
}

variable "nginx_certificate_url" {
  description = " my url location for nginx cert"
  default = "<put-here-the-url-for-gatering-the-nginx-cert>"
  type = string
}

variable "nginx_key_url" {
  description = " my url location for nginx key"
  default = "<put-here-the-url-for-gatering-the-nginx-key>"
  type = string
}

variable "scaleset_subnet" {
  description = "subnet to use in the network"
  default = "<your-scalest-subnet-to-use-es:10.0.2.0/24>"
  type = string
}

variable "scaleset_subnet_name" {
  description = "name of the subnet to use in the scaleset"
  default = ">your-subnet-name>"
  type = string
}

variable "LB_StaticIP" {
  description = "Static private IP to use for the LB"
  default = "<your-static-LB-IP>"
  type = string
}

variable "scaleset_vnet_name" {
  description = "name of the scaleset's vnet"
  default = "<your-scaleset-vnet-name>"
  type = string
}

variable "scaleset_address_space" {
  description = "name of the scaleset's address space"
  default = "<your-scaleset-address-space-es:10.0.0.0/16>"
  type = string
}

variable "vnet_peering_name" {
  description = "name of the vnet peering"
  default = "<your-vnet-peering-name>"
  type = string
}

variable "remote_vnet_peering_name" {
  description = "name of the remote vnet peering"
  default = "<your-vnet-remote-peering-name>"
  type = string
}

variable "remote_virtual_network_id" {
  description = "id of the remote virtual network for the peering"
  default = "<your-remote-virtual-network-id>"
  type = string
}

variable "local_virtual_network_id" {
  description = "id of the local virtual network for the peering"
  default = "<your-local-virtual-network-id>"
  type = string
}

variable "remote_rg_name" {
  description = "name of the remote rg for the peering"
  default = "<your-remote-resource-group-name>"
  type = string
}

variable "remote_vnet_name" {
  description = "name of the remote vnet for the peering"
  default = "<your-remote-vnet-name>"
  type = string
}
