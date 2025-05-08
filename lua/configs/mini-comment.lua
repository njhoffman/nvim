-- local modes = config.mappings.textobject == config.mappings.comment_visual and { 'o' } or { 'x', 'o' }
-- H.map(modes, config.mappings.textobject, '<Cmd>lua MiniComment.textobject()<CR>', { desc = 'Comment textobject' })

local is_visual_selection_empty = function()
  if vim.fn.mode() == "V" then
    return false
  elseif vim.fn.mode() == "v" then
    local start_pos = vim.fn.getpos(".")
    local end_pos = vim.fn.getpos("v")
    return vim.deep_equal(start_pos, end_pos)
  else
    return false
  end
end

local mapper = require("mapper")
local map = function(modes, lhs, rhs, opts)
  lhs = type(lhs) == "table" and lhs or { lhs }
  for _, key in ipairs(lhs) do
    modes = type(modes) == "function" and modes(key)
      or type(modes) == "table" and modes
      or { modes }
    if type(key) == "string" and key ~= "" then
      for _, mode in ipairs(modes) do
        opts.desc = opts.desc
        mapper.map(mode, key, rhs, opts)
      end
    end
  end
end

local comment_visual = function()
  if is_visual_selection_empty() then
    return [[:<c-u>lua MiniComment.textobject()<CR>]]
  else
    return [[:<c-u>lua MiniComment.operator('visual')<cr>]]
  end
end

local setup_mappings = function(config)
  local lhs = config.mappings
  local op_rhs = function()
    return MiniComment.operator()
  end

  local textobject_modes = function(key)
    local vis_keys = type(lhs.comment_visual) == "string" and { lhs.comment_visual }
      or lhs.comment_visual
    local modes = { "x", "o" }
    -- for _, vis_key in ipairs(vis_keys) do
    --   if vis_key == key then
    --     modes = { "o" }
    --   end
    -- end
    return modes
  end
  -- lhs.textobject == lhs.comment_visual and { "o" } or { "x", "o" }
  map(
    textobject_modes,
    lhs.textobject,
    "<Cmd>lua MiniComment.textobject()<CR>",
    { desc = " comment textobject (mini)" }
  )
  map("n", lhs.comment, op_rhs, { expr = true, desc = " comment (mini)" })

  -- remap comment_visual for allowing textobject when empty selection
  map(
    "x",
    lhs.comment_visual,
    comment_visual,
    { desc = " comment selection (mini)", expr = true }
  )

  map("n", lhs.comment_line, function()
    return MiniComment.operator() .. "_"
  end, { expr = true, desc = " comment line (mini)" })
  -- Use `<Cmd>...<CR>` to have proper dot-repeat: https://github.com/neovim/neovim/issues/23406
end

local cfg = {
  mappings = {
    -- comment = { "-", "gc" }, -- gc
    comment = "",
    comment_line = "", -- gcc
    comment_visual = { "gc", "-" }, -- gc
    textobject = { "gc", "-", "c" },
  },

  options = {
    mapping_func = setup_mappings,
    -- Whether to ignore blank lines in actions and textobject
    ignore_blank_line = true,
    -- Whether to recognize as comment only lines without indent
    start_of_line = false,
    -- Whether to force single space inner padding for comment parts
    pad_comment_parts = true,
    -- Hook functions to be executed at certain stage of commenting
    custom_commentstring = function()
      return require("ts_context_commentstring.internal").calculate_commentstring()
        or vim.bo.commentstring
    end,
  },
  hooks = {
    -- Before successful commenting. Does nothing by default.
    pre = function() end,
    -- After successful commenting. Does nothing by default.
    post = function() end,
  },
}
-- 

-- package.json - gx when cursor is under an npm dependency, navigates to https://www.npmjs.com/package/[packageName]
-- 
-- package.json - gx when cursor is under an npm dependency, navigates to https://www.npmjs.com/package/[packageName]
-- plugins.lua - In packer.nvim's convention plugins.lua file, gx when cursor is under a plugin dependency, navigates to https://github.com/[user/org]/[repo]
-- *.tf - In a terraform file, gx when cursor is under a terraform resource definition navigates to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/[resourceName]
-- * - In any file, gx navigates to no-protocol-urls like google.com, docs.google.com, etc.
-- plugins.lua - In packer.nvim's convention plugins.lua file, gx when cursor is under a plugin dependency, navigates to https://github.com/[user/org]/[repo]
-- *.tf - In a terraform file, gx when cursor is under a terraform resource definition navigates to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/[resourceName]
-- * - In any file, gx navigates to no-protocol-urls like google.com, docs.google.com, etc.

require("mini.comment").setup(cfg)
