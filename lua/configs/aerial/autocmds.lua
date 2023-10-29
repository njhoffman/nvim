local aerial = require('aerial')

local start_with_backend = function(backend)
  return function()
    local config = require('aerial.config')
    config.setup({ backends = { backend } })
    -- return M.get_backend_by_name(name), name
    aerial.close()
    aerial.toggle()
  end
end

local setup_backend_cmds = function()
  if vim.bo.filetype ~= '' then
    -- local config = require('aerial.config')
    local bufnr = vim.api.nvim_get_current_buf()
    local backends = require('aerial.backends')
    local all_backends = { 'lsp', 'treesitter', 'man', 'help' }
    local supported = {}
    for _, be in ipairs(all_backends) do
      local is_supported, supported_ok = pcall(backends.is_supported, bufnr, be)
      supported[be] = supported_ok and is_supported
    end
    for _, be in ipairs(all_backends) do
      local cmd = 'Aerial' .. string.sub(string.upper(be), 1, 1) .. string.sub(be, 2, -1)
      if supported[be] == true then
        vim.api.nvim_create_user_command(
          cmd,
          start_with_backend(be),
          { desc = 'Start Aerial with ' .. be .. ' backend', force = true }
        )
      else
        local _, _ = pcall(vim.api.nvim_del_user_command, cmd)
      end
    end
  end
end

local setup_cmds = function()
  -- local opts = vim.tbl_deep_extend("force", default, cfg, { backends = { backend } })
  local augroup_ok, _ = pcall(vim.api.nvim_get_autocmds, { group = 'AerialBuffer' })
  if not augroup_ok then
    vim.api.nvim_create_augroup('AerialBuffer', { clear = false })
  end
  -- setup_backend_cmds()
end

--
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   group = "AerialBuffer",
--   desc = "Create commands depending on aerial backend capabilities",
--   callback = setup_cmds,
-- })
-- --
return { setup = setup_cmds }
