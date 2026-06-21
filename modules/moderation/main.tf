locals {
  has_keyword = length(var.keyword_filter) > 0 || length(var.regex_patterns) > 0
}

resource "discord_auto_moderation_rule" "keyword" {
  count = local.has_keyword ? 1 : 0

  guild_id     = var.guild_id
  name         = "Blocked keywords"
  event_type   = 1 # MESSAGE_SEND
  trigger_type = 1 # KEYWORD
  enabled      = true

  trigger_metadata = {
    keyword_filter = var.keyword_filter
    regex_patterns = var.regex_patterns
  }

  actions = [{
    type           = 1 # BLOCK_MESSAGE
    custom_message = var.block_message
  }]

  exempt_roles    = var.exempt_roles
  exempt_channels = var.exempt_channels
}

resource "discord_auto_moderation_rule" "preset" {
  count = length(var.preset_lists) > 0 ? 1 : 0

  guild_id     = var.guild_id
  name         = "Blocked word presets"
  event_type   = 1 # MESSAGE_SEND
  trigger_type = 4 # KEYWORD_PRESET
  enabled      = true

  trigger_metadata = {
    presets = var.preset_lists
  }

  actions = [{
    type           = 1 # BLOCK_MESSAGE
    custom_message = var.block_message
  }]

  exempt_roles    = var.exempt_roles
  exempt_channels = var.exempt_channels
}

resource "discord_auto_moderation_rule" "spam" {
  count = var.spam_protection ? 1 : 0

  guild_id     = var.guild_id
  name         = "Spam protection"
  event_type   = 1 # MESSAGE_SEND
  trigger_type = 3 # SPAM
  enabled      = true

  actions = [{ type = 1 }] # BLOCK_MESSAGE

  exempt_roles    = var.exempt_roles
  exempt_channels = var.exempt_channels
}

resource "discord_auto_moderation_rule" "mention_spam" {
  count = var.mention_limit == null ? 0 : 1

  guild_id     = var.guild_id
  name         = "Mention spam"
  event_type   = 1 # MESSAGE_SEND
  trigger_type = 5 # MENTION_SPAM
  enabled      = true

  trigger_metadata = {
    mention_total_limit = var.mention_limit
  }

  actions = [{ type = 1 }] # BLOCK_MESSAGE

  exempt_roles    = var.exempt_roles
  exempt_channels = var.exempt_channels
}

resource "discord_auto_moderation_rule" "custom" {
  for_each = var.rules

  guild_id     = var.guild_id
  name         = coalesce(each.value.name, each.key)
  event_type   = each.value.event_type
  trigger_type = each.value.trigger_type
  enabled      = each.value.enabled

  trigger_metadata = each.value.trigger_metadata
  actions          = each.value.actions

  exempt_roles    = each.value.exempt_roles
  exempt_channels = each.value.exempt_channels
}
