resource "discord_role" "this" {
  for_each = var.roles

  guild_id    = var.guild_id
  name        = coalesce(each.value.name, each.key)
  color       = each.value.color
  hoist       = each.value.hoist
  mentionable = each.value.mentionable
  permissions = each.value.permissions
}
