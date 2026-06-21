resource "discord_guild_welcome_screen" "this" {
  count = var.welcome_screen == null ? 0 : 1

  guild_id         = var.guild_id
  enabled          = var.welcome_screen.enabled
  description      = var.welcome_screen.description
  welcome_channels = var.welcome_screen.channels
}

resource "discord_guild_onboarding" "this" {
  count = var.onboarding == null ? 0 : 1

  guild_id            = var.guild_id
  enabled             = var.onboarding.enabled
  mode                = var.onboarding.mode
  default_channel_ids = var.onboarding.default_channel_ids
  prompts             = jsonencode(var.onboarding.prompts)
}
