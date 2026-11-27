-- gitops get_repo: gitsigns' repo data when attached, else the repo found from the buffer's path
local utils = require("modules.gitops.utils")

local function tmpdir()
  local dir = vim.fn.resolve(vim.fn.tempname())
  vim.fn.mkdir(dir, "p")
  return dir
end

local function git_init(dir)
  vim.fn.system({ "git", "init", "-q", dir })
  assert.are.equal(0, vim.v.shell_error)
end

local function file_buf(path)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile({ "x" }, path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  return vim.api.nvim_get_current_buf()
end

describe("gitops get_repo", function()
  local cwd, dirs

  before_each(function()
    cwd = vim.fn.getcwd()
    dirs = {}
  end)

  after_each(function()
    vim.cmd("silent! %bwipeout!")
    vim.fn.chdir(cwd)
    for _, dir in ipairs(dirs) do
      vim.fn.delete(dir, "rf")
    end
  end)

  local function new_dir()
    local dir = tmpdir()
    dirs[#dirs + 1] = dir
    return dir
  end

  it("uses gitsigns' data when it has attached", function()
    local buf = vim.api.nvim_create_buf(true, false)
    vim.b[buf].gitsigns_status_dict = { root = "/r", gitdir = "/r/.git" }
    assert.are.same({ worktree = "/r", gitdir = "/r/.git" }, utils.get_repo(buf))
  end)

  it("finds the repo of a file buffer without gitsigns", function()
    local repo = new_dir()
    git_init(repo)
    local buf = file_buf(repo .. "/sub/dir/file.txt")
    assert.are.same({ worktree = repo, gitdir = repo .. "/.git" }, utils.get_repo(buf))
    assert.are.same({ worktree = repo, gitdir = repo .. "/.git" }, utils.get_repo(0))
  end)

  it("uses the cwd's repo for unnamed and non-file buffers", function()
    local repo = new_dir()
    git_init(repo)
    vim.fn.chdir(repo)
    local buf = vim.api.nvim_create_buf(false, true)
    assert.are.same({ worktree = repo, gitdir = repo .. "/.git" }, utils.get_repo(buf))
  end)

  it("follows a worktree's .git file, absolute or relative", function()
    local root = new_dir()
    vim.fn.mkdir(root .. "/main/.git/worktrees/wt", "p")
    vim.fn.mkdir(root .. "/wt", "p")
    vim.fn.writefile({ "gitdir: " .. root .. "/main/.git/worktrees/wt" }, root .. "/wt/.git")
    local buf = file_buf(root .. "/wt/a.txt")
    assert.are.same(
      { worktree = root .. "/wt", gitdir = root .. "/main/.git/worktrees/wt" },
      utils.get_repo(buf)
    )

    vim.fn.writefile({ "gitdir: ../main/.git/worktrees/wt" }, root .. "/wt/.git")
    assert.are.same(
      { worktree = root .. "/wt", gitdir = root .. "/main/.git/worktrees/wt" },
      utils.get_repo(buf)
    )
  end)

  it("returns an empty table outside a repo, without a warning", function()
    local logger = require("modules.gitops.utils.logger")
    local warn, warned = logger.warn, false
    logger.warn = function()
      warned = true
    end
    local dir = new_dir()
    vim.fn.chdir(dir)
    local ok, repo = pcall(utils.get_repo, file_buf(dir .. "/plain.txt"))
    logger.warn = warn
    assert.is_true(ok, repo)
    -- tempname() lives under /tmp, which is not inside a repo
    assert.are.same({}, repo)
    assert.is_false(warned)
  end)
end)
