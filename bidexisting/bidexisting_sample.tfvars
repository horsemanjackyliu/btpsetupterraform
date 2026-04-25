# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount = "<your-global-account-subdomain>"
custom_idp    = "<your-custom-idp-tenant>.accounts.ondemand.com"
subaccount_id = "<your-subaccount-id>"

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry (existing org and space — nothing will be created)
# ------------------------------------------------------------------------------------------------------
cf_api_url    = "https://api.cf.<region>.hana.ondemand.com"
cf_org_id     = "<your-cf-org-guid>"          # Fill in: your CF Org ID (GUID)
cf_space_name = "dev"
cf_origin     = "<your-custom-idp-tenant>-platform"

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
ai_launchpad_admins = ["<your-email@example.com>"]
launchpad_admins    = ["<your-email@example.com>"]
hana_cloud_admins   = ["<your-email@example.com>"]

# ------------------------------------------------------------------------------------------------------
# Enable/disable individual services and subscriptions
# ------------------------------------------------------------------------------------------------------
enable_service_setup__ai_core                   = true
enable_service_setup__hana_cloud                = false
enable_service_setup__objectstore               = false
enable_service_setup__xsuaa                     = false
enable_service_setup__destination               = false
enable_service_setup__html5_apps_repo           = false
enable_app_subscription_setup__ai_launchpad     = true
enable_app_subscription_setup__sap_launchpad    = true
enable_app_subscription_setup__hana_cloud_tools = true
