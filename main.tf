

resource "azurerm_resource_group" "RG" {
  name     = var.RG
  location = var.loc
}

resource "azurerm_virtual_network" "VN" {
  name                = var.VN
  resource_group_name = var.RG
  location            = var.loc
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sub" {
  name                 = var.sub
  resource_group_name  = var.RG
  virtual_network_name = var.VN
  address_prefixes     = ["10.0.1.0/24"]
}

#create a scale set
resource "azurerm_linux_virtual_machine_scale_set" "vmss-scaleset" {
  name                = "vmss-scaleset"
  resource_group_name = var.RG
  location            = var.loc
  sku                 = "Standard_F2"
  instances           = 3
  admin_username      = "adminuser"
  upgrade_mode        = "Automatic"

  # configure the app on the vm
  custom_data = file("/Users/ross/Desktop/bootcamp/week5/bonus/apprun3.sh")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/scale_key.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "scale_nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.ssvm-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_address_pool.id]
    }
  }
  lifecycle {
    ignore_changes = [instances]
  }
}



# craete a scale set nerwork security group
resource "azurerm_network_security_group" "vmss_nsg" {
  name                = "vmss_nsg"
  location            = var.loc
  resource_group_name = var.RG
}

resource "azurerm_network_security_rule" "scale_rule22" {
  name                        = "scale_rule22"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.RG
  network_security_group_name = azurerm_network_security_group.vmss_nsg.name
}

resource "azurerm_network_security_rule" "scale_rule8080" {
  name                        = "scale_rule8080"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.RG
  network_security_group_name = azurerm_network_security_group.vmss_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "sub_nsg_association" {
  subnet_id                 = azurerm_subnet.SUB.id
  network_security_group_id = azurerm_network_security_group.vmss_nsg.id
}


#create a load balncer
resource "azurerm_public_ip" "LB_pip" {
  name                = "LB_pip"
  location            = var.loc
  resource_group_name = var.RG
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "LB" {
  name                = "LB"
  location            = var.loc
  resource_group_name = var.RG
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend_ip"
    public_ip_address_id = azurerm_public_ip.LB_pip.id
  }
}

resource "azurerm_lb_probe" "LB_probe" {
  resource_group_name = var.RG
  loadbalancer_id     = azurerm_lb.LB.id
  name                = "LB_probe"
  port                = 8080

}

resource "azurerm_lb_probe" "LB_probe22" {
  resource_group_name = var.RG
  loadbalancer_id     = azurerm_lb.LB.id
  name                = "LB_probe22"
  port                = 22
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  depends_on      = [var.RG]
  loadbalancer_id = azurerm_lb.LB.id
  name            = "backend_pool"
}

resource "azurerm_lb_rule" "LB_rule_8080" {
  resource_group_name            = var.RG
  loadbalancer_id                = azurerm_lb.LB.id
  name                           = "LB_rule_8080"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "frontend_ip"
  probe_id                       = azurerm_lb_probe.LB_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  #disable_outbound_snat          = true
}

resource "azurerm_lb_rule" "LB_rule_22" {
  resource_group_name            = var.RG
  loadbalancer_id                = azurerm_lb.LB.id
  name                           = "LB_rule_22"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "frontend_ip"
  probe_id                       = azurerm_lb_probe.LB_probe22.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]

}




