# AI-Powered Procurement Bidding Evaluation — SAP BTP Account Setup

This repository contains Terraform configurations for setting up your SAP BTP account for the Discovery Center Mission [AI-Powered Procurement Bidding Evaluation](https://discovery-center.cloud.sap/index.html#/missiondetail/4327/).

Two setup paths are provided depending on whether you are starting from scratch or using an existing BTP subaccount.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

| Requirement | Notes |
|---|---|
| [Git](https://git-scm.com/downloads) | To clone this repository |
| [Terraform CLI](https://developer.hashicorp.com/terraform/install) | v1.3 or later recommended |
| [VS Code](https://code.visualstudio.com/) (optional) | Recommended editor with [HashiCorp Terraform extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) |
| SAP BTP Global Account | With admin access |
| SAP BTP credentials | Your BTP username and password |

## Get Started

Clone this repository and navigate into the setup folder:

```bash
git clone https://github.com/horsemanjackyliu/btpsetupterraform.git
cd btpsetupterraform
```

## Choose Your Setup Path

### Option A — New BTP Subaccount

Use this path if you want Terraform to **create a new BTP subaccount** and Cloud Foundry environment from scratch.

→ Follow the instructions in [`bidnewsub/README.md`](bidnewsub/README.md)

### Option B — Existing BTP Subaccount

Use this path if you already have a **BTP subaccount with Cloud Foundry** provisioned and want to provision services into it.

→ Follow the instructions in [`bidexisting/README.md`](bidexisting/README.md)

## Repository Structure

```
.
├── bidnewsub/          # Option A: Creates a new subaccount + CF environment
│   ├── step1/          #   Step 1 — BTP subaccount, CF org, entitlements, subscriptions
│   └── step2/          #   Step 2 — CF space, space roles, AI Core service instance
│
└── bidexisting/        # Option B: Targets an existing subaccount + CF space
```

## Resources

- [SAP BTP Terraform Provider documentation](https://registry.terraform.io/providers/SAP/btp/latest/docs)
- [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md)
- [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)
- [Discovery Center Mission 4327](https://discovery-center.cloud.sap/index.html#/missiondetail/4327/)
