terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.18.3"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "github" {
  # Configuration options
}

variable "org" {
  type    = string
  default = null
}

variable "github_repository" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

resource "random_pet" "org" {
  count = "${var.org}" == null ? 1 : 0
}

locals {
  safe_env         = replace(var.environment, "/", "-")
  org              = "${var.org}" == null ? random_pet.org[0].id : "${var.org}"
  resource_postfix = "${local.org}-${local.safe_env}"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.resource_postfix}"
  location = var.location
}

resource "azurerm_container_registry" "this" {
  name                = replace("acr-${local.resource_postfix}", "-", "")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Standard"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${local.resource_postfix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "example" {
  name                       = "cae-${local.resource_postfix}"
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}

data "github_repository" "this" {
  full_name = var.github_repository
}

resource "github_repository_environment" "this" {
  environment = local.safe_env
  repository  = data.github_repository.this.name
  deployment_branch_policy {
    custom_branch_policies = true
  }

}

locals {
  variables = {
    RG_NAME  = "${azurerm_resource_group.this.name}"
    ACR_NAME = "${azurerm_container_registry.this.name}"
    ACA_NAME = "aca-${local.resource_postfix}"
  }
}

resource "github_actions_environment_variable" "this" {
  for_each      = local.variables
  environment   = github_repository_environment.this.environment
  repository    = github_repository_environment.this.repository
  variable_name = upper(each.key)
  value         = each.value
}
