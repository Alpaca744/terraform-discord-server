variable "guild_id" {
  type        = string
  description = "Snowflake ID of the guild to manage channels in."
}

variable "categories" {
  type = map(object({
    name     = optional(string)
    position = optional(number)
  }))
  description = <<-EOT
    Category channels (type 4), keyed by a stable local name. The key is used as
    the category name unless `name` is set, and is what `channels[*].category`
    references.
  EOT
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
      overwrite_id = string
      type         = optional(string, "role")
      allow        = optional(set(string), [])
      deny         = optional(set(string), [])
    })), {})
  }))
  description = <<-EOT
    Channels to manage, keyed by a stable local name (also the channel name
    unless `name` is set).

    - `type`     : 0 text, 2 voice, 5 announcement, 13 stage, 15 forum.
    - `category` : key into `var.categories` to nest the channel; null = top level.
    - `overwrites` : per-channel permission overwrites, keyed by a local name.
        `overwrite_id` is the snowflake of a role or member; `type` is
        `"role"` (default) or `"member"`.
  EOT
  default     = {}

  validation {
    condition = alltrue([
      for c in values(var.channels) :
      alltrue([for o in values(c.overwrites) : contains(["role", "member"], o.type)])
    ])
    error_message = "Each overwrite `type` must be either \"role\" or \"member\"."
  }
}
