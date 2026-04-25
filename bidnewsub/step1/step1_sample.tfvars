# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount     = "<your-global-account-subdomain>"
subaccount_name   = "bidsub"
subaccount_domain = "bidsub"
region            = "us10"

custom_idp = "<your-custom-idp-tenant>.accounts.ondemand.com"

service_env_plan__cloudfoundry = "standard"

subaccount_admins         = ["<your-email@example.com>"]
subaccount_service_admins = ["<your-email@example.com>"]

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry org member assignments (done in step1 via CF provider)
# ------------------------------------------------------------------------------------------------------
cf_api_url      = "https://api.cf.<region>.hana.ondemand.com"
cf_org_managers = ["<your-email@example.com>"]
cf_org_users    = ["<your-email@example.com>"]

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
cf_space_managers   = ["<your-email@example.com>"]
cf_space_developers = ["<your-email@example.com>"]

launchpad_admins  = ["<your-email@example.com>"]
hana_cloud_admins = ["<your-email@example.com>"]

# Auto-generate step2/terraform.tfvars after apply
create_tfvars_file_for_step2 = true

# (optional) enable/disable individual services
#enable_service_setup__ai_core                   = false
#enable_service_setup__hana_cloud                = false
#enable_service_setup__hana                      = false
#enable_service_setup__objectstore               = false
#enable_service_setup__xsuaa                     = false
#enable_service_setup__destination               = false
#enable_service_setup__html5_apps_repo           = false
#enable_app_subscription_setup__ai_launchpad     = false
#enable_app_subscription_setup__sap_launchpad    = false
#enable_app_subscription_setup__hana_cloud_tools = false