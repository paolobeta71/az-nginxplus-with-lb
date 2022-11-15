variable "resource_group_name" {
  type = string

  default = "nginx-scaleset-pp" 
}

variable "location" {
  type = string

  default = "West Europe"
}

variable "tags" {
   type        = map(string)
   default = {
      environment = "nginx-scaleset-pp"
   }
}

variable "application_port" {
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

variable "nginx_plus_license" {
  description = "Location of NGINX Plus license to be used in agent instance"
   default = {
     key  = "/home/ubuntu/az-scaleset-nginx/nginx_license/nginx-repo.key"
     cert = "/home/ubuntu/az-scaleset-nginx/nginx_license/nginx-repo.cer"
   }
  type = map(string)
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

variable "subnet" {
  description = "subnet to use in the network"
  default = "10.0.2.0/24"
  type = string
}

variable "LB_StaticIP" {
  description = "Static private IP to use for the LB"
  default = "10.0.2.10"
  type = string
}
