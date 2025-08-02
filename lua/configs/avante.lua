local cfg = {
  -- add any opts here
  -- for example
  suggestion = {
    debounce = 600,
    throttle = 2000,
  },

  behaviour = {
    auto_set_keymaps = false,
  },

  provider = "claude",
  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-sonnet-4-20250514",
      timeout = 30000, -- Timeout in milliseconds
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 20480,
      },
    },
  },
}

require("avante").setup(cfg)
