# terraform-discord-server // modules/moderation

Opinionated presets over `discord_auto_moderation_rule`, plus an escape hatch for
anything custom. Each preset rule is created only when its input is set.

## Usage

```hcl
module "moderation" {
  source   = "alpaca744/server/discord//modules/moderation"
  guild_id = "123456789012345678"

  keyword_filter  = ["badword1", "badword2"]
  preset_lists    = [1, 3] # PROFANITY + SLURS
  spam_protection = true
  mention_limit   = 5

  exempt_roles = [module.roles.role_ids["moderator"]]
}
```

| Input | Trigger | Created when |
|-------|---------|--------------|
| `keyword_filter` / `regex_patterns` | KEYWORD | either is non-empty |
| `preset_lists` | KEYWORD_PRESET | non-empty |
| `spam_protection` | SPAM | `true` |
| `mention_limit` | MENTION_SPAM | not `null` |
| `rules` | any | one rule per map entry |

Use `rules` for timeouts, alert channels, member-profile triggers, or any
configuration the presets do not express.

<!-- BEGIN_TF_DOCS -->
<!-- Run `terraform-docs markdown table --output-file README.md --output-mode inject .` to populate. -->
<!-- END_TF_DOCS -->
