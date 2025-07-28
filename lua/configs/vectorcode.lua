-- Default configuration
require("vectorcode").setup({
  --   cli_cmds = {
  --     vectorcode = "vectorcode",
  --   },
  --   ---@type VectorCode.RegisterOpts
  --   async_opts = {
  --     debounce = 10,
  --     events = { "BufWritePost", "InsertEnter", "BufReadPost" },
  --     exclude_this = true,
  --     n_query = 1,
  --     notify = false,
  --     query_cb = require("vectorcode.utils").make_surrounding_lines_cb(-1),
  --     run_on_register = false,
  --   },
  -- async_backend = "default", -- default/lsp
  async_backend = "lsp", -- default/lsp
  --   exclude_this = true,
  --   n_query = 1,
  --   notify = true,
  --   timeout_ms = 5000,
  on_setup = {
    update = true, -- set to true to enable update when `setup` is called.
    lsp = false,
  },
  --   ---@type VectorCode.RegisterOpts
  --   sync_log_env_var = false,
})

-- uv tool install chromadb==0.6.3. And run it like this uv tool run --from chromadb chroma run

-- wget https://gist.githubusercontent.com/tazarov/9c46966de0b32a4962dcc79dce8b2646/raw/7cf8c471f33fba8a51d6f808f9b1af6ca1b0923c/chroma-docker.service \
--   -O /etc/systemd/system/chroma.service

-- Also you can start a systemd service like this:

-- [Unit]
-- Description=ChromaDB Server
-- After=network.target

-- [Service]
-- Type=simple
-- ExecStart=/home/youruser/.local/bin/uv tool run --from chromadb chroma run
-- Restart=on-failure
-- WorkingDirectory=/home/youruser/

-- [Install]
-- WantedBy=multi-user.target
