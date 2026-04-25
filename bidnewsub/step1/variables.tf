# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
variable "globalaccount" {
  description = "The subdomain (UUID) of the SAP BTP global account."
  type        = string
}

variable "cli_server_url" {
  description = "The BTP CLI server URL."
  type        = string
  default     = "https://cli.btp.cloud.sap"
}

variable "custom_idp" {
  description = "Custom IDP tenant (e.g. <tenant>.accounts.ondemand.com). Leave empty to use default."
  type        = string
  default     = ""
}

variable "region" {
  description = "The BTP region to deploy the subaccount into (e.g. us10)."
  type        = string
}

variable "subaccount_id" {
  description = "ID of an existing subaccount to reuse. Leave empty to create a new one."
  type        = string
  default     = ""
}

variable "subaccount_name" {
  description = "Display name for the subaccount."
  type        = string
  default     = "bidsub"
}

variable "subaccount_domain" {
  description = "Subdomain for the subaccount."
  type        = string
  default     = "bidsub"
}

variable "subaccount_admins" {
  description = "Users assigned the Subaccount Administrator role collection."
  type        = list(string)
}

variable "subaccount_service_admins" {
  description = "Users assigned the Subaccount Service Administrator role collection."
  type        = list(string)
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
variable "service_env_plan__cloudfoundry" {
  description = "The plan for the Cloud Foundry environment."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["free", "standard"], var.service_env_plan__cloudfoundry)
    error_message = "Valid values are 'free' and 'standard'."
  }
}

variable "cf_landscape_label" {
  description = "CF landscape label override. Auto-detected if empty."
  type        = string
  default     = ""
}

variable "cf_org_name" {
  description = "CF org name. Defaults to subaccount_name if empty."
  type        = string
  default     = ""
}

variable "cf_api_url" {
  description = "The Cloud Foundry API endpoint URL (e.g. https://api.cf.us10.hana.ondemand.com). Required for org member assignment."
  type        = string
  default     = ""
}

variable "cf_org_managers" {
  description = "Users assigned CF Org Manager role (both sap.ids and custom IDP origins)."
  type        = list(string)
  default     = []
}

variable "cf_org_users" {
  description = "Users assigned CF Org User role (custom IDP origin)."
  type        = list(string)
  default     = []
}

variable "cf_space_name" {
  description = "CF space name to create in step2."
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_space_name))
    error_message = "The CF space name must not be empty and must not exceed 255 characters."
  }
}

variable "cf_space_managers" {
  description = "Users assigned the CF Space Manager role."
  type        = list(string)
}

variable "cf_space_developers" {
  description = "Users assigned the CF Space Developer role."
  type        = list(string)
}

# ------------------------------------------------------------------------------------------------------
# SAP AI Core
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__ai_core" {
  description = "Enable entitlement of SAP AI Core."
  type        = bool
  default     = true
}

variable "service_plan__ai_core" {
  description = "The plan for SAP AI Core."
  type        = string
  default     = "extended"

  validation {
    condition     = contains(["free", "extended", "standard"], var.service_plan__ai_core)
    error_message = "Valid values are 'free', 'extended', and 'standard'."
  }
}

# ------------------------------------------------------------------------------------------------------
# SAP AI Launchpad
# ------------------------------------------------------------------------------------------------------
variable "enable_app_subscription_setup__ai_launchpad" {
  description = "Enable entitlement and subscription to SAP AI Launchpad."
  type        = bool
  default     = true
}

variable "app_subscription_plan__ai_launchpad" {
  description = "The plan for SAP AI Launchpad."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard"], var.app_subscription_plan__ai_launchpad)
    error_message = "Valid value is 'standard'."
  }
}

variable "ai_launchpad_admins" {
  description = "Users assigned the SAP AI Launchpad role collections."
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------------------------------------------------
# SAP HANA Cloud
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__hana_cloud" {
  description = "Enable entitlement of SAP HANA Cloud."
  type        = bool
  default     = true
}

variable "service_plan__hana_cloud" {
  description = "The plan for SAP HANA Cloud."
  type        = string
  default     = "hana"

  validation {
    condition     = contains(["hana", "hana-free", "hana-cloud-tools"], var.service_plan__hana_cloud)
    error_message = "Valid values are 'hana', 'hana-free', and 'hana-cloud-tools'."
  }
}

