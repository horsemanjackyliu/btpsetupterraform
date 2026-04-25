# ------------------------------------------------------------------------------------------------------
# Account settings (from step1 outputs via auto-generated terraform.tfvars)
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

variable "subaccount_id" {
  description = "The BTP subaccount ID (from step1 output)."
  type        = string
}

variable "custom_idp" {
  description = "Custom IDP tenant. Used to determine the origin key and trust configuration."
  type        = string
  default     = ""
}

# ------------------------------------------------------------------------------------------------------
# Cloud Foundry
# ------------------------------------------------------------------------------------------------------
variable "cf_api_url" {
  description = "The Cloud Foundry API endpoint URL (from step1 output)."
  type        = string
}


variable "cf_origin" {
  description = "The UAA origin for CF authentication. Use '<tenant>-platform' for custom IDP (e.g. techrig-platform), or 'sap.ids' for default."
  type        = string
  default     = "sap.ids"
}

variable "cf_org_id" {
  description = "The Cloud Foundry Org ID (from step1 output)."
  type        = string
}

variable "cf_org_managers" {
  description = "Users assigned CF Org Manager role."
  type        = list(string)
  default     = []
}

variable "cf_org_users" {
  description = "Users assigned CF Org User role."
  type        = list(string)
  default     = []
}

variable "cf_space_name" {
  description = "CF space name to create."
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
# SAP AI Core instance
# ------------------------------------------------------------------------------------------------------
variable "enable_service_setup__ai_core" {
  description = "Enable creation of SAP AI Core service instance and service key."
  type        = bool
  default     = true
}

variable "service_plan__ai_core" {
  description = "The plan for SAP AI Core instance."
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
