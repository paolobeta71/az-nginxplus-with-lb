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
      environment = "<tag-preferred>"
   }
}

variable "fe_application_port" {
  type = string

  default = "<your-FE-port>"
}

variable "be_application_port" {
  type = string

  default = "<your-BE-port>"
}

variable "admin_user" {
  type = string

  default = "<your-admin-user>"
}

variable "admin_password" {
  type = string

  default = "<your-password>"
}

variable "publisher" {
  type = string
  description = "publisher to use for the source image"
  default = "<publisher-to-use>"
}

variable "offer" {
  type = string
  description = "offer to use for the source image"
  default = "<offer-to-use>"
}

variable "sku" {
  type = string
  description = "sku to use for the source image"
  default = "<sku-to-use>"
}

variable "ver" {
  type = string
  description = "version to use for the source image"
  default = "<version-to-use>"
}

variable "nginx_certificate_url" {
  description = " my url location for nginx cert"
  default = "https://<your-nginx-certificate-url>"
  type = string
}

variable "nginx_key_url" {
  description = " my url location for nginx key"
  default = "https://<your-nginx-key-url>"
  type = string
}

variable "subnet" {
  description = "subnet to use in the network"
  default = "<subnet-prefix-to-use>"
  type = string
}

variable "LB_StaticIP" {
  description = "Static private IP to use for the LB"
  default = "<preferred-static-ip-address-in-the-subnet>"
  type = string
}
