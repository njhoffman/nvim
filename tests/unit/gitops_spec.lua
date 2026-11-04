-- Every export of the gitops Telescope extension opens a picker, in a real scratch git repo.
local data = vim.fn.stdpath("data") .. "/lazy/"
local fork = vim.fn.expand("~/git/telescope.nvim")
vim.opt.rtp:append(vim.fn.isdirectory(fork) == 1 and fork or (data .. "telescope.nvim"))
vim.opt.rtp:append(data .. "plenary.nvim")

local function git(dir, ...)
  local result = vim.system({ "git", "-C", dir, ... }, { text = true }):wait()
  assert(result.code == 0, table.concat({ ... }, " ") .. ": " .. result.stderr)
  return result.stdout
end

local function scratch_repo()
  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, "p")
  git(dir, "init", "-q", "-b", "main")
  git(dir, "config", "user.email", "t@example.com")
  git(dir, "config", "user.name", "t")
  vim.fn.writefile({ "one", "two" }, dir .. "/a.txt")
  git(dir, "add", "a.txt")
  git(dir, "commit", "-qm", "first")
  git(dir, "checkout", "-qb", "topic")
  vim.fn.writefile({ "one", "two", "three" }, dir .. "/a.txt")
  git(dir, "commit", "-qam", "second")
  return dir
end

local function close_pickers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "TelescopePrompt" then
      pcall(require("telescope.actions").close, buf)
    end
  end
end

describe("gitops telescope exports", function()
  local exports, dir, previous

  before_each(function()
    previous = vim.fn.getcwd()
    dir = scratch_repo()
    vim.cmd.cd(dir)
    vim.cmd.edit(dir .. "/a.txt")
    exports = require("telescope._extensions.gitops").exports
  end)

  after_each(function()
    close_pickers()
    vim.cmd("silent! %bwipeout!")
    vim.cmd.cd(previous)
    vim.fn.delete(dir, "rf")
  end)

  local names = {
    "gitops",
    "search_content",
    "search_content_file",
    "show_custom_functions",
    "checkout_reflog",
    "commits",
    "bcommits",
    "files",
    "stash",
    "status",
    "branches",
    "diff_branch",
    "diff_branch_file",
    "diff_commit_file",
    "diff_commit_line",
  }

  for _, name in ipairs(names) do
    it(name .. " opens without an error", function()
      assert.is_function(exports[name])
      local ok, err = pcall(exports[name], {})
      assert.is_true(ok, tostring(err))
      vim.wait(50)
    end)
  end
end)

describe("gitops git utils", function()
  it("base_branch returns one value", function()
    local git_utils = require("modules.gitops.utils.git")
    assert.equals(1, select("#", git_utils.base_branch()))
  end)

  it("get_repo is reachable from utils.git", function()
    assert.is_function(require("modules.gitops.utils.git").get_repo)
  end)

  it("mappings expose the entry mappings and the builder", function()
    local mappings = require("modules.gitops.mappings")
    for _, name in ipairs({ "build_mappings", "omnimap", "checkout_reflog_entry", "show_entire_commit" }) do
      assert.is_function(mappings[name])
    end
    assert.is_function(mappings.open_diff_view_current_file_selected_commit)
  end)
end)
