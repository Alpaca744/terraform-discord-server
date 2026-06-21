output "welcome_screen_managed" {
  description = "Whether the welcome screen is managed by this module."
  value       = length(discord_guild_welcome_screen.this) > 0
}

output "onboarding_managed" {
  description = "Whether onboarding is managed by this module."
  value       = length(discord_guild_onboarding.this) > 0
}
