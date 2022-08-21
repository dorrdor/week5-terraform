# # create postgresqlflexible

# resource "azurerm_subnet" "postgres_sub" {
#   name                 = "postgres_sub"
#   resource_group_name  = "bonus_rg"
#   virtual_network_name = "bonus-vn"
#   address_prefixes     = ["10.0.0.0/24"]
#   service_endpoints    = ["Microsoft.Storage"]
#   delegation {
#     name = "fs"
#     service_delegation {
#       name = "Microsoft.DBforPostgreSQL/flexibleServers"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#     }
#   }
# }
# resource "azurerm_private_dns_zone" "postgres-dns" {
#   name                = "postgres-dns.postgres.database.azure.com"
#   resource_group_name = "bonus_rg"
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
#   name                  = "dns-zone.com"
#   private_dns_zone_name = "postgres-dns.postgres.database.azure.com"
#   virtual_network_id    = azurerm_virtual_network.bonus-vn.id
#   resource_group_name   = "bonus_rg"
# }

# resource "azurerm_postgresql_flexible_server" "pos-server0528799210" {
#   name                   = "pos-server0528799210"
#   resource_group_name    = "bonus_rg"
#   location               = azurerm_resource_group.bonus_rg.location
#   version                = "12"
#   delegated_subnet_id    = azurerm_subnet.postgres_sub.id
#   private_dns_zone_id    = azurerm_private_dns_zone.postgres-dns.id
#   administrator_login    = "adminuser"
#   administrator_password = "dorrdor55"
#   create_mode            = "Default"
#   zone                   = "1"
#   storage_mb             = 32768
#   #ssl_enforcement_enabled       = false
#   #public_network_access_enabled = true
#   sku_name   = "GP_Standard_D4s_v3"
#   depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_zone_link]
# }

# resource "azurerm_postgresql_flexible_server_configuration" "postgres-config-dorrdor55" {
#   name      = "postgres-config-dorrdor55"
#   server_id = azurerm_postgresql_flexible_server.pos-server0528799210.id
#   value     = "off"

#   depends_on = [azurerm_postgresql_flexible_server.pos-server0528799210]

# }

# resource "azurerm_postgresql_flexible_server_database" "postgres_database" {
#   name      = "postgres_database"
#   server_id = azurerm_postgresql_flexible_server.pos-server0528799210.id
#   collation = "English_United States.1252"
#   charset   = "utf8"

# }


# resource "azurerm_postgresql_flexible_server_firewall_rule" "postgres_rule" {
#   name             = "postgres_rule"
#   server_id        = azurerm_postgresql_flexible_server.pos-server0528799210.id
#   start_ip_address = azurerm_public_ip.lb_pip.ip_address
#   end_ip_address   = azurerm_public_ip.lb_pip.ip_address
# }

# #nsg for postgres

# resource "azurerm_network_security_group" "postgres-nsg" {
#   name                = "postgres-nsg"
#   location            = var.location
#   resource_group_name = "bonus_rg"

#   security_rule {
#     name                       = "5432"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "5432"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "22"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "22"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "postgres_sub_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.postgres_sub.id
#   network_security_group_id = azurerm_network_security_group.postgres-nsg.id
# }