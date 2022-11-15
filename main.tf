terraform {
  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "nginx-scaleset-pp" {
 name     = var.resource_group_name
 location = var.location
}

resource "azurerm_virtual_network" "nginx-scaleset-pp" {
 name                = "nginx-scaleset-pp-vnet"
 address_space       = ["10.0.0.0/16"]
 location            = var.location
 resource_group_name = azurerm_resource_group.nginx-scaleset-pp.name
}

resource "azurerm_subnet" "nginx-scaleset-pp" {
 name                 = "nginx-scaleset-pp-subnet"
 resource_group_name  = azurerm_resource_group.nginx-scaleset-pp.name
 virtual_network_name = azurerm_virtual_network.nginx-scaleset-pp.name
 address_prefixes       = [var.subnet]
}

resource "azurerm_lb" "nginx-scaleset-pp" {
 name                = "nginx-scaleset-pp-lb"
 location            = var.location
 resource_group_name = azurerm_resource_group.nginx-scaleset-pp.name

 frontend_ip_configuration {
   name                 = "PrivateIPAddress"
   subnet_id         = azurerm_subnet.nginx-scaleset-pp.id
   private_ip_address_allocation = "Static"
   private_ip_address   = var.LB_StaticIP
   private_ip_address_version = "IPv4"
 }

}

resource "azurerm_lb_probe" "nginx-scaleset-pp" {
# resource_group_name = azurerm_resource_group.nginx-scaleset-pp.name
 loadbalancer_id     = azurerm_lb.nginx-scaleset-pp.id
 name                = "http-running-probe"
 port                = var.fe_application_port
 protocol            = "Http"
 request_path        ="/"
}

resource "azurerm_lb_backend_address_pool" "backend-addr-pool" {
 loadbalancer_id     = azurerm_lb.nginx-scaleset-pp.id
 name                = "BackEndAddressPool"
}


data "template_file" "run_scripts" {
  template = "${file("${path.module}/script.txt")}"
  vars     = {
               nginx_certificate_url = var.nginx_certificate_url
               nginx_key_url = var.nginx_key_url
             }
}

resource "azurerm_linux_virtual_machine_scale_set" "nginx-scaleset-pp" {
 name                = "vmscaleset"
 location            = var.location
 resource_group_name = azurerm_resource_group.nginx-scaleset-pp.name
 upgrade_mode        = "Manual"
 sku                 = "Standard_DS1_v2"
 instances           = 2
 admin_username      = var.admin_user
 admin_password      = var.admin_password
 disable_password_authentication = false
 custom_data         = base64encode(data.template_file.run_scripts.rendered)
 depends_on          = [azurerm_lb_probe.nginx-scaleset-pp]
 source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.ver
  }

 os_disk {
   caching           = "ReadWrite"
   storage_account_type = "StandardSSD_LRS"
 }

 data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 100
   storage_account_type = "StandardSSD_LRS"
 }

 boot_diagnostics {
     storage_account_uri = null
   }

 network_interface {
   name    = "scaleset-net-int"
   primary = true

   ip_configuration {
     name                                   = "scaleset-pp-ip-conf"
     subnet_id                              = azurerm_subnet.nginx-scaleset-pp.id
     load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend-addr-pool.id]
     primary = true
   }
 }

}
resource "azurerm_lb_rule" "lbnatrule" {
   #resource_group_name            = azurerm_resource_group.nginx-scaleset-pp.name
   loadbalancer_id                = azurerm_lb.nginx-scaleset-pp.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.fe_application_port
   backend_port                   = var.be_application_port
   backend_address_pool_ids        = [azurerm_lb_backend_address_pool.backend-addr-pool.id]
   frontend_ip_configuration_name = "PrivateIPAddress"
   probe_id                       = azurerm_lb_probe.nginx-scaleset-pp.id
}
