local H = require("helpers")

-- Dropdown list theme using a builtin theme definitions :
local dropdown =
require "telescope.themes".get_dropdown(
  {
    winblend = 10,
    layout_config = { width = 0.5 },
    prompt = " ",
    -- results_height = 15,
    previewer = false
  }
)

local ivy =
require "telescope.themes".get_ivy(
  {
    winblend = 10,
    layout_config = { height = 15 }
  }
)

local dropdown_preview =
require "telescope.themes".get_dropdown(
  {
    winblend = 10,
    prompt = " ",
    -- results_height = 15,
    layout_config = { width = 0.5 }
  }
)

-- Settings for with preview option
local with_preview = {
  winblend = 10,
  show_line = false,
  results_title = false,
  preview_title = false
  -- layout_config = { preview_width = 0.5 },
}

-- FindBuffer
_G._FindBuffer = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "Buffers"
  require("telescope.builtin").buffers(opts)
end

_G._FindBufferLeaderF = function()
  local leaderf = require("plugins.configs.telescope-leaderf")
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "Buffers"
  opts.entry_maker = leaderf.gen_from_buffer()
  require("telescope.builtin").buffers(opts)
end

_G._FindBufferLeaderFNoPreview = function()
  local leaderf = require("plugins.configs.telescope-leaderf")
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Buffers"
  opts.entry_maker = leaderf.gen_from_buffer()
  require("telescope.builtin").buffers(opts)
end

_G._FindBufferDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Buffers"
  require("telescope.builtin").buffers(opts)
end

_G._FindBufferIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Buffers"
  require("telescope.builtin").buffers(opts)
end

-- FindFiles project
_G._FindFiles = function()
  local opts = vim.deepcopy(with_preview)
  -- local project_root = require("project_nvim.project").get_project_root() or ""
  -- opts.prompt_title = "Find in project '" .. project_root:gsub(os.getenv("HOME"), "~") .. "'"
  opts.hidden = true --
  -- opts.cwd = project_root
  -- local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  -- opts.cwd = vim.fn.getcwd() or directory
  require("telescope.builtin").find_files(opts)
end

_G._FindFilesCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  -- local project_root = require("project_nvim.project").get_project_root() or ""
  -- opts.cwd = project_root
  -- local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  -- opts.cwd = vim.fn.getcwd() or directory
  opts.hidden = true
  -- opts.prompt_title = "Find in project '" .. project_root:gsub(os.getenv("HOME"), "~") .. "'"
  require("telescope.builtin").find_files(opts)
end

_G._FindFilesDropdown = function()
  local opts = vim.deepcopy(dropdown)
  -- local project_root = require("project_nvim.project").get_project_root() or ""
  -- opts.cwd = project_root
  -- local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  -- opts.cwd = vim.fn.getcwd() or directory
  opts.hidden = true
  -- opts.prompt_title = "Find in project '" .. project_root:gsub(os.getenv("HOME"), "~") .. "'"
  require("telescope.builtin").find_files(opts)
end

_G._FindFilesIvy = function()
  local opts = vim.deepcopy(ivy)
  -- local project_root = require("project_nvim.project").get_project_root() or ""
  opts.hidden = true
  local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  -- opts.cwd = directory
  -- opts.prompt_title = "Find in project '" .. project_root:gsub(os.getenv("HOME"), "~") .. "'"
  require("telescope.builtin").find_files(opts)
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

_G._FindFilesDirectoryCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  opts.prompt_title = "Find in directory '" .. directory .. "'"
  opts.hidden = true
  -- opts.cwd = directory
  require("telescope.builtin").find_files(opts)
end

_G._FindFilesDirectoryDropdown = function()
  local opts = vim.deepcopy(dropdown)
  local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  -- opts.cwd = directory
  opts.hidden = true
  opts.prompt_title = "Find in directory '" .. directory .. "'"
  require("telescope.builtin").find_files(opts)
end

_G._FindFilesDirectoryIvy = function()
  local opts = vim.deepcopy(ivy)
  local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
  -- foo = (foo or '')=='' and 'default value' or foo
  opts.prompt_title = "Find in directory '" .. directory .. "'"
  opts.hidden = true
  -- opts.cwd = directory
  require("telescope.builtin").find_files(opts)
end

-- OldFiles
_G._FindOldFiles = function()
  local opts = vim.deepcopy(with_preview)
  opts.hidden = true
  opts.prompt_title = "Find in MRU"
  require("telescope.builtin").oldfiles(opts)
end

_G._FindOldFilesCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "Find in MRU"
  opts.hidden = true
  require("telescope.builtin").oldfiles(opts)
end

_G._FindOldFilesDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Find in MRU"
  opts.hidden = true
  require("telescope.builtin").oldfiles(opts)
