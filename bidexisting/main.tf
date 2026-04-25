# ------------------------------------------------------------------------------------------------------
# Existing subaccount and CF space (read-only data sources — nothing is created here)
# ------------------------------------------------------------------------------------------------------
data "btp_subaccount" "this" {
  id = var.subaccount_id
}

data "btp_whoami" "me" {}

locals {
  custom_idp_tenant = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key        = var.custom_idp != "" ? "${local.custom_idp_tenant}" : "sap.default"
}

data "cloudfoundry_space" "dev" {
  name = var.cf_space_name
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# Entitlements — Services
# ------------------------------------------------------------------------------------------------------
locals {
  service_name__ai_core         = "aicore"
  service_name__hana_cloud      = "hana-cloud"
  service_name__objectstore     = "objectstore"
  service_name__xsuaa           = "xsuaa"
  service_name__destination     = "destination"
  service_name__html5_apps_repo = "html5-apps-repo"
}

resource "btp_subaccount_entitlement" "ai_core" {
  count = var.enable_service_setup__ai_core ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__ai_core
  plan_name     = var.service_plan__ai_core
}

resource "btp_subaccount_entitlement" "hana_cloud" {
  count = var.enable_service_setup__hana_cloud ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__hana_cloud
  plan_name     = var.service_plan__hana_cloud
}

resource "btp_subaccount_entitlement" "objectstore" {
  count = var.enable_service_setup__objectstore ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__objectstore
  plan_name     = var.service_plan__objectstore
}

resource "btp_subaccount_entitlement" "xsuaa" {
  count = var.enable_service_setup__xsuaa ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__xsuaa
  plan_name     = var.service_plan__xsuaa
}

resource "btp_subaccount_entitlement" "destination" {
  count = var.enable_service_setup__destination ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__destination
  plan_name     = var.service_plan__destination
}

resource "btp_subaccount_entitlement" "html5_apps_repo" {
  count = var.enable_service_setup__html5_apps_repo ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__html5_apps_repo
  plan_name     = var.service_plan__html5_apps_repo
}

# ------------------------------------------------------------------------------------------------------
# Entitlements & Subscriptions — Apps
# ------------------------------------------------------------------------------------------------------
locals {
  app_name__ai_launchpad    = "ai-launchpad"
  app_name__sap_launchpad   = "SAPLaunchpad"
  app_name__hana_cloud_tools = "hana-cloud-tools"
}

resource "btp_subaccount_entitlement" "ai_launchpad" {
  count = var.enable_app_subscription_setup__ai_launchpad ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.app_name__ai_launchpad
  plan_name     = var.app_subscription_plan__ai_launchpad
  depends_on    = [btp_subaccount_entitlement.ai_core]
}

resource "btp_subaccount_subscription" "ai_launchpad" {
  count = var.enable_app_subscription_setup__ai_launchpad ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  app_name      = local.app_name__ai_launchpad
  plan_name     = var.app_subscription_plan__ai_launchpad
  depends_on    = [btp_subaccount_entitlement.ai_launchpad]
}

data "btp_subaccount_roles" "all" {
  subaccount_id = data.btp_subaccount.this.id
  depends_on    = [btp_subaccount_subscription.ai_launchpad]
}

locals {
  aicore_admin_role = one([
    for r in data.btp_subaccount_roles.all.values :
    r if r.role_template_name == "aicore_admin_editor_all"
  ])
}

resource "btp_subaccount_role_collection" "ai_launchpad_admin" {
  count = var.enable_app_subscription_setup__ai_launchpad ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  name          = "AI Launchpad Administrator"
  description   = "Administrate SAP AI Launchpad"

  roles = [
    {
      name                 = local.aicore_admin_role.name
      role_template_app_id = local.aicore_admin_role.app_id
      role_template_name   = local.aicore_admin_role.role_template_name
    }
  ]

  depends_on = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ai_launchpad_admins" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = btp_subaccount_role_collection.ai_launchpad_admin[0].name
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_role_collection.ai_launchpad_admin]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_genai_administrator" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_genai_administrator"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_genai_manager" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_genai_manager"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_allow_all_resourcegroups" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_allow_all_resourcegroups"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_genai_experimenter" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_genai_experimenter"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_mloperations_editor" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_mloperations_editor"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_functions_explorer_editor_v2" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_functions_explorer_editor_v2"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_functions_explorer_editor_without_genai" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_functions_explorer_editor_without_genai"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_aicore_admin_viewer" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_aicore_admin_viewer"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_entitlement" "hana_cloud_subscription" {
  count = var.enable_service_setup__hana_cloud ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__hana_cloud
  plan_name     = var.service_plan__hana_cloud
}

