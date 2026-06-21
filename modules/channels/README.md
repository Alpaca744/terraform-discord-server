# terraform-discord-server // modules/channels

Manage a category → channel tree, with optional per-channel permission overwrites.

## Usage

```hcl
module "channels" {
  source   = "alpaca744/server/discord//modules/channels"
  guild_id = "123456789012345678"

  categories = {
    info = { name = "Information", position = 0 }
    text = { name = "Text Channels", position = 1 }
  }

  channels = {
    rules = {
      name     = "rules"
      category = "info"
      topic    = "Read before posting"
      overwrites = {
        # Lock the channel down for @everyone (the @everyone role id == guild id).
        lockdown = {
          overwrite_id = "123456789012345678"
          deny         = ["SEND_MESSAGES"]
        }
      }
    }
    general = {
      category = "text"
    }
    lounge = {
      type       = 2 # voice
      category   = "text"
      user_limit = 10
    }
  }
}
```

`categories[*]` keys are referenced by `channels[*].category`. Overwrite
`overwrite_id` must be a resolved snowflake — when composing with the
[`roles`](../roles) module, pass `module.roles.role_ids["<key>"]`. The root
module does this resolution for you via the `overwrites[*].role` shortcut.

<!-- BEGIN_TF_DOCS -->
<!-- Run `terraform-docs markdown table --output-file README.md --output-mode inject .` to populate. -->
<!-- END_TF_DOCS -->
