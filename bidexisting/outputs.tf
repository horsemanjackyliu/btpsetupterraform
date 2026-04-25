# ------------------------------------------------------------------------------------------------------
# Subaccount
# ------------------------------------------------------------------------------------------------------
output "subaccount_id" {
  description = "The ID of the existing BTP subaccount."
  value       = data.btp_subaccount.this.id
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry
# ------------------------------------------------------------------------------------------------------
output "cf_space_id" {
  description = "The Cloud Foundry dev space ID."
  value       = data.cloudfoundry_space.dev.id
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

# ------------------------------------------------------------------------------------------------------
# Service instances
# ------------------------------------------------------------------------------------------------------
output "ai_core_instance_id" {
  description = "SAP AI Core service instance ID."
  value       = var.enable_service_setup__ai_core ? cloudfoundry_service_instance.ai_core[0].id : null
}

output "ai_core_service_key_id" {
  description = "SAP AI Core service key binding ID."
  value       = var.enable_service_setup__ai_core ? cloudfoundry_service_credential_binding.ai_core_key[0].id : null
}

output "objectstore_instance_id" {
  description = "SAP Object Store service instance ID."
  value       = var.enable_service_setup__objectstore ? cloudfoundry_service_instance.objectstore[0].id : null
}
