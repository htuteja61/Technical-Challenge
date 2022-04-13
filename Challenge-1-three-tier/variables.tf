variable "location" {
  type        = string
  description = "Azure region where the resource should exist."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}
# Azure SQL Server Variables

variable "sql_server_name" {
  type        = string
  description = "Name for the SQL server."
}

variable "sql_server_version" {
  type        = string
  description = "Version number for the SQL server."
  default     = "12.0"
}
variable "connection_policy" {
  type        = string
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect."
  default     = "Default"
}
variable "sql_db_name"{
  type = string
  description = "Name of SQL Server DB Name"
}

variable "sql_collation"{
  type = string
}

variable "sql_db_size"{
  type = number
  description = "Size of SQL Server DB"
}

variable "geo_backup_enabled"{
  type = bool
  default=false
}

variable "zone_redundant"{
  type = bool
  default=false
}

#Web App variable

variable "app_service_plan_name" {
  type        = string
  description = "Name for App Service Plan."
}
variable "app_service_name" {
  type        = string
  description = "Name for App Service."
}
variable "client_secret" {
}