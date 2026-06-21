terraform {
  required_providers {
    discord = {
      source  = "alpaca744/discord"
      version = ">= 0.1.0, < 1.0.0"
    }
  }
}

provider "discord" {
  # bot_token via DISCORD_BOT_TOKEN
}

variable "guild_id" {
  type        = string
  description = "Target guild. The @everyone role id equals the guild id."
}

module "server" {
  source = "../../"

  guild_id = var.guild_id

  roles = {
    admin = {
      color       = 15158332 # red
      hoist       = true
      permissions = ["ADMINISTRATOR"]
    }
    moderator = {
      color       = 3447003 # blurple
      hoist       = true
      mentionable = true
      permissions = ["KICK_MEMBERS", "MANAGE_MESSAGES", "MODERATE_MEMBERS"]
    }
    member = {
      permissions = ["VIEW_CHANNEL", "SEND_MESSAGES", "CONNECT", "SPEAK"]
    }
  }

  categories = {
    info  = { name = "Information", position = 0 }
    text  = { name = "Text Channels", position = 1 }
    voice = { name = "Voice Channels", position = 2 }
  }

  channels = {
    announcements = {
      name     = "announcements"
      type     = 5 # announcement
      category = "info"
      topic    = "Server news"
      overwrites = {
        # Only moderators may post; everyone else read-only.
        everyone_readonly = {
          overwrite_id = var.guild_id # @everyone
          deny         = ["SEND_MESSAGES"]
        }
        mods_post = {
          role  = "moderator" # resolved to the created role id
          allow = ["SEND_MESSAGES"]
        }
      }
    }
    general = { category = "text" }
    lounge = {
      type       = 2 # voice
      category   = "voice"
      user_limit = 10
    }
  }

  moderation = {
    keyword_filter  = ["badword1", "badword2"]
    preset_lists    = [1, 3] # PROFANITY + SLURS
    spam_protection = true
    mention_limit   = 5
  }
}

output "role_ids" {
  value = module.server.role_ids
}

output "channel_ids" {
  value = module.server.channel_ids
}
