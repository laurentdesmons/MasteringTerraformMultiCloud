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
    minimum_tls_version = "1.2"
    application_stack {
      node_version = each.value.node_version
    }
  }
  tags = var.tags
}

#
# Source Control
# 
resource "azurerm_app_service_source_control" "source_controls" {
  for_each               = var.app_services
  app_id                 = azurerm_linux_web_app.app_services[each.key].id
  repo_url               = each.value.source_control.repo_url
  branch                 = each.value.source_control.branch
  use_manual_integration = true
}

