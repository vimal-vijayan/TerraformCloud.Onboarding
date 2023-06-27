locals {

  terraform_cloud = {
    agent_pool_name   = "tfc-agents-prod"
    organization      = "optimus"
    project_name      = "resource-groups"
    oauth_token_id    = "ot-y11Wnf4U6bpBrcfA"
    project_url       = "vimal-vijayan/TerraformCloud.Onboarding"
    working_directory = "terraform/resource_groups"
  }

  yamlconfigs          = [for file in fileset("../../configs", "/**/*.yaml") : yamldecode(file("../../configs/${file}"))]
  resource_groups      = flatten([for k, v in local.yamlconfigs : [for a, b in v.resource_groups : merge({ sub = v.subscription_id }, b)]])
  subscriptions        = distinct([for k, v in local.resource_groups : v.sub])
  resource_groups_maps = { for k, v in local.resource_groups : "${v.sub}_${v.location}_${v.name}_${v.environment} " => v }
}
