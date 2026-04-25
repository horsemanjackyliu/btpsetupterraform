# ------------------------------------------------------------------------------------------------------
# Subaccount setup for BTP AI Procurement use case
# ------------------------------------------------------------------------------------------------------
locals {
  subaccount_domain = var.subaccount_domain == "" ? "bidsub" : var.subaccount_domain
  subaccount_name   = var.subaccount_name == "" ? "bidsub" : var.subaccount_name
}

resource "btp_subaccount" "this" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = local.subaccount_name
  subdomain = local.subaccount_domain
  region    = var.region
}

data "btp_subaccount" "this" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.this[0].id
}

# Assign custom IDP (if custom_idp is set)
resource "btp_subaccount_trust_configuration" "custom_idp" {
  count             = var.custom_idp == "" ? 0 : 1
  subaccount_id     = data.btp_subaccount.this.id
  identity_provider = var.custom_idp
  available_for_user_logon = true
}

data "btp_whoami" "me" {}

locals {
  custom_idp_origin = var.custom_idp != "" ? "sap.custom" : "sap.default"
  # custom_idp_origin = "sap.custom"
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
locals {
  service_env_name__cloudfoundry = "cloudfoundry"
  cf_org_name                    = var.cf_org_name == "" ? local.subaccount_name : var.cf_org_name
}

resource "btp_subaccount_entitlement" "cloudfoundry" {
  count = var.service_env_plan__cloudfoundry == "free" ? 1 : 0

  subaccount_id = btp_subaccount.this[0].id
  service_name  = local.service_env_name__cloudfoundry
  plan_name     = var.service_env_plan__cloudfoundry
  amount        = 1
}

data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.this.id
}

resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}

resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = data.btp_subaccount.this.id
  name             = local.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = local.service_env_name__cloudfoundry
  plan_name        = var.service_env_plan__cloudfoundry
  landscape_label  = terraform_data.cf_landscape_label.output

  parameters = jsonencode({
    instance_name = local.cf_org_name
  })
  depends_on = [btp_subaccount_entitlement.cloudfoundry]
}

# ------------------------------------------------------------------------------------------------------
# Entitlements — Services
# ------------------------------------------------------------------------------------------------------
locals {
  service_name__ai_core         = "aicore"
  service_name__hana_cloud      = "hana-cloud"
  service_name__hana            = "hana"
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

resource "btp_subaccount_entitlement" "hana" {
  count = var.enable_service_setup__hana ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.service_name__hana
  plan_name     = var.service_plan__hana
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
  app_subscription_serv_name__ai_launchpad     = "ai-launchpad"
  app_subscription_serv_name__sap_launchpad    = "SAPLaunchpad"
  app_subscription_serv_name__hana_cloud_tools = "hana-cloud-tools"
}

resource "btp_subaccount_entitlement" "ai_launchpad" {
  count = var.enable_app_subscription_setup__ai_launchpad ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  service_name  = local.app_subscription_serv_name__ai_launchpad
  plan_name     = var.app_subscription_plan__ai_launchpad
  depends_on    = [btp_subaccount_entitlement.ai_core]
}

resource "btp_subaccount_entitlement" "sap_launchpad" {
  count = var.enable_app_subscription_setup__sap_launchpad ? 1 : 0

  subaccount_id = btp_subaccount.this[0].id
  service_name  = local.app_subscription_serv_name__sap_launchpad
  plan_name     = var.app_subscription_plan__sap_launchpad
  amount        = var.app_subscription_plan__sap_launchpad == "free" ? 1 : null
}

resource "btp_subaccount_entitlement" "hana_cloud_tools" {
  count = var.enable_app_subscription_setup__hana_cloud_tools ? 1 : 0

  subaccount_id = btp_subaccount.this[0].id
  service_name  = local.app_subscription_serv_name__hana_cloud_tools
  plan_name     = var.app_subscription_plan__hana_cloud_tools
}

resource "btp_subaccount_subscription" "ai_launchpad" {
  count = var.enable_app_subscription_setup__ai_launchpad ? 1 : 0

  subaccount_id = data.btp_subaccount.this.id
  app_name      = local.app_subscription_serv_name__ai_launchpad
  plan_name     = var.app_subscription_plan__ai_launchpad
  depends_on    = [btp_subaccount_entitlement.ai_launchpad]
}

resource "btp_subaccount_subscription" "sap_launchpad" {
  count = var.enable_app_subscription_setup__sap_launchpad ? 1 : 0

  subaccount_id = btp_subaccount.this[0].id
  app_name      = local.app_subscription_serv_name__sap_launchpad
  plan_name     = var.app_subscription_plan__sap_launchpad
  depends_on    = [btp_subaccount_entitlement.sap_launchpad, btp_subaccount_trust_configuration.custom_idp]
}

resource "btp_subaccount_subscription" "hana_cloud_tools" {
  count = var.enable_app_subscription_setup__hana_cloud_tools ? 1 : 0

  subaccount_id = btp_subaccount.this[0].id
  app_name      = local.app_subscription_serv_name__hana_cloud_tools
  plan_name     = var.app_subscription_plan__hana_cloud_tools
  depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
}

# ------------------------------------------------------------------------------------------------------
# Role Collection Assignments — Subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each = toset(var.subaccount_admins)

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount.this]
}

