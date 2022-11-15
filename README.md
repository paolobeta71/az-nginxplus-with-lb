# az-nginxplus-with-lb / testing phase

This solution using Terraform permits to setup in Azure a scaleset of linux ubuntu VMs load balanced by an Internal Azure LB.
This terraform make also possible to install nginx-plus on the scaleset instances installed.

Please note the following information:
  - variables.tf file permits to customize the information related for your setup
  - in the variables.tf file you need to provide the link related to the .crt and key license for installing nginx-plus. The script in charge for the nginx-plus installation will gather the two license files from an external repository and use them in the installation process. Without the licenses nginx-plus installation will fail
  - The solution make the use of an Azure Internal Load Balancer. The Frontend IP address is Static and must be provided as part of the variables
  - Variables permit to set:
    - resource group name
    - location
    - subnet prefix
    - Load Balancer Static IP address
    - Load Balancer frontend/backend Application port
    - nginx-plus key and cert url
    - admin username & password

