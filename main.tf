module "roles" {
  source = "./modules/roles"

  guild_id = var.guild_id
  roles    = var.roles
}

locals {
  # Resolve each overwrite's `role` key to the created role snowflake, then drop
  # `role` so the shape matches what modules/channels expects.
  channels = {
    for ck, cv in var.channels : ck => merge(cv, {
      overwrites = {
        for ok, ov in cv.overwrites : ok => {
          overwrite_id = ov.role != null ? module.roles.role_ids[ov.role] : ov.overwrite_id
          type         = ov.type
          allow        = ov.allow
          deny         = ov.deny
        }
      }
    })
  }
}

module "channels" {
  source = "./modules/channels"

  guild_id   = var.guild_id
  categories = var.categories
  channels   = local.channels
}

module "moderation" {
  source = "./modules/moderation"

  guild_id        = var.guild_id
  keyword_filter  = var.moderation.keyword_filter
  regex_patterns  = var.moderation.regex_patterns
  preset_lists    = var.moderation.preset_lists
  spam_protection = var.moderation.spam_protection
  mention_limit   = var.moderation.mention_limit
  block_message   = var.moderation.block_message
  exempt_roles    = var.moderation.exempt_roles
  exempt_channels = var.moderation.exempt_channels
  rules           = var.moderation.rules
}

module "onboarding" {
  source = "./modules/onboarding"

  guild_id       = var.guild_id
  welcome_screen = var.welcome_screen
  onboarding     = var.onboarding
}
