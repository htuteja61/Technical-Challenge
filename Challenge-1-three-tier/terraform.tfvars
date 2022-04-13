app_service_plan_name = "testappserviceplan01"
app_service_name      = "testapp-service01"
location              = "eastus"
tags = {
  "Environment"         = "DEV"
  "Category"            = "APP"
  "Application"         = "Dotnet"
  "Role"                = "test"
  "CostCentre"          = "12345"
}

sql_server_name="testsql1"
sql_db_name ="testsqldb1"