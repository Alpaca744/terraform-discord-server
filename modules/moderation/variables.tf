variable "guild_id" {
  type        = string
  description = "Snowflake ID of the guild to manage auto-moderation rules in."
}

# ---------------------------------------------------------------------------
# Preset rules — each is created only when its input is non-empty / enabled.
# ---------------------------------------------------------------------------

variable "keyword_filter" {
  type        = set(string)
  description = "Substrings that trigger a BLOCK_MESSAGE rule (trigger type KEYWORD). Empty = rule not created."
  default     = []
}

variable "regex_patterns" {
  type        = set(string)
  description = "Regular expressions added to the keyword rule (trigger type KEYWORD). Requires `keyword_filter` or stands alone if set."
  default     = []
}

variable "preset_lists" {
  type        = set(number)
  description = "Discord preset word lists to block (KEYWORD_PRESET): 1 PROFANITY, 2 SEXUAL_CONTENT, 3 SLURS. Empty = rule not created."
  default     = []

  validation {
    condition     = alltrue([for p in var.preset_lists : contains([1, 2, 3], p)])
    error_message = "preset_lists values must be one of 1 (PROFANITY), 2 (SEXUAL_CONTENT), 3 (SLURS)."
  }
}

variable "spam_protection" {
  type        = bool
  description = "Enable Discord's built-in spam content detection (trigger type SPAM)."
  default     = false
}

variable "mention_limit" {
  type        = number
  description = "Maximum mentions allowed per message before BLOCK_MESSAGE (trigger type MENTION_SPAM). null = rule not created."
  default     = null
}

variable "block_message" {
  type        = string
  description = "Custom message shown to users when a preset rule blocks their message."
  default     = "This message was blocked by auto-moderation."
}

variable "exempt_roles" {
  type        = set(string)
  description = "Role snowflake IDs exempt from all preset rules (max 20)."
  default     = []
}

variable "exempt_channels" {
  type        = set(string)
  description = "Channel snowflake IDs exempt from all preset rules (max 50)."
  default     = []
}

# ---------------------------------------------------------------------------
# Escape hatch — fully-specified custom rules passed straight to the provider.
# ---------------------------------------------------------------------------

variable "rules" {
  type = map(object({
    name         = optional(string)
    event_type   = optional(number, 1)
    trigger_type = number
    enabled      = optional(bool, true)
    trigger_metadata = optional(object({
      allow_list                      = optional(set(string))
      keyword_filter                  = optional(set(string))
      regex_patterns                  = optional(set(string))
      presets                         = optional(set(number))
      mention_total_limit             = optional(number)
      mention_raid_protection_enabled = optional(bool)
    }))
    actions = list(object({
      type             = number
      channel_id       = optional(string)
      custom_message   = optional(string)
      duration_seconds = optional(number)
    }))
    exempt_roles    = optional(set(string), [])
    exempt_channels = optional(set(string), [])
  }))
  description = "Custom auto-moderation rules keyed by a local name, for anything the presets above do not cover. Mirrors the `discord_auto_moderation_rule` schema."
  default     = {}
}
