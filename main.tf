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
 name                = var.scaleset_vnet_name
 address_space       = [var.scaleset_address_space]
 location            = var.location
 resource_group_name = azurerm_resource_group.nginx-scaleset-pp.name
}

resource "azurerm_subnet" "nginx-scaleset-pp" {
 name                 = var.scaleset_subnet_name
 resource_group_name  = azurerm_resource_group.nginx-scaleset-pp.name
 virtual_network_name = azurerm_virtual_network.nginx-scaleset-pp.name
 address_prefixes       = [var.scaleset_subnet]
}

resource "azurerm_public_ip" "nginx-scaleset-pp" {
 name                         = "nginx-scaleset-pp-public-ip"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.nginx-scaleset-pp.name
 allocation_method            = "Static"
}


resource "azurerm_lb" "nginx-scaleset-pp" {
 name                = "nginx-scaleset-pp-lb"
 location            = var.location
 resource_group_name = azurerm_resource_group.nginx-scaleset-pp.name

 frontend_ip_configuration {
   name                 = "LB-PublicIPAddress"
 #  subnet_id         = azurerm_subnet.nginx-scaleset-pp.id
   public_ip_address_id = azurerm_public_ip.nginx-scaleset-pp.id
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
   frontend_ip_configuration_name = "LB-PublicIPAddress"
   probe_id                       = azurerm_lb_probe.nginx-scaleset-pp.id
}

resource "azurerm_virtual_network_peering" "vnet_peering_name" {
  name                      = var.vnet_peering_name
  resource_group_name       = azurerm_resource_group.nginx-scaleset-pp.name
  virtual_network_name      = azurerm_virtual_network.nginx-scaleset-pp.name
  remote_virtual_network_id = var.remote_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
}

data "azurerm_resource_group" "remote-rg" {
  name = var.remote_rg_name
}

data "azurerm_virtual_network" "remote-vnet" {
  resource_group_name       = data.azurerm_resource_group.remote-rg.name
  name                      = var.remote_vnet_name
}

resource "azurerm_virtual_network_peering" "remote_vnet_peering_name" {
  name                      = var.remote_vnet_peering_name
  resource_group_name       = data.azurerm_resource_group.remote-rg.name
  remote_virtual_network_id = var.local_virtual_network_id
  virtual_network_name      = data.azurerm_virtual_network.remote-vnet.name
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  depends_on = [azurerm_virtual_network_peering.vnet_peering_name]
}
