output "role_ids" {
  description = "Map of role key to the created Discord role snowflake ID."
  value       = { for k, r in discord_role.this : k => r.id }
}

output "roles" {
  description = "Full map of managed role resources, keyed by role key."
  value       = discord_role.this
}
