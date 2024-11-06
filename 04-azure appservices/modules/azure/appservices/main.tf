#
# App Service Plans
#
resource "azurerm_service_plan" "plans" {
  for_each            = var.plans
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  os_type             = each.value.os_type
  sku_name            = each.value.sku_name
  tags                = var.tags
}

#
# App Services
#
resource "azurerm_linux_web_app" "app_services" {
  for_each            = var.app_services
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  service_plan_id     = azurerm_service_plan.plans[each.value.app_service_plan_key].id
  https_only          = true
  app_settings        = each.value.app_settings
  dynamic "connection_string" {
    for_each = each.value.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
  logs {
    application_logs {
      file_system_level = "Verbose"
    }
    http_logs {
      file_system {
        retention_in_days = 1
        retention_in_mb   = 35
      }
    }
  }
  site_config {
    application_stack {
      node_version   = each.value.node_version
      dotnet_version = each.value.dotnet_version
    }
  }
  tags = var.tags
}

