












# # data network security group
# resource "azurerm_network_security_group" "NSG2" {
#   name                = "NSG2"
#   location            = azurerm_resource_group.RG.location
#   resource_group_name = azurerm_resource_group.RG.name

#   security_rule {
#     name                       = "Postgres"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "5432"
#     destination_port_range     = "5432"
#     source_address_prefix      = "VirtualNetwork"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "controller access"
#     priority                   = 111
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "22"
#     destination_port_range     = "22"
#     source_address_prefix      = "79.178.9.59"
#     destination_address_prefix = "*"
#   }

# }