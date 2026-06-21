output "rule_ids" {
  description = "Map of logical rule name to the created auto-moderation rule snowflake ID."
  value = merge(
    { for r in discord_auto_moderation_rule.keyword : "keyword" => r.id },
    { for r in discord_auto_moderation_rule.preset : "preset" => r.id },
    { for r in discord_auto_moderation_rule.spam : "spam" => r.id },
    { for r in discord_auto_moderation_rule.mention_spam : "mention_spam" => r.id },
    { for k, r in discord_auto_moderation_rule.custom : k => r.id },
  )
}
