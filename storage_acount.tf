
#remote state storage account

resource "azurerm_storage_account" "Storage_Account" {
  name                     = "Account0528799210"
  resource_group_name      = var.RG
  location                 = var.loc
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "StorageContainer" {
  name                  = "StorageContainer"
  storage_account_name  = azurerm_storage_account.Storage_Account.name
  container_access_type = "blob"
  #sku                   = "Standard"
}




# resource "azurerm_resource_group" "state-demo-secure" {
#   name     = "state-demo"
#   location = "eastus"
# }