variable "hana_cloud_admins" {
  description = "Users assigned the SAP HANA Cloud Administrator role collection."
  type        = list(string)
}

# ------------------------------------------------------------------------------------------------------
# SAP HANA Schemas & HDI Containers
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__hana" {
  description = "Enable entitlement of SAP HANA Schemas & HDI Containers."
  type        = bool
  default     = true
}

variable "service_plan__hana" {
  description = "The plan for SAP HANA Schemas & HDI Containers."
  type        = string
  default     = "hdi-shared"

  validation {
    condition     = contains(["hdi-shared"], var.service_plan__hana)
    error_message = "Valid value is 'hdi-shared'."
  }
}

# ------------------------------------------------------------------------------------------------------
# SAP Object Store
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__objectstore" {
  description = "Enable entitlement of SAP Object Store (Amazon S3)."
  type        = bool
  default     = true
}

variable "service_plan__objectstore" {
  description = "The plan for SAP Object Store."
  type        = string
  default     = "s3-standard"
}

# ------------------------------------------------------------------------------------------------------
# XSUAA
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__xsuaa" {
  description = "Enable entitlement of SAP Authorization and Trust Management (XSUAA)."
  type        = bool
  default     = true
}

variable "service_plan__xsuaa" {
  description = "The plan for XSUAA."
  type        = string
  default     = "application"

  validation {
    condition     = contains(["application", "broker", "space"], var.service_plan__xsuaa)
    error_message = "Valid values are 'application', 'broker', and 'space'."
  }
}

# ------------------------------------------------------------------------------------------------------
# SAP Destination Service
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__destination" {
  description = "Enable entitlement of SAP Destination Service."
  type        = bool
  default     = true
}

variable "service_plan__destination" {
  description = "The plan for SAP Destination Service."
  type        = string
  default     = "lite"

  validation {
    condition     = contains(["lite"], var.service_plan__destination)
    error_message = "Valid value is 'lite'."
  }
}

# ------------------------------------------------------------------------------------------------------
# SAP HTML5 Application Repository
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__html5_apps_repo" {
  description = "Enable entitlement of SAP HTML5 Application Repository."
  type        = bool
  default     = true
}

variable "service_plan__html5_apps_repo" {
  description = "The plan for SAP HTML5 Application Repository."
  type        = string
  default     = "app-host"

  validation {
    condition     = contains(["app-host", "app-runtime"], var.service_plan__html5_apps_repo)
    error_message = "Valid values are 'app-host' and 'app-runtime'."
  }
}

# ------------------------------------------------------------------------------------------------------
# SAP Build Work Zone
# ------------------------------------------------------------------------------------------------------
variable "enable_app_subscription_setup__sap_launchpad" {
  description = "Enable entitlement and subscription to SAP Build Work Zone (standard edition)."
  type        = bool
  default     = true
}

variable "app_subscription_plan__sap_launchpad" {
  description = "The plan for SAP Build Work Zone."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["free", "standard"], var.app_subscription_plan__sap_launchpad)
    error_message = "Valid values are 'free' and 'standard'."
  }
}

variable "launchpad_admins" {
  description = "Users assigned the Launchpad_Admin role collection."
  type        = list(string)
}

# ------------------------------------------------------------------------------------------------------
# SAP HANA Cloud Tools
# ------------------------------------------------------------------------------------------------------
variable "enable_app_subscription_setup__hana_cloud_tools" {
  description = "Enable entitlement and subscription to SAP HANA Cloud Tools."
  type        = bool
  default     = true
}

variable "app_subscription_plan__hana_cloud_tools" {
  description = "The plan for SAP HANA Cloud Tools."
  type        = string
  default     = "tools"

  validation {
    condition     = contains(["tools"], var.app_subscription_plan__hana_cloud_tools)
    error_message = "Valid value is 'tools'."
  }
}

# ------------------------------------------------------------------------------------------------------
# Output control
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  description = "Auto-generate step2/terraform.tfvars after apply."
  type        = bool
  default     = true
}