resource "btp_subaccount_role_collection_assignment" "subaccount_admin_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.subaccount_admins) : toset([])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount.this, btp_subaccount_trust_configuration.custom_idp]
}

resource "btp_subaccount_role_collection_assignment" "subaccount_service_admin" {
  for_each = toset(var.subaccount_service_admins)

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount.this]
}

resource "btp_subaccount_role_collection_assignment" "subaccount_service_admin_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.subaccount_service_admins) : toset([])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount.this, btp_subaccount_trust_configuration.custom_idp]
}

# ------------------------------------------------------------------------------------------------------
# Role Collection Assignments — AI Launchpad
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "ailaunchpad_genai_administrator" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_genai_administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin != "" ? local.custom_idp_origin : "sap.default"
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_genai_experimenter" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_genai_experimenter"
  user_name            = each.value
  origin               = local.custom_idp_origin != "" ? local.custom_idp_origin : "sap.default"
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "ailaunchpad_genai_manager" {
  for_each = toset(var.enable_app_subscription_setup__ai_launchpad ? var.ai_launchpad_admins : [])

  subaccount_id        = data.btp_subaccount.this.id
  role_collection_name = "ailaunchpad_genai_manager"
  user_name            = each.value
  origin               = local.custom_idp_origin != "" ? local.custom_idp_origin : "sap.default"
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}




# ------------------------------------------------------------------------------------------------------
# Role Collection Assignments — SAP Build Work Zone (Launchpad)
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each = toset(var.enable_app_subscription_setup__sap_launchpad ? var.launchpad_admins : [])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}

resource "btp_subaccount_role_collection_assignment" "launchpad_admin_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.enable_app_subscription_setup__sap_launchpad ? var.launchpad_admins : []) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}


resource "btp_subaccount_role_collection_assignment" "destination_administrator" {
  for_each = toset(var.launchpad_admins)

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Destination Administrator"
  user_name            = each.value
  origin               = "sap.default"
}

resource "btp_subaccount_role_collection_assignment" "destination_administrator_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.launchpad_admins) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Destination Administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_trust_configuration.custom_idp]
}

resource "btp_subaccount_role_collection_assignment" "cloud_connector_administrator" {
  for_each = toset(var.launchpad_admins)

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Cloud Connector Administrator"
  user_name            = each.value
  origin               = "sap.default"
}

resource "btp_subaccount_role_collection_assignment" "cloud_connector_administrator_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.launchpad_admins) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Cloud Connector Administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_trust_configuration.custom_idp]
}

resource "btp_subaccount_role_collection_assignment" "connectivity_and_destination_administrator" {
  for_each = toset(var.launchpad_admins)

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
  origin               = "sap.default"
}

resource "btp_subaccount_role_collection_assignment" "connectivity_and_destination_administrator_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.launchpad_admins) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_trust_configuration.custom_idp]
}

# ------------------------------------------------------------------------------------------------------
# Role Collection Assignments — SAP HANA Cloud Tools
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "hana_cloud_tools_admins" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_tools_admins_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : []) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_security_administrator" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Security Administrator"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_security_administrator_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : []) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Security Administrator"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_viewer" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Viewer"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_viewer_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : []) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Viewer"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_data_publisher_viewer" {
  for_each = toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : [])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Data Publisher Viewer"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_data_publisher_viewer_custom_idp" {
  for_each = var.custom_idp != "" ? toset(var.enable_app_subscription_setup__hana_cloud_tools ? var.hana_cloud_admins : []) : toset([])

  subaccount_id        = btp_subaccount.this[0].id
  role_collection_name = "SAP HANA Cloud Data Publisher Viewer"
  user_name            = each.value
  origin               = local.custom_idp_origin
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

# ------------------------------------------------------------------------------------------------------
# Auto-generate step2/terraform.tfvars
# ------------------------------------------------------------------------------------------------------
resource "local_file" "step2_tfvars" {
  count = var.create_tfvars_file_for_step2 ? 1 : 0

  filename = "${path.module}/../step2/terraform.tfvars"
  content  = <<-EOT
    globalaccount = "${var.globalaccount}"
    custom_idp    = "${var.custom_idp}"
    subaccount_id = "${data.btp_subaccount.this.id}"

    cf_api_url    = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
    cf_org_id     = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]}"
    cf_space_name = "${var.cf_space_name}"
    cf_origin     = "${var.custom_idp != "" ? "sap.custom" : "sap.ids"}"

    cf_space_managers   = ${jsonencode(var.cf_space_managers)}
    cf_space_developers = ${jsonencode(var.cf_space_developers)}

    cf_org_managers = ${jsonencode(var.cf_org_managers)}
    cf_org_users    = ${jsonencode(var.cf_org_users)}
  EOT
}
