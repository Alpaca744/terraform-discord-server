# terraform-discord-server

Opinionated Terraform module for standing up a Discord server baseline — roles,
a category/channel tree with permission overwrites, auto-moderation, and the
member onboarding flow — from a single declarative input. Built on the
[`alpaca744/discord`](https://registry.terraform.io/providers/Alpaca744/discord/latest)
provider.

## Modules

The root module composes four submodules. Each is independently usable and
publishable to the Terraform Registry via the `//modules/<name>` source syntax:

| Submodule | Manages |
|-----------|---------|
| [`modules/roles`](modules/roles) | `discord_role` from a keyed map |
| [`modules/channels`](modules/channels) | categories, channels, and `channel_permission_overwrite` |
| [`modules/moderation`](modules/moderation) | `discord_auto_moderation_rule` presets + escape hatch |
| [`modules/onboarding`](modules/onboarding) | `discord_guild_welcome_screen` + `discord_guild_onboarding` |

## Usage

```hcl
provider "discord" {
  # bot_token via the DISCORD_BOT_TOKEN environment variable
}

module "server" {
  source  = "alpaca744/server/discord"
  version = "~> 0.1"

  guild_id = "123456789012345678"

  roles = {
    moderator = { hoist = true, permissions = ["KICK_MEMBERS", "MANAGE_MESSAGES"] }
    member    = { permissions = ["VIEW_CHANNEL", "SEND_MESSAGES"] }
  }

  categories = {
    info = { name = "Information" }
  }

  channels = {
    announcements = {
      type     = 5
      category = "info"
      overwrites = {
        everyone_readonly = { overwrite_id = "123456789012345678", deny = ["SEND_MESSAGES"] }
        mods_post         = { role = "moderator", allow = ["SEND_MESSAGES"] }
      }
    }
  }

  moderation = {
    spam_protection = true
    mention_limit   = 5
  }
}
```

### Referencing roles in overwrites

In the root module, a channel permission overwrite can point at a role by its
**key** rather than a snowflake:

```hcl
overwrites = {
  mods_post = { role = "moderator", allow = ["SEND_MESSAGES"] }
}
```

The module resolves `role` to the created role's ID and orders the apply
correctly. Use `overwrite_id` directly for `@everyone` (whose ID equals the
guild ID) or for member-specific overwrites. Provide exactly one of the two.

## Requirements

- Terraform >= 1.3 (uses optional object attributes)
- A Discord **bot token** with the permissions for the resources you manage
  (`MANAGE_ROLES`, `MANAGE_CHANNELS`, `MANAGE_GUILD`, …). Welcome screen and
  onboarding require the guild to have the **COMMUNITY** feature enabled.

## Examples

- [`examples/minimal`](examples/minimal) — a few roles and channels.
- [`examples/complete`](examples/complete) — roles, locked-down announcement
  channel, voice channels, and moderation presets.

## Publishing

To publish to the Terraform Registry, this repo must be named
`terraform-discord-server` on GitHub under the `Alpaca744` namespace, tagged with
a semver release (e.g. `v0.1.0`). Submodules are then available at
`alpaca744/server/discord//modules/roles`, etc.

## License

MIT — see [LICENSE](LICENSE).
