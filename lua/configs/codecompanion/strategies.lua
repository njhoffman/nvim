local adapters = require("configs.codecompanion.adapters")

local strategies = {
  chat = {
    slash_commands = adapters.get_slash_commands(),
    adapters = "openrouter",
    keymaps = {
      submit = {
        modes = { n = "<CR>" },
        description = "Submit",
        callback = function(chat)
          local config = adapters.read_config()
          chat:apply_model(config.current_model)
          chat:submit()
        end,
      },
    },
    roles = {
      llm = function(_adapter)
        return "CodeCompanion (" .. _adapter.model.name .. ")"
      end,
    },
  },
  inline = {
    adapters = "openrouter",
  },
}
