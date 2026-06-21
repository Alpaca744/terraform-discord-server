terraform {
  required_providers {
    discord = {
      source  = "alpaca744/discord"
      version = ">= 0.1.0"
    }
  }
}

provider "discord" {
  # Reads the bot token from DISCORD_BOT_TOKEN if not set here.
}

variable "guild_id" {
  type = string
}

module "server" {
  source = "../../"

  guild_id = var.guild_id

  roles = {
    member = {
      permissions = ["VIEW_CHANNEL", "SEND_MESSAGES"]
    }
  }

  categories = {
    text = { name = "Text Channels" }
  }

  channels = {
    general = { category = "text" }
  }
}

output "channel_ids" {
  value = module.server.channel_ids
}
