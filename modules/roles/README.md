# terraform-discord-server // modules/roles

Manage a set of Discord guild roles from a single keyed map.

## Usage

```hcl
module "roles" {
  source   = "alpaca744/server/discord//modules/roles"
  guild_id = "123456789012345678"

  roles = {
    admin = {
      color       = 15158332 # red
      hoist       = true
      permissions = ["ADMINISTRATOR"]
    }
    moderator = {
      color       = 3447003 # blurple
      hoist       = true
      permissions = ["KICK_MEMBERS", "MANAGE_MESSAGES", "MODERATE_MEMBERS"]
    }
    member = {
      permissions = ["VIEW_CHANNEL", "SEND_MESSAGES", "CONNECT", "SPEAK"]
    }
  }
}
```

The map **key** (`admin`, `moderator`, …) is the stable identifier you reference
elsewhere (e.g. permission overwrites). It also becomes the role name unless you
set `name` explicitly.

<!-- BEGIN_TF_DOCS -->
<!-- Run `terraform-docs markdown table --output-file README.md --output-mode inject .` to populate. -->
<!-- END_TF_DOCS -->
