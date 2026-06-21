variable "guild_id" {
  type        = string
  description = "Snowflake ID of the guild this server baseline manages."
}

variable "roles" {
  type = map(object({
    name        = optional(string)
    color       = optional(number, 0)
    hoist       = optional(bool, false)
    mentionable = optional(bool, false)
    permissions = optional(set(string), [])
  }))
  description = "Roles to manage, keyed by a stable local name. Keys can be referenced from `channels[*].overwrites[*].role`. See modules/roles."
  default     = {}
}

variable "categories" {
  type = map(object({
    name     = optional(string)
    position = optional(number)
  }))
  description = "Category channels, keyed by a stable local name referenced from `channels[*].category`. See modules/channels."
  default     = {}
}

variable "channels" {
  type = map(object({
    name                = optional(string)
    type                = optional(number, 0)
    category            = optional(string)
    topic               = optional(string)
    nsfw                = optional(bool, false)
    position            = optional(number)
    bitrate             = optional(number)
    user_limit          = optional(number)
    rate_limit_per_user = optional(number)
    overwrites = optional(map(object({
      role         = optional(string)
      overwrite_id = optional(string)
      type         = optional(string, "role")
      allow        = optional(set(string), [])
      deny         = optional(set(string), [])
    })), {})
  }))
  description = <<-EOT
    Channels to manage. Same shape as modules/channels, except each overwrite may
    set `role` (a key from `var.roles`) instead of a raw `overwrite_id`; the root
    module resolves it to the created role's snowflake ID. Provide exactly one of
    `role` or `overwrite_id` per overwrite.
  EOT
  default     = {}

  validation {
    condition = alltrue([
      for c in values(var.channels) : alltrue([
        for o in values(c.overwrites) : (o.role == null) != (o.overwrite_id == null)
      ])
    ])
    error_message = "Each overwrite must set exactly one of `role` or `overwrite_id`."
  }
}

variable "moderation" {
  type = object({
    keyword_filter  = optional(set(string), [])
    regex_patterns  = optional(set(string), [])
    preset_lists    = optional(set(number), [])
    spam_protection = optional(bool, false)
    mention_limit   = optional(number)
    block_message   = optional(string, "This message was blocked by auto-moderation.")
    exempt_roles    = optional(set(string), [])
    exempt_channels = optional(set(string), [])
    rules           = optional(any, {})
  })
  description = "Auto-moderation configuration passed through to modules/moderation. Empty object = no rules."
  default     = {}
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
  description = "Welcome screen configuration (community guilds only). null = unmanaged. See modules/onboarding."
  default     = null
}

variable "onboarding" {
  type = object({
    enabled             = optional(bool, true)
    mode                = optional(number, 0)
    default_channel_ids = optional(set(string), [])
    prompts             = optional(any, [])
  })
  description = "Onboarding configuration (community guilds only). null = unmanaged. See modules/onboarding."
  default     = null
}
