-- LSP diagnostics as a resource

-- @{mcp} What files are in the current directory?
-- @{neovim} Read the main.lua file    # All tools from the neovim server will be added as function tools
-- @{github} Create an issue
-- @{fetch} Get this webpage

-- @{neovim__read_file} Show me the config file
-- @{fetch__fetch} Get this webpage content
-- @{github__create_issue} File a bug report

local mcphub = require("mcphub")

local auto_approve = function(params)
  -- Auto-approve GitHub issue reading
  if params.server_name == "github" and params.tool_name == "get_issue" then
    return true -- Auto approve
  end

  -- Block access to private repos
  if params.arguments.repo == "private" then
    return "You can't access my private repo" -- Error message
  end

  -- Auto-approve safe file operations in current project
  if params.tool_name == "read_file" then
    local path = params.arguments.path or ""
    if path:match("^" .. vim.fn.getcwd()) then
      return true -- Auto approve
    end
  end

  -- Check if tool is configured for auto-approval in servers.json
  if params.is_auto_approved_in_server then
    return true -- Respect servers.json configuration
  end

  return false -- Show confirmation prompt
end

local cfg = {
  --- `mcp-hub` binary related options-------------------
  config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to MCP Servers config file (will create if not exists)
  port = 37373, -- The port `mcp-hub` server listens to
  shutdown_delay = 60 * 10 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 10 minutes)
  use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")
  mcp_request_timeout = 60000, --Max time allowed for a MCP tool or resource to execute in milliseconds, set longer for long running tasks

  ---Chat-plugin related options-----------------
  auto_approve = false, -- Auto approve mcp tool calls
  auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
  extensions = {
    avante = {
      make_slash_commands = true, -- make /slash commands from MCP server prompts
    },
  },
  --- Plugin specific options-------------------
  native_servers = {}, -- add your custom lua native servers here
  builtin_tools = {
    edit_file = {
      parser = {
        track_issues = true,
        extract_inline_content = true,
      },
      locator = {
        fuzzy_threshold = 0.8,
        enable_fuzzy_matching = true,
      },
      ui = {
        go_to_origin_on_complete = true,
        keybindings = {
          accept = ".",
          reject = ",",
          next = "n",
          prev = "p",
          accept_all = "ga",
          reject_all = "gr",
        },
      },
    },
  },
  ui = {
    window = {
      width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
      relative = "editor",
      zindex = 50,
      border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
    },
    wo = { -- window-scoped options (vim.wo)
      winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
    },
  },
  -- on_ready = function(hub)
  --   -- Called when hub is ready
  -- end,
  -- on_error = function(err) -- Called on errors
  -- end,
  log = {
    level = vim.log.levels.WARN,
    to_file = false,
    file_path = nil,
    prefix = "MCPHub",
  },
}
mcphub.setup(cfg)

mcphub.add_resource("neovim", {
  name = "Diagnostics: Current File",
  description = "Get diagnostics for current file",
  uri = "neovim://diagnostics/current",
  mimeType = "text/plain",
  handler = function(req, res)
    -- Get editor context
    local buf_info = req.editor_info.last_active
    if not buf_info then
      return res:error("No active buffer")
    end

    -- Use LSP features
    local diagnostics = vim.diagnostic.get(buf_info.bufnr)

    -- Format response
    local text = string.format("Diagnostics for: %s\n%s\n", buf_info.filename, string.rep("-", 40))

    for _, diag in ipairs(diagnostics) do
      local severity = vim.diagnostic.severity[diag.severity]
      text = text .. string.format("\n%s: Line %d - %s\n", severity, diag.lnum + 1, diag.message)
    end

    return res:text(text):send()
  end,
})
