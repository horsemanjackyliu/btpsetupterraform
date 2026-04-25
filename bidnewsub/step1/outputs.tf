# ------------------------------------------------------------------------------------------------------
# Subaccount
# ------------------------------------------------------------------------------------------------------
output "subaccount_id" {
  description = "The ID of the BTP subaccount."
  value       = data.btp_subaccount.this.id
}

output "custom_idp" {
  description = "The custom identity provider configured for the subaccount."
  value       = var.custom_idp
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
output "cf_landscape_label" {
  description = "The Cloud Foundry landscape label."
  value       = btp_subaccount_environment_instance.cloudfoundry.landscape_label
}

output "cf_api_url" {
  description = "The Cloud Foundry API endpoint URL — pass as cf_api_url in step2."
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
}

output "cf_org_id" {
  description = "The Cloud Foundry Org ID — pass as cf_org_id in step2."
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]
}

output "cf_org_name" {
  description = "The Cloud Foundry Org name."
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]
}

output "cf_space_name" {
  description = "The CF space name to create in step2."
  value       = var.cf_space_name
}

# ------------------------------------------------------------------------------------------------------
# Subscription URLs
# ------------------------------------------------------------------------------------------------------
output "ai_launchpad_subscription_url" {
  description = "The URL of the subscribed SAP AI Launchpad application."
  value       = var.enable_app_subscription_setup__ai_launchpad ? btp_subaccount_subscription.ai_launchpad[0].subscription_url : null
}

output "sap_launchpad_subscription_url" {
  description = "The URL of the subscribed SAP Build Work Zone application."
  value       = var.enable_app_subscription_setup__sap_launchpad ? btp_subaccount_subscription.sap_launchpad[0].subscription_url : null
}

output "hana_cloud_tools_subscription_url" {
  description = "The URL of the subscribed SAP HANA Cloud Tools application."
  value       = var.enable_app_subscription_setup__hana_cloud_tools ? btp_subaccount_subscription.hana_cloud_tools[0].subscription_url : null
}