resource "btp_subaccount_entitlement" "hana_cloud_tools" {
  count = var.enable_app_subscription_setup__hana_cloud_tools ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.app_name__hana_cloud_tools
  plan_name     = var.app_subscription_plan__hana_cloud_tools
}

resource "btp_subaccount_subscription" "hana_cloud_tools" {
  count = var.enable_app_subscription_setup__hana_cloud_tools ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  app_name      = local.app_name__hana_cloud_tools
  plan_name     = var.app_subscription_plan__hana_cloud_tools
  depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_admins" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_security_administrator" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "SAP HANA Cloud Security Administrator"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_viewer" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "SAP HANA Cloud Viewer"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_data_publisher_viewer" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "SAP HANA Cloud Data Publisher Viewer"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_entitlement" "sap_launchpad" {
  count = var.enable_app_subscription_setup__sap_launchpad ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.app_name__sap_launchpad
  plan_name     = var.app_subscription_plan__sap_launchpad
  amount        = var.app_subscription_plan__sap_launchpad == "free" ? 1 : null
}

resource "btp_subaccount_subscription" "sap_launchpad" {
  count = var.enable_app_subscription_setup__sap_launchpad ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  app_name      = local.app_name__sap_launchpad
  plan_name     = var.app_subscription_plan__sap_launchpad
  depends_on    = [btp_subaccount_entitlement.sap_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "launchpad_admins" {
  for_each = toset(var.enable_app_subscription_setup__sap_launchpad ? var.launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "launchpad_admin_read_only" {
  for_each = toset(var.enable_app_subscription_setup__sap_launchpad ? var.launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Launchpad_Admin_Read_Only"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "launchpad_advanced_theming" {
  for_each = toset(var.enable_app_subscription_setup__sap_launchpad ? var.launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Launchpad_Advanced_Theming"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "launchpad_external_user" {
  for_each = toset(var.enable_app_subscription_setup__sap_launchpad ? var.launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Launchpad_External_User"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "destination_administrator" {
  for_each = toset(var.launchpad_admins)

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Destination Administrator"
  user_name            = each.value
  origin               = local.origin_key
}

resource "btp_subaccount_role_collection_assignment" "cloud_connector_administrator" {
  for_each = toset(var.launchpad_admins)

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Cloud Connector Administrator"
  user_name            = each.value
  origin               = local.origin_key
}

resource "btp_subaccount_role_collection_assignment" "connectivity_and_destination_administrator" {
  for_each = toset(var.launchpad_admins)

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
  origin               = local.origin_key
}

# ------------------------------------------------------------------------------------------------------
# CF Service Instances — in existing dev space
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
  space        = data.cloudfoundry_space.dev.id
  depends_on   = [btp_subaccount_entitlement.ai_core]
}

resource "cloudfoundry_service_credential_binding" "ai_core_key" {
  count = var.enable_service_setup__ai_core ? 1 : 0

  name             = var.ai_core_service_key_name
  type             = "key"
  service_instance = cloudfoundry_service_instance.ai_core[0].id
}

data "cloudfoundry_service" "objectstore" {
  count = var.enable_service_setup__objectstore ? 1 : 0
  name  = "objectstore"
}

resource "cloudfoundry_service_instance" "objectstore" {
  count = var.enable_service_setup__objectstore ? 1 : 0

  name         = var.objectstore_instance_name
  type         = "managed"
  service_plan = data.cloudfoundry_service.objectstore[0].service_plans[var.service_plan__objectstore]
  space        = data.cloudfoundry_space.dev.id
  depends_on   = [btp_subaccount_entitlement.objectstore]
}
