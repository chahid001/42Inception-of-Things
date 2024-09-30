provider "azurerm" {
    features {}
    
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
}

resource "azurerm_resource_group" "IoT" {

    name = "IoT"
    location = "East US"
  
}

resource "azurerm_virtual_network" "vNet" {

    name = "IoT_vNet"
    location = azurerm_resource_group.IoT.location
    resource_group_name = azurerm_resource_group.IoT.name
    address_space = [ "10.0.0.0/16" ]
  
}

resource "azurerm_subnet" "Subnet" {

    name = "IoT_Subnet"
    resource_group_name = azurerm_resource_group.IoT.name
    virtual_network_name = azurerm_virtual_network.vNet.name
    address_prefixes = [ "10.0.1.0/24" ]
  
}

resource "azurerm_network_interface" "NIC" {

    name = "IoT_NIC"
    resource_group_name = azurerm_resource_group.IoT.name
    location = azurerm_resource_group.IoT.location

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.Subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.Public.id
    }
}

resource "azurerm_public_ip" "Public" {
  
  name = "IoT_Public_IP"
  resource_group_name = azurerm_resource_group.IoT.name
  location = azurerm_resource_group.IoT.location
  sku = "Standard"
  allocation_method = "Static"
}

resource "azurerm_network_security_group" "NSG" {

    name = "IoT_NSG"
    location = azurerm_resource_group.IoT.location
    resource_group_name = azurerm_resource_group.IoT.name


    dynamic "security_rule" {

        for_each = [ 

            {
                name = "allow-ssh"
                priority = "100"
                direction = "Inbound"
                access = "Allow"
                protocol = "Tcp"
                source_port_range = "*"
                destination_port_range = "22"
                source_address_prefix = "*"
                destination_address_prefix = "*"
            },

            {
                name = "allow_HTTP"
                priority = "101"
                direction = "Inbound"
                access = "Allow"
                protocol = "Tcp"
                source_port_range = "*"
                destination_port_range = "80"
                source_address_prefix = "*"
                destination_address_prefix = "*"
            },

            {
                name = "allow_HTTPS"
                priority = "102"
                direction = "Inbound"
                access = "Allow"
                protocol = "Tcp"
                source_port_range = "*"
                destination_port_range = "443"
                source_address_prefix = "*"
                destination_address_prefix = "*"
            },
         ]  

        content {

            name = security_rule.value.name
            priority = security_rule.value.priority
            direction = security_rule.value.direction
            access = security_rule.value.access
            protocol = security_rule.value.protocol
            source_port_range = security_rule.value.source_port_range
            destination_port_range = security_rule.value.destination_port_range
            source_address_prefix = security_rule.value.source_address_prefix
            destination_address_prefix = security_rule.value.destination_address_prefix
           
        }
      
    }
  
}

resource "azurerm_network_interface_security_group_association" "N" {
    network_interface_id = azurerm_network_interface.NIC.id
    network_security_group_id = azurerm_network_security_group.NSG.id
  
}

resource "azurerm_virtual_machine" "VM" {

    name = "IoT_VM"
    location = azurerm_resource_group.IoT.location
    resource_group_name = azurerm_resource_group.IoT.name
    network_interface_ids = [azurerm_network_interface.NIC.id]
    vm_size = "Standard_D2s_v3"

    storage_os_disk {
        name = "IoT_Disk"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "StandardSSD_LRS"
        disk_size_gb = 80
    }
    
    storage_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts-gen2"
        version = "latest"
    }
    
    os_profile {
      computer_name = "InceptionOfThings"
      admin_username = var.admin_user
      admin_password = var.admin_pass
      custom_data = base64encode(file("script/init.sh"))
    }

    os_profile_linux_config {
      disable_password_authentication = false
    }
  
    delete_os_disk_on_termination = true
}

