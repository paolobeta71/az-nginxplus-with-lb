# az-nginxplus-with-lb / test01

This solution using Terraform permits to setup in Azure a scaleset of linux VMs load balanced by an Internal Azure LB.
This terraform also install nginx-plus on the scaleset instances installed.
The solution consider to link the new resource group created for nginx-plus with an existing resource group where the upstream servers are installed. 
The link is created using a vnet peering configuration.

Please note you need to customize the following variables in the variables.tf file with the information of the setup you want to build:
- variable "resource_group_name" : the name of the resource group to create for the nginx-plus scaleset
- variable "location" : the az location to use
- variable "tags" : a tag to use 
- variable "fe_application_port" : the frontend application port to use for the azure lb
- variable "be_application_port" : the backend application port to use for the azure lb
- variable "admin_user" : the user to create in the vms for the scaleset
- variable "admin_password" : the password of the user created
- variable "publisher" : publisher you selected for the linux image you want to use
- variable "offer" : offer you selected for the linux image you want to use
- variable "sku" : sku you selected for the linux image you want to use
- variable "ver" : version you selected for the linux image you want to use
- variable "nginx_certificate_url" : upload the nginx certificate in a private and secure repository, put here the url to use to wget the file
- variable "nginx_key_url" : upload the nginx key in a private and secure repository, put here the url to use to wget the file
- variable "scaleset_subnet" : the CIDR subnet value you want to use for the scaleset
- variable "scaleset_subnet_name" : the subnet name to use in the scaleset
- variable "LB_StaticIP" : the internal static IP to use for the load balancer 
- variable "scaleset_vnet_name" : the scaleset vnet's name to use
- variable "scaleset_address_space" : the scaleset address space in the CIDR format
- variable "vnet_peering_name" : the name of the vnet peering you prefer to use
- variable "remote_vnet_peering_name" : the name of the remote vnet peering you prefer to use in the remote resource group
- variable "remote_virtual_network_id" : the network_id of the remote vnet (in the RG where upstream server are installed)
- variable "local_virtual_network_id" : the network_id of the local vnet (used in the nginx-plus scaleset)
- variable "remote_rg_name" : the name of the remote resource group where the upstream servers are installed
- variable "remote_vnet_name" : the name of the vnet where the upstream servers are installed

In order to select your best publisher/offer/sku/ver combination please refer to the supported Linux Distribution by nginx-plus consulting the following link: https://docs.nginx.com/nginx/technical-specs/
