resource "random_string" "random-name" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "azurerm_sql_server" "demo" {
  name                         = __sqlservername__
  resource_group_name          = azurerm_resource_group.demoSQLrg.name
  location                     = azurerm_resource_group.demoSQLrg.location
  version                      = "12.0"
  administrator_login          = __sqlserveruser__
  administrator_login_password = __sqlserverpassword__
}

#resource "azurerm_sql_server" "demo-secondary" {
#  name                         = __sqlservername__
#  resource_group_name          = azurerm_resource_group.demoSQLrg.name
#  location                     = var.failover_location
#  version                      = "12.0"
#  administrator_login          = __sqlserveruser__
#  administrator_login_password = __sqlserverpassword__
#}

#resource "azurerm_sql_failover_group" "failover" {
#  name                = "sqlserver-failover-group-${random_string.random-name.result}"
#  resource_group_name = azurerm_resource_group.demoSQLrg.name
#  server_name         = azurerm_sql_server.demo.name
#  databases           = [azurerm_sql_database.training.id]

#  partner_servers {
#    id = azurerm_sql_server.demo-secondary.id
#  }

#  read_write_endpoint_failover_policy {
#    mode          = "Automatic"
#    grace_minutes = 60
#  }
#}

resource "azurerm_sql_database" "training" {
  name                             = __sqlserverdatabasename__
  resource_group_name              = azurerm_resource_group.demoSQLrg.name
  location                         = azurerm_resource_group.demoSQLrg.location
  server_name                      = azurerm_sql_server.demo.name
  edition                          = "Standard"
  requested_service_objective_name = "S1"
}

resource "azurerm_sql_virtual_network_rule" "demo-database-subnet-vnet-rule" {
  name                = "mssql-vnet-rule"
  resource_group_name = azurerm_resource_group.demoSQLrg.name
  server_name         = azurerm_sql_server.demo.name
  subnet_id           = azurerm_subnet.demo-database-1.id
}

resource "azurerm_sql_virtual_network_rule" "demo-subnet-vnet-rule" {
  name                = "mssql-demo-subnet-vnet-rule"
  resource_group_name = azurerm_resource_group.demoSQLrg.name
  server_name         = azurerm_sql_server.demo.name
  subnet_id           = azurerm_subnet.demo-internal-1.id
}

resource "azurerm_sql_firewall_rule" "demo-allow-demo-instance" {
  name                = "mssql-demo-instance"
  resource_group_name = azurerm_resource_group.demoSQLrg.name
  server_name         = azurerm_sql_server.demo.name
  start_ip_address    = azurerm_network_interface.demo-sql-instance-ni.private_ip_address
  end_ip_address      = azurerm_network_interface.demo-sql-instance-ni.private_ip_address
}