end

_G._FindOldFilesIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Find in MRU"
  require("telescope.builtin").oldfiles(opts)
end

_G._FindString = function()
  local opts = vim.deepcopy(with_preview)
  local preview_opts = vim.deepcopy(with_preview)
  for _, preview_opt in ipairs(preview_opts) do
    table.insert(opts, preview_opt)
  end
  opts.search = vim.fn.input("Grep for > ")
  opts.prompt_title = "Filter results"
  require("telescope.builtin").grep_string(opts)
end

_G._FindStringCenter = function()
  -- local opts = vim.deepcopy(with_preview)
  local opts = vim.deepcopy(dropdown_preview)
  local preview_opts = vim.deepcopy(with_preview)
  for _, preview_opt in ipairs(preview_opts) do
    table.insert(opts, preview_opt)
  end
  opts.search = vim.fn.input("Grep for > ")
  opts.prompt_title = "Filter results"
  require("telescope.builtin").grep_string(opts)
end

_G._FindStringDropdown = function()
  -- local opts = vim.deepcopy(with_preview)
  local opts = vim.deepcopy(dropdown)
  local preview_opts = vim.deepcopy(with_preview)
  for _, preview_opt in ipairs(preview_opts) do
    table.insert(opts, preview_opt)
  end
  opts.search = vim.fn.input("Grep for > ")
  opts.prompt_title = "Filter results"
  require("telescope.builtin").grep_string(opts)
end

-- FindLive
_G._FindLive = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "Live search"
  require("telescope.builtin").live_grep(opts)
end

_G._FindLiveCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "Live search"
  require("telescope.builtin").live_grep(opts)
end

_G._FindLiveDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Live search"
  require("telescope.builtin").live_grep(opts)
end

_G._FindLiveIvy = function()
  -- local opts = vim.deepcopy(with_preview)
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Live search"
  require("telescope.builtin").live_grep(opts)
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

_G._LspDiagDocumentCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "LSP Document Diagnostics"
  opts.bufnr = 0
  require("telescope.builtin").diagnostics(opts)
end

_G._LspDiagDocumentDropdown = function()
  local opts = vim.deepcopy(dropdown)
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

_G._LspDiagWorkspaceCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "LSP Workspace Diagnostics"
  require("telescope.builtin").diagnostics(opts)
end

_G._LspDiagWorkspaceDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "LSP Workspace Diagnostics"
  require("telescope.builtin").diagnostics(opts)
end

_G._LspDiagWorkspaceIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "LSP Workspace Diagnostics"
  require("telescope.builtin").diagnostics(opts)
end

--
-- EXTENSIONS
-- Asynctasks extension

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

-- Frecency extension
if H.is_plugin_installed("telescope-frecency.nvim") then
  _G._FindFrecency = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Frecency Files"
    require("telescope").extensions.frecency.frecency(opts)
  end

  _G._FindFrecencyCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Frecency Files"
    require("telescope").extensions.frecency.frecency(opts)
  end

  _G._FindFrecencyDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Frecency Files"
    require("telescope").extensions.frecency.frecency(opts)
  end

  _G._FindFrecencyIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Frecency Files"
    require("telescope").extensions.frecency.frecency(opts)
  end
end

-- Media files extension
if H.is_plugin_installed("telescope-media-files.nvim") then
  _G._FindMediaFiles = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Media Files"
    require("telescope").extensions.media_files.media_files(opts)
  end
  _G._FindMediaFilesCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Media Files"
    require("telescope").extensions.media_files.media_files(opts)
  end

  _G._FindMediaFilesIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Media Files"
    require("telescope").extensions.media_files.media_files(opts)
  end
end

-- Ghq extension
if H.is_plugin_installed("telescope-ghq.nvim") then
  _G._FindGhq = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Repositories managed by ghq"
    require("telescope").extensions.ghq.list(opts)
  end

  _G._FindGhqCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Repositories managed by ghq"
    require("telescope").extensions.ghq.list(opts)
  end

  _G._FindGhqDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Repositories managed by ghq"
    require("telescope").extensions.ghq.list(opts)
  end

  _G._FindGhqIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Repositories managed by ghq"
    require("telescope").extensions.ghq.list(opts)
  end
end

-- Ultisnips extension
if H.is_plugin_installed("telescope-ultisnips.nvim") then
  _G._FindUltisnips = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Ultisnips Snippets"
    require("telescope").extensions.ultisnips.ultisnips(opts)
  end

  _G._FindUltisnipsCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Ultisnips Snippets"
    require("telescope").extensions.ultisnips.ultisnips(opts)
  end

  _G._FindUltisnipsDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Ultisnips Snippets"
    require("telescope").extensions.ultisnips.ultisnips(opts)
  end

  _G._FindUltisnipsIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Ultisnips Snippets"
    require("telescope").extensions.ultisnips.ultisnips(opts)
  end
