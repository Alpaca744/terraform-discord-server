# terraform-discord-server // modules/onboarding

Configure a community guild's welcome screen and member onboarding flow.

> Both features require the guild to have the **COMMUNITY** feature enabled.

## Usage

```hcl
module "onboarding" {
  source   = "alpaca744/server/discord//modules/onboarding"
  guild_id = "123456789012345678"

  welcome_screen = {
    description = "Welcome to our community!"
    channels = [
      { channel_id = "111111111111111111", description = "Read the rules", emoji_name = "📜" },
      { channel_id = "222222222222222222", description = "Introduce yourself", emoji_name = "👋" },
    ]
  }

  onboarding = {
    default_channel_ids = ["111111111111111111"]
    prompts = [
      {
        id            = "0"
        type          = 0
        title         = "What are you interested in?"
        single_select = false
        required      = false
        in_onboarding = true
        options = [
          { id = "0", title = "Gaming", channel_ids = [], role_ids = ["333333333333333333"] },
        ]
      },
    ]
  }
}
```

Set `welcome_screen` or `onboarding` to `null` (the default) to leave that
feature unmanaged.

<!-- BEGIN_TF_DOCS -->
<!-- Run `terraform-docs markdown table --output-file README.md --output-mode inject .` to populate. -->
<!-- END_TF_DOCS -->
