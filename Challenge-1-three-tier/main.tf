resource "random_integer" "rand" {
  min = 201
  max = 300
}

resource "azurerm_resource_group" "test_resource_group" {
  name     = "rsg${random_integer.rand.result}"
  location = var.location
  tags     = var.tags
}

module "virtualnetwork" {
  source         = "./stacks/networking"
  virtual_network_name = "vnet${random_integer.rand.result}"
  resource_group_name = azurerm_resource_group.test_resource_group.name
  location            = azurerm_resource_group.test_resource_group.location
  tags                = var.tags

}
resource "azurerm_subnet" "test_db_subnet" {
  name                                           = "vnet${random_integer.rand.result}-sbn01"
  resource_group_name                            = azurerm_resource_group.test_resource_group.name
  virtual_network_name                           = module.virtualnetwork.virtual_network_name
  address_prefixes                               = ["10.20.0.0/24"]
  service_endpoints                              = ["Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "test_webapp_subnet" {
  name                                           = "vnet${random_integer.rand.result}-sbn02"
  resource_group_name                            = azurerm_resource_group.test_resource_group.name
  virtual_network_name                           = module.virtualnetwork.virtual_network_name
  address_prefixes                               = ["10.20.2.0/24"]
  service_endpoints                              = ["Microsoft.Web"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
  depends_on = [
    module.virtualnetwork,
    module.test_sql_database
  ]
}

module "test_sql_database"{
    source         = "./stacks/database"
    sql_server_name = var.sql_server_name
    resource_group_name = azurerm_resource_group.test_resource_group.name
    location       = azurerm_resource_group.test_resource_group.location
    sql_server_version = var.sql_server_version
    connection_policy = var.connection_policy
    sql_db_name = var.sql_db_name
    sql_collation = var.sql_collation
    sql_db_size = var.sql_db_size
    geo_backup_enabled = var.geo_backup_enabled
    zone_redundant = var.zone_redundant
    tags = var.tags
}
module "test_web_app"{
    source         = "./stacks/application"
    app_service_plan_name = var.app_service_plan_name
    app_service_name = var.app_service_name
    resource_group_name = azurerm_resource_group.test_resource_group.name
    location = azurerm_resource_group.test_resource_group.location
    connection_value = module.test_sql_database.connection
}
resource "azurerm_app_service_virtual_network_swift_connection" "appconnection" {
  app_service_id = module.test_web_app.app_service_id
  subnet_id      = azurerm_subnet.test_webapp_subnet.id
}

resource "azurerm_private_dns_zone" "test_private_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.test_resource_group.name
  tags                = var.tags
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${module.test_sql_database.sql_server_name}-pep${random_integer.rand.result}"
  resource_group_name = azurerm_resource_group.test_resource_group.name
  location            = azurerm_resource_group.test_resource_group.location
  subnet_id           = azurerm_subnet.test_db_subnet.id
  tags                = var.tags


  private_service_connection {
    name                           = "${module.test_sql_database.sql_server_name}-pep${random_integer.rand.result}"
    is_manual_connection           = false
    private_connection_resource_id = module.test_sql_database.sql_server_id
    subresource_names              = ["sqlServer"]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "test_dnszone_vnet_link" {
  name                  = "sql-vnet-link"
  resource_group_name   = azurerm_resource_group.test_resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.test_private_dns_zone.name
  virtual_network_id    = module.virtualnetwork.virtual_network_id
  tags                  = var.tags
}