local set_option = vim.api.nvim_set_option_value

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local last_file = nil
local fasd_update = function()
  local ignored = {
    filetypes = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
  }
  local logger = require('logger').init('fasd')
  local fname = vim.api.nvim_buf_get_name(0)
  if
    vim.bo.buftype == ''
    and not vim.tbl_contains(ignored.fileypes, vim.bo.filetype)
    and fname ~= ''
    and fname ~= last_file
    and file_exists(fname)
  then
    vim.fn.jobstart({ 'fasd', '-A', fname })
    logger:trace('add ' .. vim.fn.fnamemodify(fname, ':t'))
    last_file = fname
  end
end

local hlsearch_on = function()
  local search_keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
  vim.on_key(function(char)
    if vim.fn.mode() == 'n' then
      local hlsearch = vim.tbl_contains(search_keys, vim.fn.keytrans(char))
      if vim.opt.hlsearch:get() ~= hlsearch then
        vim.opt.hlsearch = hlsearch
      end
    end
  end, vim.api.nvim_create_namespace('SearchHighlightsOn'))
end

local hlsearch_off = function()
  -- vim.on_key(nil, ns_id)
  vim.on_key(function(char)
    local key = vim.fn.keytrans(char)
    local isCmdlineSearch = vim.fn.getcmdtype():find('[/?]') ~= nil
    local searchMvKeys = { 'n', 'N', '*', '#' } -- works for RHS, therefore no need to consider remaps
    local isNormalMode = vim.api.nvim_get_mode().mode == 'n'

    local searchStarted = (key == '/' or key == '?') and isNormalMode
    local searchConfirmed = (key == '<CR>' and isCmdlineSearch)
    local searchCancelled = (key == '<Esc>' and isCmdlineSearch)
    if not (searchStarted or searchConfirmed or searchCancelled or isNormalMode) then
      return
    end
    local searchMovement = vim.tbl_contains(searchMvKeys, key)
    local hlSearchOn = vim.o.hlsearch

    if (searchMovement or searchConfirmed or searchStarted) and not hlSearchOn then
      vim.opt.hlsearch = true
    elseif (searchCancelled or not searchMovement) and hlSearchOn and not searchConfirmed then
      vim.opt.hlsearch = false
    end

    -- nvim-hlslens plugin
    if searchConfirmed or searchMovement then
      local installed, hlslens = pcall(require, 'hlslens')
      if installed then
        hlslens.start()
      end
    end
  end, vim.api.nvim_create_namespace('SearchHighlightsOff'))
end

return {
  lsp_diagnostics = lsp_diagnostics,
  lsp_progress = lsp_progress,
  fasd_update = fasd_update,
  hlsearch_on = hlsearch_on,
  hlsearch_off = hlsearch_off,
}