end

-- Packer extension
if H.is_plugin_installed("telescope-packer.nvim") then
  _G._FindPacker = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Packer Plugins"
    require("telescope").extensions.packer.plugins(opts)
  end

  _G._FindPackerCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Packer Plugins"
    require("telescope").extensions.packer.plugins(opts)
  end

  _G._FindPackerDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Packer Plugins"
    require("telescope").extensions.packer.plugins(opts)
  end

  _G._FindPackerIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Packer Plugins"
    require("telescope").extensions.packer.plugins(opts)
  end
end

-- Cheatsheet extension
if H.is_plugin_installed("cheatsheet.nvim") then
  _G._FindCheatsheet = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Cheatsheet Plugins"
    require("cheatsheet.telescope").pick_cheat(opts)
  end

  _G._FindCheatsheetCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Cheatsheet Plugins"
    require("cheatsheet.telescope").pick_cheat(opts)
  end

  _G._FindCheatsheetDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Cheatsheet Plugins"
    require("cheatsheet.telescope").pick_cheat(opts)
  end

  _G._FindCheatsheetIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Cheatsheet Plugins"
    require("cheatsheet.telescope").pick_cheat(opts)
  end
end

-- Github extension
if H.is_plugin_installed("telescope-github.nvim") then
  _G._FindGithubIssues = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Github Issues"
    require("telescope").extensions.gh.issues(opts)
  end

  _G._FindGithubIssuesCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Github Issues"
    require("telescope").extensions.gh.issues(opts)
  end

  _G._FindGithubIssuesDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Github Issues"
    require("telescope").extensions.gh.issues(opts)
  end

  _G._FindGithubIssuesIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Github Issues"
    require("telescope").extensions.gh.issues(opts)
  end

  _G._FindGithubGist = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Github Gist"
    require("telescope").extensions.gh.gist(opts)
  end

  _G._FindGithubGistCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Github Gist"
    require("telescope").extensions.gh.gist(opts)
  end

  _G._FindGithubGistDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Github Gist"
    require("telescope").extensions.gh.gist(opts)
  end

  _G._FindGithubGistIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Github Gist"
    require("telescope").extensions.gh.gist(opts)
  end

  _G._FindGithubPullRequest = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Github Pull Request"
    require("telescope").extensions.gh.pull_request(opts)
  end

  _G._FindGithubPullRequestCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Github Pull Request"
    require("telescope").extensions.gh.pull_request(opts)
  end

  _G._FindGithubPullRequestDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Github Pull Request"
    require("telescope").extensions.gh.pull_request(opts)
  end

  _G._FindGithubPullRequestIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Github Pull Request"
    require("telescope").extensions.gh.pull_request(opts)
  end

  _G._FindGithubRun = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Github Run"
    require("telescope").extensions.gh.run(opts)
  end

  _G._FindGithubRunCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Github Run"
    require("telescope").extensions.gh.run(opts)
  end

  _G._FindGithubRunDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Github Run"
    require("telescope").extensions.gh.run(opts)
  end

  _G._FindGithubRunIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Github Run"
    require("telescope").extensions.gh.run(opts)
  end
end

