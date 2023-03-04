local H = require("helpers")
local command_rg = { "rg", "--ignore", "--hidden", "--sort", "path", "--files" }

-- Dropdown list theme using a builtin theme definitions :
local dropdown = require("telescope.themes").get_dropdown({
  winblend = 20,
  -- layout_config = { width = 0.5 },
  -- results_height = 15,
  previewer = false,
  find_command = command_rg,
})

local ivy = require("telescope.themes").get_ivy({
  winblend = 20,
  layout_config = { height = 15 },
  find_command = command_rg,
})

local dropdown_preview = require("telescope.themes").get_dropdown({
  winblend = 20,
  prompt = " ",
  -- results_height = 15,
  layout_config = { width = 0.5 },
  find_command = command_rg,
})

-- Settings for with preview option
local with_preview = {
  find_command = command_rg,
  winblend = 20,
  show_line = false,
  results_title = false,
  preview_title = false,
  -- layout_config = { preview_width = 0.5 },
}

-- FindBuffer
_G._FindBufferLeaderF = function()
  local leaderf = require("plugs.config.telescope.leaderf")
  local opts = vim.deepcopy(dropdown_preview)
  -- local opts = {}
  opts.prompt_title = "Buffers"
  opts.entry_maker = leaderf.gen_from_buffer_like_leaderf()
  require("telescope.builtin").buffers(opts)
end

_G._FindBufferLeaderFNoPreview = function()
  local leaderf = require("plugs.config.telescope.leaderf")
  -- local opts = {}
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Buffers"
  opts.entry_maker = leaderf.gen_from_buffer_like_leaderf()
  require("telescope.builtin").buffers(opts)
end

_G._FindBufferDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Buffers"
  require("telescope.builtin").buffers(opts)
end

-- FindFiles directory
_G._FindFilesDirectory = function()
  -- local opts = vim.deepcopy(with_preview)
  local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  -- opts.prompt_title = "Find in directory '" .. directory .. "'"
  -- opts.hidden = true
  -- opts.cwd = directory
  -- require("telescope.builtin").find_files(opts)
  require("telescope.builtin").find_files({ cwd = directory })
end

-- -- FindDots
-- _G._FindDots = function()
--   local opts = vim.deepcopy(with_preview)
--   opts.prompt_title = "Find in dotfiles"
--   opts.cwd = "$HOME/.config"
--   opts.layout_config.height = 10
--   require("telescope.builtin").find_files(opts)
-- end

-- _G._FindDotsCenter = function()
--   local opts = vim.deepcopy(dropdown_preview)
--   opts.prompt_title = "Find in dotfiles"
--   opts.cwd = "$HOME/.config"
--   opts.layout_config.height = 10
--   require("telescope.builtin").find_files(opts)
-- end

-- _G._FindDotsDropdown = function()
--   local opts = vim.deepcopy(dropdown)
--   opts.prompt_title = "Find in dotfiles"
--   opts.cwd = "$HOME/.config"
--   opts.layout_config.height = 10
--   require("telescope.builtin").find_files(opts)
-- end

-- _G._FindDotsIvy = function()
--   local opts = vim.deepcopy(ivy)
--   opts.prompt_title = "Find in dotfiles"
--   opts.cwd = "$HOME/.config"
--   opts.layout_config.height = 10
--   require("telescope.builtin").find_files(opts)
-- end

-- LspDiagDocument
_G._LspDiagDocument = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "LSP Document Diagnostics"
  opts.bufnr = 0
  require("telescope.builtin").diagnostics(opts)
end

_G._LspDiagDocumentIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "LSP Document Diagnostics"
  opts.bufnr = 0
  require("telescope.builtin").diagnostics(opts)
end

-- LspDiagWorkspace
_G._LspDiagWorkspace = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "LSP Workspace Diagnostics"
  require("telescope.builtin").diagnostics(opts)
end

_G._LspDiagWorkspaceIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "LSP Workspace Diagnostics"
  require("telescope.builtin").diagnostics(opts)
end

if H.is_plugin_installed("telescope-asynctasks.nvim") then
  _G._FindAsynctasks = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Asynctasks"
    require("telescope").extensions.asynctasks.all(opts)
  end

  _G._FindAsynctasksDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Asynctasks"
    require("telescope").extensions.asynctasks.all(opts)
  end

  _G._FindAsynctasksIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Asynctasks"
    require("telescope").extensions.asynctasks.all(opts)
  end
end

-- Z extension
if H.is_plugin_installed("telescope-z.nvim") then
  _G._FindZDirectories = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Z Directories"
    opts.cmd = { "/home/nicholas/.zinit/plugins/skywind3000---z.lua/z.lua", "-l" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindZDirectoriesCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Z Directories"
    opts.cmd = { "/home/nicholas/.zinit/plugins/skywind3000---z.lua/z.lua", "-l" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindZDirectoriesDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Z Directories"
    opts.cmd = { "/home/nicholas/.zinit/plugins/skywind3000---z.lua/z.lua", "-l" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindZDirectoriesIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Z Directories"
    opts.cmd = { "/home/nicholas/.zinit/plugins/skywind3000---z.lua/z.lua", "-l" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindZoxideDirectories = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Zoxide Directories"
    opts.cmd = { "zoxide", "query", "-sl" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindZoxideDirectoriesCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Zoxide Directories"
    opts.cmd = { "zoxide", "query", "-sl" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindZoxideDirectoriesDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Zoxide Directories"
    opts.cmd = { "zoxide", "query", "-sl" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindZoxideDirectoriesIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Zoxide Directories"
    opts.cmd = { "zoxide", "query", "-sl" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindFasdDirectories = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Fasd Directories"
    opts.cmd = { "zoxide", "query", "-sl" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindFasdDirectoriesCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Fasd Directories"
    opts.cmd = { "fasd", "-d" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindFasdDirectoriesDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Fasd Directories"
    opts.cmd = { "fasd", "-d" }
    require("telescope").extensions.z.list(opts)
  end

  _G._FindFasdDirectoriesIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Fasd Directories"
    opts.cmd = { "fasd", "-d" }
    require("telescope").extensions.z.list(opts)
  end
end

--Zettels
_G._FindZettels = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "Zettel"
  require("neuron/telescope").find_zettels(opts)
end

_G._FindZettelsCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "Zettel"
  require("neuron/telescope").find_zettels(opts)
end

_G._FindZettelsDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Zettel"
  require("neuron/telescope").find_zettels(opts)
end

_G._FindZettelsIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Zettel"
  require("neuron/telescope").find_zettels(opts)
end

_G._FindZettelTags = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "Zettel Tags"
  require("neuron/telescope").find_tags(opts)
end

_G._FindZettelTagsCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "Zettel Tags"
  require("neuron/telescope").find_tags(opts)
end

_G._FindZettelTagsDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Zettel Tags"
  require("neuron/telescope").find_tags(opts)
end

_G._FindZettelTagsIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Zettel Tags"
  require("neuron/telescope").find_tags(opts)
end
