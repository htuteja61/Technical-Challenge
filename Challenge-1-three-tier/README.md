# Three-tier Application

## Using this Module

To use this module in we are able to achieve Azure App service connected with MySQL database with Private link and DNS based zone. 


## 1. Introduction

This Terraform module creates and manages Azure APP service with SQL PaaS resources in an Azure cloud environment. The Azure resources currently supported are: 
- APP service
- SQL Server 
- SQL Database
- Virtual network
- Private Link
- Private DNS Zone

## 2. Version Compatibility

| Module version | Terraform version | AzureRM version | Services       |
| -------------- | ----------------- | --------------- | -------------- |
| v1.4.2         | 0.13.2            | 2.61.0          | Azure SQL PaaS,

## 3. Considerations

### Module

* This pattern can only be used with private endpoint connections. No public access is permitted. 
* SQL module having infomation of mysql server and mysql database and authentication admin credential is use with the help of random password.
* Application module will help to resuse app service plan and azure app service.
* Networking module will help to resuse Virtual network.
* Resource group module having the information of resource group.


## 4. Dependencies

1. An Azure virtual network (VNet) with web app subnet ID to connect app service. 

2. An Azure virtual network (VNet) DB subnet ID for Private end point connection with SQL .

3. An Azure app service with virtual network swift connection.

4. An Azure private DNS zone (Azure SQL) with VNet link for integrating private endpoint. 

## 5. Usage

### 5.1 Resources Created

The number of resources created is dependent on user input for certain features.

- 1 SQL server
- 1 SQL database
- 2 APP service Plan
- 2 APP service 
- 3 Virtual network
- 3 Subnet- APP and DB 
- 4 Private DNS Zone
- 4 Private Link
- 4 Private DNS Zone link with Virtual network

### 5.3 Create an Three-tier application


  # General Inputs- APP service Plan
  resource "azurerm_app_service_plan" "test_app_service_plan" {
  name                = "testappserviceplan01"
  location            = var.location
  resource_group_name = var.resource_group_name


  # APP Service with Dot net framework   
  
  name              = "testapp-service01"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.test_app_service_plan.id


  # Azure SQL Server
  name                          = var.sql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.sql_server_version
  administrator_login           = "sqladmin"
  administrator_login_password  = random_password.sql_administrator_password.result
  connection_policy             = var.connection_policy
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"

  # Azure SQL Database 
  resource "azurerm_mssql_database" "sql_database" {
  name                        = var.sql_db_name
  server_id                   = azurerm_mssql_server.sql_server.id
  collation                   = var.sql_collation
  max_size_gb                 = var.sql_db_size
  geo_backup_enabled          = var.geo_backup_enabled
  zone_redundant              = var.zone_redundant
  tags         


```
```

## 6. Inputs

### General

| Name                | Description                                                                                                                                                                                           | Type        | Default | Required |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ------- | -------- |
| role                | Application, department, or role acronym to name the resource. | string      | n/a     | yes      |
| environment         | Environment acronym to name the resource.                       | string      | n/a     | Yes      |
| resource_group_name | Name of the Azure resource group in which the resources should exist.                                                                                                                                 | string      | n/a     | Yes      |
| location            | Name of the Azure region where the resources should exist.                                                                                                                                            | string      | n/a     | Yes      |
| tags                | A mapping of tags to assign to the resources.                                                                                                                                                         | map(string) | n/a     | yes      |


### Azure Resources

| Name                 | Description                                                                                              | Type           | Default                                  | Required |
| -------------------- | -------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------------------- | -------- |
| sql\_server\_number  | Number to use in the SQL server's name.                                                                  | `string`       | n/a                                      | yes      |
| sql\_server\_version | Version number for the SQL server.                                                                       | `string`       | `"12.0"`                                 | no       |
| app_service\_id           | ID of APP Serivce .                                                        | `string`       | n/a | no       |
| subnet\_id   | The subnet ID will use to map APP service , Proxy, and Redirect.             | `string`       | `"Default"`                              | no       |
| sql\_database\_name       | Name of Azure SQL database.                             | `string` | n/a                                       | no       |





### Azure SQL Database

#### sql_database

| Name                            | Description                                                                                                                                                                                                                    | Type     | Default | Required |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------- | -------- |
| name                            | Name of the Azure SQL Database.                                                                                                                                                                                                | `string` | n/a     | yes      |
| collation                       | Collation of the database. Changing this forces a new resource to be created.                                                                                                                                                  | `string` | n/a     | no       |
| max\_size\_gb                   | Max size of the database in gigabytes.                                                                                                                                                                                         | `number` | n/a     | no       |
| geo\_backup\_enabled            | A boolean that specifies if the Geo Backup Policy is enabled.                                                                                                                                                                  | `bool`   | n/a     | no       |
| zone\_redundant                 | Whether or not this database is zone redundant, which means the replicas of the database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases.        | `bool`   | n/a     | no       |



### Network

| Name       | Description                           | Type     | Default | Required |
| ---------- | ------------------------------------- | -------- | ------- | -------- |
| subnet\_id | Subnet ID for Database and APP service within the virtual network. | `string` | n/a     | yes      |


## 7. Outputs

| Name                          | Description                                              |
| ----------------------------- | -------------------------------------------------------- |
| sql\_server\_name             | Name of the Azure SQL server.                            |
| sql\_server\_id               | ID of the Azure SQL server.                              |
| connection                    | Connection use for connectivity for SQL and APP service  |
| sql\_database\_name          | Names of the Azure SQL databases or dedicated SQL pools. |
| sql\_database\_id            | IDs of the Azure SQL databases or dedicated SQL pools.   |
| app \_service\_id            | ID of APP service                                        |
| virtual\_network\_id          | IDs of the Virtual network.                             |
| private\_endpoint\_name       | Private endpoint name of Azure SQL Server.               |
| private\_endpoint\_id         | Private endpoint ID of Azure SQL Server.                 |
| virtual\_network\_name        | Name of virtual network.                                 |
| resource\_group\_name         | Resource group name .                                    |


```

```

## 8. Integrations

### 8.1 Private DNS Zone

DNS A record must be created in Private DNS Zone (Azure SQL) to integrate private endpoint.
