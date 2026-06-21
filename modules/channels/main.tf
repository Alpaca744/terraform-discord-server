resource "discord_channel" "category" {
  for_each = var.categories

  guild_id = var.guild_id
  name     = coalesce(each.value.name, each.key)
  type     = 4
  position = each.value.position
}

resource "discord_channel" "this" {
  for_each = var.channels

  guild_id            = var.guild_id
  name                = coalesce(each.value.name, each.key)
  type                = each.value.type
  parent_id           = each.value.category == null ? null : discord_channel.category[each.value.category].id
  topic               = each.value.topic
  nsfw                = each.value.nsfw
  position            = each.value.position
  bitrate             = each.value.bitrate
  user_limit          = each.value.user_limit
  rate_limit_per_user = each.value.rate_limit_per_user
}

locals {
  # Flatten {channel_key => {overwrite_key => overwrite}} into a single map
  # keyed by "channel_key/overwrite_key" for a stable for_each.
  overwrites = merge([
    for ck, cv in var.channels : {
      for ok, ov in cv.overwrites :
      "${ck}/${ok}" => {
        channel_key  = ck
        overwrite_id = ov.overwrite_id
        type         = ov.type
        allow        = ov.allow
        deny         = ov.deny
      }
    }
  ]...)
}

resource "discord_channel_permission_overwrite" "this" {
  for_each = local.overwrites

  channel_id   = discord_channel.this[each.value.channel_key].id
  overwrite_id = each.value.overwrite_id
  type         = each.value.type
  allow        = each.value.allow
  deny         = each.value.deny
}
