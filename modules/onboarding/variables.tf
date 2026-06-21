variable "guild_id" {
  type        = string
  description = "Snowflake ID of the (community) guild to configure."
}

variable "welcome_screen" {
  type = object({
    enabled     = optional(bool, true)
    description = optional(string)
    channels = optional(list(object({
      channel_id  = string
      description = string
      emoji_id    = optional(string)
      emoji_name  = optional(string)
    })), [])
  })
  description = "Welcome screen configuration. null = not managed. Up to 5 channels are shown."
  default     = null

  validation {
    condition     = var.welcome_screen == null ? true : length(var.welcome_screen.channels) <= 5
    error_message = "welcome_screen.channels accepts at most 5 channels."
  }
}

variable "onboarding" {
  type = object({
    enabled             = optional(bool, true)
    mode                = optional(number, 0)
    default_channel_ids = optional(set(string), [])
    prompts             = optional(any, [])
  })
  description = <<-EOT
    Onboarding configuration. null = not managed.

    - `mode`    : 0 ONBOARDING_DEFAULT, 1 ONBOARDING_ADVANCED.
    - `prompts` : list of prompt objects; encoded to JSON for the provider.
      See the `discord_guild_onboarding` docs for the prompt/option shape.
  EOT
  default     = null
}
