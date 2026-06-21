variable "guild_id" {
  type        = string
  description = "Snowflake ID of the guild to manage roles in."
}

variable "roles" {
  type = map(object({
    name        = optional(string)
    color       = optional(number, 0)
    hoist       = optional(bool, false)
    mentionable = optional(bool, false)
    permissions = optional(set(string), [])
  }))
  description = <<-EOT
    Roles to manage, keyed by a stable local name. The map key is used as the
    role name unless `name` is set, so downstream modules can reference a role
    by key without depending on its rendered name.

    - `color`       : integer RGB value (0 = inherit).
    - `hoist`       : show the role separately in the member list.
    - `mentionable` : allow anyone to @mention the role.
    - `permissions` : set of Discord permission names (e.g. `VIEW_CHANNEL`).

    Role positions are assigned by Discord and are not managed here.
  EOT
  default     = {}
}
