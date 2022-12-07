variable "resource_group_name" {
  type = string

  default = "nginxplus-vmss-pp-rg" 
}

variable "location" {
  type = string

  default = "West Europe"
}

variable "tags" {
   type        = map(string)
   default = {
      environment = "nginxplus-vmss-pp"
   }
}

variable "fe_application_port" {
  type = string

  default = "80"
}

variable "be_application_port" {
  type = string

  default = "80"
}

variable "admin_user" {
  type = string

  default = "nginx"
}

variable "admin_password" {
  type = string

  default = "f5rocks!"
}

variable "publisher" {
  type = string
  description = "publisher to use for the source image"
  default = "Canonical"
}

variable "offer" {
  type = string
  description = "offer to use for the source image"
  default = "UbuntuServer"
}

variable "sku" {
  type = string
  description = "sku to use for the source image"
  default = "18.04-LTS"
}

variable "ver" {
  type = string
  description = "version to use for the source image"
  default = "latest"
}

variable "nginx_certificate_url" {
  description = " my url location for nginx cert"
  default = "https://paoloptimhybridbackendap.blob.core.windows.net/nginx-pp/nginx-repo.cer?sp=r&st=2022-11-13T16:09:26Z&se=2023-11-14T00:09:26Z&spr=https&sv=2021-06-08&sr=b&sig=c%2FY7%2Ba9Ri486g%2FaFg%2F7aX5IIGCszxR7RxQAEeU9Yp6U%3D"
  type = string
}

variable "nginx_key_url" {
  description = " my url location for nginx key"
  default = "https://paoloptimhybridbackendap.blob.core.windows.net/nginx-pp/nginx-repo.key?sp=r&st=2022-11-13T16:10:09Z&se=2023-11-14T00:10:09Z&spr=https&sv=2021-06-08&sr=b&sig=FJ7%2FSiY%2BN%2BQV4%2BGSNUqwI9%2Fq1iZbXk2RlaEm1HPMBYw%3D"
  type = string
}

variable "scaleset_subnet" {
  description = "subnet to use in the network"
  default = "10.0.2.0/24"
  type = string
}

variable "scaleset_subnet_name" {
  description = "name of the subnet to use in the scaleset"
  default = "nginx-scaleset-pp-subnet"
  type = string
}

variable "LB_StaticIP" {
  description = "Static private IP to use for the LB"
  default = "10.0.2.10"
  type = string
}

variable "scaleset_vnet_name" {
  description = "name of the scaleset's vnet"
  default = "nginx-scaleset-pp-vnet"
  type = string
}

variable "scaleset_address_space" {
  description = "name of the scaleset's address space"
  default = "10.0.0.0/16"
  type = string
}

variable "vnet_peering_name" {
  description = "name of the vnet peering"
  default = "vnet_peering_nginx-ubuntu-pp"
  type = string
}

variable "remote_vnet_peering_name" {
  description = "name of the remote vnet peering"
  default = "vnet_peering_ubuntu-nginx-pp"
  type = string
}

variable "remote_virtual_network_id" {
  description = "id of the remote virtual network for the peering"
  default = "/subscriptions/1005fe30-e19e-4091-8480-8b61ecb8106e/resourceGroups/ubuntu-pp-rg/providers/Microsoft.Network/virtualNetworks/ubuntu-web-pp-vn"
  type = string
}

variable "local_virtual_network_id" {
  description = "id of the local virtual network for the peering"
  default = "/subscriptions/1005fe30-e19e-4091-8480-8b61ecb8106e/resourceGroups/nginxplus-vmss-pp-rg/providers/Microsoft.Network/virtualNetworks/nginx-scaleset-pp-vnet"
  type = string
}

variable "remote_rg_name" {
  description = "name of the remote rg for the peering"
  default = "ubuntu-pp-rg"
  type = string
}

variable "remote_vnet_name" {
  description = "name of the remote vnet for the peering"
  default = "ubuntu-web-pp-vn"
  type = string
}
