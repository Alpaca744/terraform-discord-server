output "role_ids" {
  description = "Map of role key to created role snowflake ID."
  value       = module.roles.role_ids
}

output "category_ids" {
  description = "Map of category key to created category channel snowflake ID."
  value       = module.channels.category_ids
}

output "channel_ids" {
  description = "Map of channel key to created channel snowflake ID."
  value       = module.channels.channel_ids
}

output "moderation_rule_ids" {
  description = "Map of auto-moderation rule name to created rule snowflake ID."
  value       = module.moderation.rule_ids
}
