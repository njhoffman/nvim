local provider_project = require('plugs.config.feline.provider-project')
local provider_git = require('plugs.config.feline.provider-git')
local provider_lsp_references = require('plugs.config.feline.provider-lsp-references')
-- local provider_lsp_code_actions = require('plugs.config.feline.provider-lsp-code-actions')
local provider_helptags = require('plugs.config.feline.provider-helptags')

local M = {}

M.HelpTagsComponent = {
  enabled = function()
    return vim.bo.filetype == 'lua'
  end,
  provider = {
    name = 'helptags',
    update = { 'User' },
    opts = { pattern = 'StatusCountHelp' },
  },
  hl = provider_helptags.provider_hl,
  left_sep = {
    str = '',
    hl = {
      fg = 'NONE',
    },
  },
  right_sep = {
    str = '',
    hl = {
      fg = 'NONE',
    },
  },
}

-- M.LspCodeActionsComponent = {
--   enabled = function()
--     local ft_enabled = { 'lua', 'sh', 'typescript', 'javascript', 'go', 'python' }
--     return vim.tbl_contains(ft_enabled, vim.bo.filetype) and #vim.lsp.get_active_clients() > 0
--   end,
--   provider = {
--     name = 'lsp_code_actions',
--     update = { 'User' },
--     opts = {},
--   },
--   hl = provider_lsp_code_actions.hl,
--   left_sep = {
--     str = ' ',
--     hl = {
--       fg = 'NONE',
--     },
--   },
-- }

M.LspReferencesComponent = {
  enabled = function()
    local ft_enabled = { 'lua', 'sh', 'typescript', 'javascript', 'go', 'python' }
    return vim.tbl_contains(ft_enabled, vim.bo.filetype) and #vim.lsp.get_active_clients() > 0
  end,
  provider = {
    name = 'lsp_references',
    update = { 'User' },
    opts = {},
  },
  hl = provider_lsp_references.hl,
  left_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
    },
  },
  right_sep = {
    str = '',
    hl = {
      fg = 'NONE',
    },
  },
}

M.NeoComposerComponent = {
  enabled = true,
  provider = {
    name = 'neocomposer',
    update = { 'RecordingEnter', 'RecordingLeave' },
    opts = {},
  },
  hl = {
    fg = '#333344',
  },
  left_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
    },
  },
}

-- Display <e> 0x65
M.AsciiComponent = {
  hl = { fg = '#486088' },
  -- enabled = function()
  --   return vim.api.nvim_win_get_width(0) > 120
  -- end,
  provider = {
    name = 'ascii',
    update = { 'CursorMoved' },
  },
  left_sep = ' ',
  right_sep = ' ',
}

M.ProjectComponent = {
  enabled = true,
  provider = {
    name = 'project',
    opts = {},
    -- update = { 'WinClosed', 'BufDelete' }
  },
  { ' ' },
  hl = provider_project.hl,
  left_sep = provider_project.left_sep,
  { ' ' },
  right_sep = provider_project.right_sep,
}

M.GitBranchComponent = {
  provider = provider_git.git_branch,
  hl = {
    fg = '#56b6c2',
    bg = 'black',
    style = 'bold',
  },
  left_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
      bg = 'black',
    },
  },
  right_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
      bg = 'black',
    },
  },
}

M.GitDiffAddedComponent = {
  provider = provider_git.git_diff_added,
  hl = {
    fg = '#129A77',
    bg = 'black',
  },
}

M.GitDiffChangedComponent = {
  provider = provider_git.git_diff_changed,
  hl = {
    fg = '#6191f1',
    bg = 'black',
  },
}

M.GitDiffRemovedComponent = {
  provider = provider_git.git_diff_removed,
  hl = {
    fg = '#8F313A',
    bg = 'black',
  },
}

M.ScrollBarComponent = {
  provider = 'scroll_bar',
  left_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
      bg = 'black',
    },
  },
  hl = {
    fg = 'skyblue',
    style = 'bold',
  },
}

M.FiletypeComponent = {
  -- Enable if current window width is higher than 100
  enabled = function()
    return vim.api.nvim_win_get_width(0) > 120
  end,
  hl = { fg = '#988088' },
  provider = {
    name = 'file_type',
    opts = { case = 'lowercase' },
  },
  left_sep = ' ',
  right_sep = '',
}

return M

-- -- table.insert(components.right.active, 1, {
-- --   provider = LspLightbulb, -- hl = { fg = "cyan", bg = "bg", style = "bold" },
-- -- })

