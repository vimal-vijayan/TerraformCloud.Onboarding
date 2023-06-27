locals {
  yamlconfigs     = [for file in fileset("../../configs", "/**/*.yaml") : yamldecode(file("../../configs/${file}"))]
  resource_groups = flatten([for k, v in local.yamlconfigs : [for a, b in v.resource_groups : merge({ sub = v.subscription_id }, b)]])
  # subscriptions        = distinct([for k, v in local.configs : v.subscription_id])
  resource_groups_maps = { for k, v in local.resource_groups : "${v.location}-${v.name}-${v.environment}-${v.sub}" => v if v.sub == var.subscription_id }
  # config_maps          = { for k, v in local.configs : "${v.resource_group_name}_${v.subscription_id}" => v if v.subscription_id == var.subscription_id }
}