-- Octo extension
if H.is_plugin_installed("octo.nvim") then
  _G._FindOctoIssues = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Octo Issues"
    require("telescope").extensions.octo.issues(opts)
  end

  _G._FindOctoIssuesCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Octo Issues"
    require("telescope").extensions.octo.issues(opts)
  end

  _G._FindOctoIssuesDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Octo Issues"
    require("telescope").extensions.octo.issues(opts)
  end

  _G._FindOctoIssuesIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Octo Issues"
    require("telescope").extensions.octo.issues(opts)
  end

  _G._FindOctoIssuesGrep = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Octo Issue Search"
    require("telescope").extensions.octo.live_issues(opts)
  end

  _G._FindOctoIssuesGrepCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Octo Issue Search"
    require("telescope").extensions.octo.live_issues(opts)
  end

  _G._FindOctoIssuesGrepDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Octo Issue Search"
    require("telescope").extensions.octo.live_issues(opts)
  end

  _G._FindOctoIssuesGrepIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Octo Issue Search"
    require("telescope").extensions.octo.live_issues(opts)
  end

  _G._FindOctoCommits = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Octo Commits"
    require("telescope").extensions.octo.commits(opts)
  end

  _G._FindOctoCommitsCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Octo Commits"
    require("telescope").extensions.octo.commits(opts)
  end

  _G._FindOctoCommitsDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Octo Commits"
    require("telescope").extensions.octo.commits(opts)
  end

  _G._FindOctoCommitsIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Octo Commits"
    require("telescope").extensions.octo.commits(opts)
  end

  _G._FindOctoFiles = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Octo Changed Files"
    require("telescope").extensions.octo.files(opts)
  end

  _G._FindOctoFilesCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Octo Changed Files"
    require("telescope").extensions.octo.files(opts)
  end

  _G._FindOctoFilesDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Octo Changed Files"
    require("telescope").extensions.octo.files(opts)
  end

  _G._FindOctoFilesIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Octo Changed Files"
    require("telescope").extensions.octo.files(opts)
  end

  _G._FindOctoGists = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Octo Gists"
    require("telescope").extensions.octo.gists(opts)
  end

  _G._FindOctoGistsCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Octo Gists"
    require("telescope").extensions.octo.gists(opts)
  end

  _G._FindOctoGistsDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Octo Gists"
    require("telescope").extensions.octo.gists(opts)
  end

  _G._FindOctoGistsIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Octo Gists"
    require("telescope").extensions.octo.gists(opts)
  end

  _G._FindOctoPullRequests = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Octo Pull Requests"
    require("telescope").extensions.octo.prs(opts)
  end

  _G._FindOctoPullRequestsCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Octo Pull Requests"
    require("telescope").extensions.octo.prs(opts)
  end

  _G._FindOctoPullRequestsDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Octo Pull Requests"
    require("telescope").extensions.octo.prs(opts)
  end

  _G._FindOctoPullRequestsIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Octo Pull Requests"
    require("telescope").extensions.octo.prs(opts)
  end

  _G._FindOctoPullRequestsGrep = function()
    local opts = vim.deepcopy(with_preview)
    opts.prompt_title = "Octo Pull Request Search"
    require("telescope").extensions.octo.live_prs(opts)
  end

  _G._FindOctoPullRequestsGrepCenter = function()
    local opts = vim.deepcopy(dropdown_preview)
    opts.prompt_title = "Octo Pull Request Search"
    require("telescope").extensions.octo.live_prs(opts)
  end

  _G._FindOctoPullRequestsGrepDropdown = function()
    local opts = vim.deepcopy(dropdown)
    opts.prompt_title = "Octo Pull Request Search"
    require("telescope").extensions.octo.live_prs(opts)
  end

  _G._FindOctoPullRequestsGrepIvy = function()
    local opts = vim.deepcopy(ivy)
    opts.prompt_title = "Octo Pull Request Search"
    require("telescope").extensions.octo.live_prs(opts)
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

-- if H.is_plugin_installed("telescope-bookmarks.nvim") then telescope.load_extension("bookmarks") end
-- if H.is_plugin_installed("telescope-dap.nvim") then telescope.load_extension("dap") end
-- if H.is_plugin_installed("telescope-node-modules.nvim") then telescope.load_extension("node_modules") end
-- if H.is_plugin_installed("telescope-tmux.nvim") then telescope.load_extension("tmux") end
-- if H.is_plugin_installed("telescope-lsp-handlers.nvim") then require("plugins.configs.telescope-lsp-handlers") end

--Zettels
_G._FindZettels = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "Zettel"
  require "neuron/telescope".find_zettels(opts)
end

_G._FindZettelsCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "Zettel"
  require "neuron/telescope".find_zettels(opts)
end

_G._FindZettelsDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Zettel"
  require "neuron/telescope".find_zettels(opts)
end

_G._FindZettelsIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Zettel"
  require "neuron/telescope".find_zettels(opts)
end

_G._FindZettelTags = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "Zettel Tags"
  require "neuron/telescope".find_tags(opts)
end

_G._FindZettelTagsCenter = function()
  local opts = vim.deepcopy(dropdown_preview)
  opts.prompt_title = "Zettel Tags"
  require "neuron/telescope".find_tags(opts)
end

_G._FindZettelTagsDropdown = function()
  local opts = vim.deepcopy(dropdown)
  opts.prompt_title = "Zettel Tags"
  require "neuron/telescope".find_tags(opts)
end

_G._FindZettelTagsIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Zettel Tags"
  require "neuron/telescope".find_tags(opts)
end

-- FindGitBranches
_G._FindGitBranches = function()
  require("telescope.builtin").git_branches(
    {
      attach_mappings = function(_, mapKey)
        mapKey("i", "<c-d>", actions.git_delete_branch)
        mapKey("n", "<c-d>", actions.git_delete_branch)
        return true
      end
    }
  )
end

-- FindGitBranches
_G._FindNotifications = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_title = "Notifications"
  require("telescope").extensions.notify.notify(opts)
end

_G._FindNotificationsIvy = function()
  local opts = vim.deepcopy(ivy)
  opts.prompt_title = "Notifications"
  require("telescope").extensions.notify.notify(opts)
end
