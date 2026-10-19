-- Minimal init file for testing
-- This loads only the essential plugins needed for tests

-- Add current directory to runtimepath
vim.opt.rtp:prepend(".")

-- Add plenary.nvim
local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary_path) == 1 then
  vim.opt.rtp:append(plenary_path)
  vim.cmd("runtime! plugin/plenary.vim")
end

-- Add mini.test
local minitest_path = vim.fn.stdpath("data") .. "/lazy/mini.test"
if vim.fn.isdirectory(minitest_path) == 1 then
  vim.opt.rtp:append(minitest_path)
end

-- Add bars.nvim (local source)
local bars_path = vim.fn.expand("~/.local/src/bars.nvim")
if vim.fn.isdirectory(bars_path) == 1 then
  vim.opt.rtp:append(bars_path)
end

-- Coverage: NVIM_COVERAGE=<statsfile> loads luacov (luarocks lua 5.1 tree)
local coverage_stats = os.getenv("NVIM_COVERAGE")
if coverage_stats and coverage_stats ~= "" then
  package.path = package.path
    .. ";/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"
  -- cluacov is built against PUC Lua; use luacov's pure-Lua hook under LuaJIT
  package.preload["cluacov.version"] = function()
    error("cluacov disabled under LuaJIT")
  end
  local ok, runner = pcall(require, "luacov.runner")
  if ok then
    jit.off()
    local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
    runner.init({
      statsfile = coverage_stats,
      include = { "^" .. vim.pesc(root) .. "lua/", "^%./lua/", "^lua/" },
      exclude = { "tests/", "lazy/", "lua/plenary/" },
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        runner.shutdown()
      end,
    })
  else
    io.stderr:write("luacov not available: " .. tostring(runner) .. "\n")
  end
end

-- Set up basic test environment
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = false
