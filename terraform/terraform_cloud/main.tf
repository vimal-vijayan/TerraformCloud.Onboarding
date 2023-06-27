data "azurerm_subscription" "subscriptions" {
  for_each        = toset(local.subscriptions)
  subscription_id = each.value
}

data "tfe_organization" "org" {
  name = local.terraform_cloud.organization
}

data "tfe_project" "project" {
  organization = data.tfe_organization.org.name
  name         = local.terraform_cloud.project_name
}

resource "tfe_workspace" "workspaces" {
  for_each     = toset(local.subscriptions)
  name         = data.azurerm_subscription.subscriptions[each.value].display_name
  organization = data.tfe_organization.org.name
  project_id   = data.tfe_project.project.id
  # execution_mode        = "agent"
  # agent_pool_id         = data.tfe_agent_pool.agent_pool.id
  working_directory     = local.terraform_cloud.working_directory
  auto_apply            = true
  file_triggers_enabled = true
  queue_all_runs        = false
  trigger_patterns      = ["/config/${data.azurerm_subscription.subscriptions[each.value].display_name}/*.json"]

  vcs_repo {
    identifier         = local.terraform_cloud.project_url
    branch             = "main"
    oauth_token_id     = local.terraform_cloud.oauth_token_id
    ingress_submodules = true
  }
}


resource "tfe_variable" "subscription_id" {
  for_each     = toset(local.subscriptions)
  key          = "subscription_id"
  value        = data.azurerm_subscription.subscriptions[each.value].subscription_id
  category     = "terraform"
  workspace_id = tfe_workspace.workspaces[each.value].id
  description  = "Subscription ID"
}

resource "tfe_variable" "subscription_name" {
  for_each     = toset(local.subscriptions)
  key          = "subscription_name"
  value        = data.azurerm_subscription.subscriptions[each.value].display_name
  category     = "terraform"
  workspace_id = tfe_workspace.workspaces[each.value].id
  description  = "Subscription Name"
}

resource "tfe_variable" "arm_subscription_id" {
  for_each     = toset(local.subscriptions)
  key          = "ARM_SUBSCRIPTION_ID"
  value        = data.azurerm_subscription.subscriptions[each.value].subscription_id
  category     = "env"
  workspace_id = tfe_workspace.workspaces[each.value].id
  description  = "Subscription ID"
}

resource "tfe_workspace_run" "ws_run_corp_parent" {
  for_each     = toset(local.subscriptions)
  workspace_id = tfe_workspace.workspaces[each.key].id
  # depends_on   = [tfe_variable.subscription_name, tfe_variable.subscription_id, tfe_variable.arm_subscription_id]

  apply {
    manual_confirm = false
    wait_for_run   = false
  }

  destroy {
    manual_confirm    = false
    wait_for_run      = true
    retry_attempts    = 3
    retry_backoff_min = 10
  }
}

