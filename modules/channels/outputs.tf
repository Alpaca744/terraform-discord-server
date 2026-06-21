output "category_ids" {
  description = "Map of category key to the created category channel snowflake ID."
  value       = { for k, c in discord_channel.category : k => c.id }
}

output "channel_ids" {
  description = "Map of channel key to the created channel snowflake ID."
  value       = { for k, c in discord_channel.this : k => c.id }
}
