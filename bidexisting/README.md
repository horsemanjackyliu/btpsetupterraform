# AI-Powered Procurement Bidding Evaluation — BTP Setup for Existing Subaccount

## Overview

This sample shows how to set up your SAP BTP account for the Discovery Center Mission - [AI-Powered Procurement Bidding Evaluation](https://discovery-center.cloud.sap/index.html#/missiondetail/4327/) when you already have an existing Enterprise BTP subaccount with Cloud Foundry and a `dev` space provisioned.

Unlike the [`bidnewsub`](../bidnewsub/README.md) setup which creates a new subaccount and CF environment from scratch, this configuration targets an **existing** subaccount. No subaccount, CF org, or CF space is created — all existing infrastructure is referenced via data sources.

## Prerequisites

- BTP subaccount already exists
- Custom IDP already configured on the subaccount
- Cloud Foundry environment and `dev` space already created
- BTP Global Account admin credentials

## Content of setup

A single Terraform configuration using both `SAP/btp` and `SAP/cloudfoundry` providers.

### BTP Entitlements

- SAP AI Core (`aicore`) — extended plan
- SAP HANA Cloud (`hana-cloud`) — hana plan
- Object Store (`objectstore`) — s3-standard plan
- XSUAA (`xsuaa`) — application plan
- Destination (`destination`) — lite plan
- HTML5 Application Repository (`html5-apps-repo`) — app-host plan

### BTP Subscriptions

- SAP AI Launchpad (`ai-launchpad`) — standard plan
- SAP Build Work Zone, standard edition (`SAPLaunchpad`) — standard plan
- SAP HANA Cloud Tools (`hana-cloud-tools`) — tools plan

### Role collection assignments

- **AI Launchpad Administrator** — `ai_launchpad_admins`
- **Launchpad_Admin** — `launchpad_admins`
- **SAP HANA Cloud Administrator** — `hana_cloud_admins`

### CF Service Instances (in existing `dev` space)

- SAP AI Core managed service instance (`extended` plan) + service key
- SAP Object Store managed service instance (`s3-standard` plan)

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html).

### Step 1 — Set credentials

Set your BTP and CF credentials as environment variables:

```bash
export BTP_USERNAME="<Email address of your BTP user>"
export BTP_PASSWORD="<Password of your BTP user>"
export CF_USER="<Email address of your BTP user>"
export CF_PASSWORD="<Password of your BTP user>"
```

### Step 2 — Configure variables

Edit `bidexisting.tfvars` to match your environment. The minimal set of parameters to specify:

```hcl
globalaccount = "<your-global-account-subdomain>"
custom_idp    = "<your-custom-idp-tenant>.accounts.ondemand.com"
subaccount_id = "<your-subaccount-id>"

cf_api_url    = "https://api.cf.<region>.hana.ondemand.com"
cf_org_id     = "<your-cf-org-guid>"   # required — find in BTP cockpit > Cloud Foundry > Org
cf_space_name = "dev"
cf_origin     = "<your-custom-idp-tenant>-platform"     # first segment of custom_idp + "-platform"
```

> Set `cf_origin` to match your IDP:
> - Custom IDP: `"<tenant>-platform"` (e.g. `"techrig-platform"`)
> - Default SAP ID Service: `"sap.ids"`

You can disable individual services and subscriptions by uncommenting the relevant flags:

```hcl
#enable_service_setup__ai_core                   = false
#enable_service_setup__hana_cloud                = false
#enable_service_setup__objectstore               = false
#enable_service_setup__xsuaa                     = false
#enable_service_setup__destination               = false
#enable_service_setup__html5_apps_repo           = false
#enable_app_subscription_setup__ai_launchpad     = false
#enable_app_subscription_setup__sap_launchpad    = false
#enable_app_subscription_setup__hana_cloud_tools = false
```

### Step 3 — Initialize and apply

```bash
terraform init

terraform plan  -var-file="bidexisting.tfvars"

terraform apply -var-file="bidexisting.tfvars"
```

Verify in BTP cockpit that the entitlements and subscriptions have been created, and in the CF space that the AI Core and Object Store service instances are present.

With this you have completed the quick account setup as described in the Discovery Center Mission - [AI-Powered Procurement Bidding Evaluation](https://discovery-center.cloud.sap/index.html#/missiondetail/4327/).

## Cleanup

To remove all provisioned resources:

```bash
terraform destroy -var-file="bidexisting.tfvars"
```

> **Note:** This only removes resources managed by this Terraform configuration (entitlements, subscriptions, CF service instances). The existing subaccount, CF org, and dev space are **not** destroyed.

## Outputs

| Output | Description |
|---|---|
| `subaccount_id` | Existing BTP subaccount ID |
| `cf_space_id` | Existing CF dev space ID |
| `ai_launchpad_subscription_url` | SAP AI Launchpad URL |
| `sap_launchpad_subscription_url` | SAP Build Work Zone URL |
| `hana_cloud_tools_subscription_url` | SAP HANA Cloud Tools URL |
| `ai_core_instance_id` | SAP AI Core CF service instance ID |
| `ai_core_service_key_id` | SAP AI Core service key binding ID |
| `objectstore_instance_id` | SAP Object Store CF service instance ID |
