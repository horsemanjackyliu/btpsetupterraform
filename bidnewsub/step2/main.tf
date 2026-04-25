data "btp_whoami" "me" {}

# ------------------------------------------------------------------------------------------------------
# Import and manage the default SAP IDP trust configuration
# Disables SAP ID Service for user logon when a custom IDP is configured
# ------------------------------------------------------------------------------------------------------
locals {
  available_for_user_logon = var.custom_idp == "" ? true : false
}

import {
  to = btp_subaccount_trust_configuration.default
  id = "${var.subaccount_id},sap.default"
}

resource "btp_subaccount_trust_configuration" "default" {
  subaccount_id            = var.subaccount_id
  identity_provider        = ""
  auto_create_shadow_users = false
  available_for_user_logon = local.available_for_user_logon
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry — Org Roles
# ------------------------------------------------------------------------------------------------------
locals {
  custom_idp_tenant = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key        = var.custom_idp != "" ? var.cf_origin : "sap.default"
  assign_cf_roles   = var.custom_idp != "" && (length(var.cf_org_managers) > 0 || length(var.cf_org_users) > 0)
}

resource "cloudfoundry_org_role" "organization_user_custom_idp" {
  for_each = local.assign_cf_roles ? toset(var.cf_org_users) : toset([])

  username = each.value
  type     = "organization_user"
  org      = var.cf_org_id
  origin   = local.origin_key
}

resource "cloudfoundry_org_role" "organization_manager_custom_idp" {
  for_each = local.assign_cf_roles ? toset(var.cf_org_managers) : toset([])

  username   = each.value
  type       = "organization_manager"
  org        = var.cf_org_id
  origin     = local.origin_key
  depends_on = [cloudfoundry_org_role.organization_user_custom_idp]
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry — Space and Space Roles
# ------------------------------------------------------------------------------------------------------

resource "cloudfoundry_space" "dev" {
  name = var.cf_space_name
  org  = var.cf_org_id
}

resource "cloudfoundry_space_role" "space_manager" {
  for_each = toset(var.cf_space_managers)

  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.dev.id
  origin     = local.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager_custom_idp, cloudfoundry_org_role.organization_user_custom_idp]
}

resource "cloudfoundry_space_role" "space_developer" {
  for_each = toset(var.cf_space_developers)

  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.dev.id
  origin     = local.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager_custom_idp, cloudfoundry_org_role.organization_user_custom_idp]
}

resource "cloudfoundry_space_role" "space_developer_terraform_user" {
  username   = data.btp_whoami.me.email
  type       = "space_developer"
  space      = cloudfoundry_space.dev.id
  origin     = "sap.ids"
}

# ------------------------------------------------------------------------------------------------------
# SAP AI Core — Service Instance and Service Key
# ------------------------------------------------------------------------------------------------------
data "cloudfoundry_service" "ai_core" {
  count = var.enable_service_setup__ai_core ? 1 : 0
  name  = "aicore"
}

resource "cloudfoundry_service_instance" "ai_core" {
  count = var.enable_service_setup__ai_core ? 1 : 0

  name         = var.ai_core_instance_name
  type         = "managed"
  service_plan = data.cloudfoundry_service.ai_core[0].service_plans[var.service_plan__ai_core]
  space        = cloudfoundry_space.dev.id
  depends_on   = [cloudfoundry_space_role.space_developer, cloudfoundry_space_role.space_manager, cloudfoundry_org_role.organization_manager_custom_idp, cloudfoundry_org_role.organization_user_custom_idp, cloudfoundry_space_role.space_developer_terraform_user]
}

resource "cloudfoundry_service_credential_binding" "ai_core_key" {
  count = var.enable_service_setup__ai_core ? 1 : 0

  name             = var.ai_core_service_key_name
  type             = "key"
  service_instance = cloudfoundry_service_instance.ai_core[0].id
}

# ------------------------------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------------------------------
output "cf_space_id" {
  description = "The Cloud Foundry dev space ID."
  value       = cloudfoundry_space.dev.id
}

output "ai_core_instance_id" {
  description = "SAP AI Core service instance ID."
  value       = var.enable_service_setup__ai_core ? cloudfoundry_service_instance.ai_core[0].id : null
}

output "ai_core_service_key_id" {
  description = "SAP AI Core service key binding ID."
  value       = var.enable_service_setup__ai_core ? cloudfoundry_service_credential_binding.ai_core_key[0].id : null
}
