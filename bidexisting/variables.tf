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
  description = "Custom IDP tenant (e.g. <tenant>.accounts.ondemand.com). Leave empty for default."
  type        = string
  default     = ""
}

variable "subaccount_id" {
  description = "ID of the existing BTP subaccount."
  type        = string
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry
# ------------------------------------------------------------------------------------------------------
variable "cf_api_url" {
  description = "The Cloud Foundry API endpoint URL."
  type        = string
}

variable "cf_org_id" {
  description = "The Cloud Foundry Org ID of the existing org."
  type        = string
}

variable "cf_space_name" {
  description = "The existing CF space name to deploy service instances into."
  type        = string
  default     = "dev"
}

variable "cf_origin" {
  description = "UAA origin for CF authentication. Use '<tenant>-platform' for custom IDP, or 'sap.ids' for default."
  type        = string
  default     = "sap.ids"
}

# ------------------------------------------------------------------------------------------------------
# SAP AI Core
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__ai_core" {
  description = "Enable entitlement and CF service instance for SAP AI Core."
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

variable "ai_core_instance_name" {
  description = "Name for the SAP AI Core service instance."
  type        = string
  default     = "ai-core-default"
}

variable "ai_core_service_key_name" {
  description = "Name for the SAP AI Core service key."
  type        = string
  default     = "ai-core-key"
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
  description = "Users assigned the SAP AI Launchpad Administrator role collection."
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------------------------------------------------
# SAP HANA Cloud
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__hana_cloud" {
  description = "Enable entitlement and subscription to SAP HANA Cloud."
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
  default     = []
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
# SAP Object Store
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__objectstore" {
  description = "Enable entitlement and CF service instance for SAP Object Store (Amazon S3)."
  type        = bool
  default     = true
}

variable "service_plan__objectstore" {
  description = "The plan for SAP Object Store."
  type        = string
  default     = "s3-standard"
}

variable "objectstore_instance_name" {
  description = "Name for the SAP Object Store service instance."
  type        = string
  default     = "objectstore-default"
}

# ------------------------------------------------------------------------------------------------------
# XSUAA
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__xsuaa" {
  description = "Enable entitlement for SAP Authorization and Trust Management (XSUAA)."
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
  default     = []
}

# ------------------------------------------------------------------------------------------------------
# SAP Destination Service
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__destination" {
  description = "Enable entitlement for SAP Destination Service."
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
  description = "Enable entitlement for SAP HTML5 Application Repository."
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