-- table.insert(properties.force_inactive.filetypes, "dapui_scopes")
-- table.insert(properties.force_inactive.filetypes, "dapui_watches")
-- table.insert(properties.force_inactive.filetypes, "dapui_breakpoints")
-- table.insert(properties.force_inactive.filetypes, "dapui_stacks")
-- table.insert(properties.force_inactive.filetypes, "dap-repl")
-- -- properties = {
-- --   force_inactive = {
-- --     bufnames = {},
-- --     buftypes = { "terminal" },
-- --     filetypes = {
-- --       "NvimTree",
-- --       "dbui",
-- --       "packer",
-- --       "startify",
-- --       "fugitive",
-- --       "fugitiveblame",
-- --       "dashboard",
-- --     },
-- --   },
-- -- }

-- local separators = {
--   vertical_bar = "┃",
--   vertical_bar_thin = "│",
--   left = "",
--   right = "",
--   block = "█",
--   left_filled = "  ",
--   right_filled = "  ",
--   slant_left = " ",
--   slant_left_thin = " ",
--   slant_right = " ",
--   slant_right_thin = " ",
--   slant_left_2 = " ",
--   slant_left_2_thin = "  ",
--   slant_right_2 = " ",
--   slant_right_2_thin = " ",
--   left_rounded = "  ",
--   left_rounded_thin = "  ",
--   right_rounded = "   ",
--   right_rounded_thin = "  ",
--   circle = "●",
-- }

-- -- components.left.active[3] = {
-- --   provider = "file_info",
-- --   hl = { fg = "white", bg = "dodgerblue3", style = "bold" },
-- --   left_sep = { "slant_left", { hl = { bg = "NONE", fg = "dodgerblue3" }, " " } },
-- --   right_sep = { "slant_right_2", " " },
-- -- }

-- local bgcolor = "oceanblue"
-- if vim.api.nvim_buf_get_name(0) == "[Command Line]" then bgcolor = "#330000" end

-- components.left.active[3] = {
--   provider = "file_info",
--   hl = { fg = "white", bg = "oceanblue", style = "bold" },
--   left_sep = { " ", "slant_left", { str = "", hl = { bg = bgcolor, fg = "NONE" } } },
--   right_sep = { "slant_right_2", " " },
-- }

-- -- components.left.active[3] = {
-- --   provider = function()
-- --     get_project_path()
-- --     return project_name or ""
-- --   end,
-- --   hl = function()
-- --     if project_path == nil or project_path == "" then
-- --       return { fg = "white", bg = "#333333" }
-- --     end
-- --     return { fg = "white", bg = "#440088" }
-- --   end,
-- --   -- left_sep = {str = "slant_left", hl = {fg = "#224488", bg = "NONE"}},
-- --   left_sep = function()

-- --     local val = {
-- --       str = "slant_left",
-- --       fg = "white",
-- --       bg = "#224488",
-- --       style = "bold",
-- --     }
-- --     if project_path == nil then val.bg = "#333333" end
-- --     return val
-- --   end,
-- --   right_sep = { "slant_right_2" },
-- -- }
-- -- local active_clients = nil
-- -- local last_active_client_buffer = vim.fn.bufnr()

-- -- local function lsp_active_status()
-- --   -- lsp_status:                ⏻ ⏼ ⭘      
-- --   if vim.fn.bufnr() ~= last_active_client_buffer then
-- --     active_clients = vim.lsp.buf_get_clients()
-- --     last_active_client_buffer = vim.fn.bufnr()
-- --   end

-- --   -- if active_clients == nil or #active_clients == 0 then
-- --   --   active_clients = vim.lsp.buf_get_clients()
-- --   -- end

-- --   -- if #active_clients == 0 then return " " end
-- --   -- if #active_clients > 1 then return #active_clients end
-- --   -- if active_clients[1].name == "efm" then return "" end
-- --   return ""
-- -- end

-- -- components.right.active[5] = {
-- --   provider = function() return vim.bo.filetype:lower() end,
-- --   hl = function()
-- --     if active_clients == nil or #active_clients == 0 then
-- --       return { fg = "fg" }
-- --     else
-- --       if active_clients[1].name == "efm" then
-- --         return { fg = "#6688cc", style = "italic" }
-- --       end
-- --       return { fg = "#00aacc", style = "italic" }
-- --     end
-- --   end,
-- -- }

-- -- components.right.active[6] = {
-- --   provider = lsp_active_status,
-- --   hl = function()
-- --     if active_clients == nil or #active_clients == 0 then
-- --       return { fg = "none" }
-- --     end
-- --     if #active_clients > 1 then return { fg = "#ff0000", style = "bold" } end
-- --     if active_clients[1].name == "efm" then
-- --       return { fg = "#6688ff", style = "none" }
-- --     end
-- --     return { fg = "#00ccff", style = "none" }
-- --   end,

-- --   left_sep = " ",
-- --   right_sep = " ",
-- -- }

-- require("feline").setup({
--   default_fg = "#909090",
--   default_bg = "#0F1216",
--   components = components,
--   separators = separators,
-- })
