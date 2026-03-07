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

  provider = "claude-code",
  acp_providers = {
    ["claude-code"] = {
      command = "npx",
      args = { "@zed-industries/claude-code-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
        ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
      },
    },
  },
  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-sonnet-4-5-20250929",
      timeout = 30000, -- Timeout in milliseconds
      context_window = 200000,
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 20480,
      },
    },
  },
}

require("avante").setup(cfg)
