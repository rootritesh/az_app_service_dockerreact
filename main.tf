provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "resource" {
  name     = "appservice_docker"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "svcplan" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.resource.location
  resource_group_name = azurerm_resource_group.resource.name
  kind = "Linux"
  reserved = true
  

  sku {
    tier = "Standard"
    size = "S1"
  }
}

locals {
 env_variables = {
   DOCKER_REGISTRY_SERVER_URL            = "URL"
   DOCKER_REGISTRY_SERVER_USERNAME       = "USERNAME"
   DOCKER_REGISTRY_SERVER_PASSWORD       = "PASSWORD"
 }
}

resource "azurerm_app_service" "myapp" {
  name                = "dockerreactappservice222"
  location            = azurerm_resource_group.resource.location
  resource_group_name = azurerm_resource_group.resource.name
  app_service_plan_id = azurerm_app_service_plan.svcplan.id
  

  site_config {
    linux_fx_version = "DOCKER|reactappservice2.azurecr.io/nginxreact"
    # registry_source="Docker Hub"

  }
    app_settings = local.env_variables
    
}

output "id" {
  value = azurerm_app_service_plan.svcplan.id
}