local state = require('action-hints.state')

local references_namespace = vim.api.nvim_create_namespace('action_hints_references')

local last_virtual_text_line = nil

local clear_virtual_text = function()
  local bufnr = vim.api.nvim_get_current_buf()
  -- if last_virtual_text_line then
  vim.api.nvim_buf_clear_namespace(bufnr, references_namespace, 0, -1)
  last_virtual_text_line = nil
  -- end
end

local function set_virtual_text(bufnr, line, chunks)
  -- Clear the virtual text from the previous line
  clear_virtual_text()
  -- Check for conditions where you might want to exit early
  if
    vim.api.nvim_buf_get_option(bufnr, 'buftype') ~= ''
    or vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'help'
    or vim.fn.bufname(bufnr) == ''
  then
    -- Reset the last virtual text line to ensure it gets cleared next time
    last_virtual_text_line = nil
    return
  end

  -- Prepare the virtual text with proper highlight groups
  local virtual_text_chunks = {}
  for _, chunk in ipairs(chunks) do
    table.insert(virtual_text_chunks, { chunk[1], chunk[2] })
  end

  -- Set the virtual text for the current line
  local opts = {
    virt_text = virtual_text_chunks,
    virt_text_pos = 'eol', -- eol, right, inline
    virt_text_hide = true,
    hl_mode = 'combine', -- replace, combine,blend
  }

  -- vim.api.nvim_buf_set_virtual_text(bufnr, references_namespace, line, virtual_text_chunks, {})
  vim.api.nvim_buf_set_extmark(bufnr, references_namespace, line, 0, opts)
  last_virtual_text_line = line
end

local function update_virtual_text(config)
  if config.use_virtual_text then
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)

    local definition_status = state.available.definitions and config.template.definition.text or ''
    local reference_status = state.current.references > 0
        and string.format(config.template.references.text, tostring(state.current.references))
      or ''
    local codeaction_status = state.current.codeactions > 0
        and string.format(config.template.codeactions.text, tostring(state.current.codeactions))
      or ''

    local chunks = {
      { definition_status, 'ActionHintsDefinition' },
      { reference_status, 'ActionHintsReferences' },
      { codeaction_status, 'ActionHintsCodeActions' },
    }

    set_virtual_text(bufnr, cursor[1] - 1, chunks)
  end
end

local statusline = function(config)
  local definition_status = state.definition_available and config.template.definition.text or ''
  local reference_status = state.reference_count > 0
      and string.format(config.template.references.text, tostring(state.reference_count))
    or ''
  local codeaction_status = state.codeaction_count > 0
      and string.format(config.template.codeactions.text, tostring(state.codeaction_count))
    or ''
  local chunks = {
    { definition_status, 'ActionHintsDefinition' },
    { reference_status, 'ActionHintsReferences' },
    { codeaction_status, 'ActionHintsCodeActions' },
  }

  local text = ''
  for _, chunk in ipairs(chunks) do
    text = text .. chunk[1]
  end

  return text
end

local set_highlights = function(config)
  vim.api.nvim_command(
    'highlight ActionHintsDefinition guibg=NONE ctermbg=NONE ctermfg=NONE guifg='
      .. config.template.definition.color
  )
  vim.api.nvim_command(
    'highlight ActionHintsReferences guibg=NONE ctermbg=NONE ctermfg=NONE guifg='
      .. config.template.references.color
  )
  vim.api.nvim_command(
    'highlight ActionHintsCodeActions guibg=NONE ctermbg=NONE ctermfg=NONE guifg='
      .. config.template.codeactions.color
  )
end

return {
  set_virtual_text = set_virtual_text,
  update_virtual_text = update_virtual_text,
  clear_virtual_text = clear_virtual_text,
  statusline = statusline,
  set_highlights = set_highlights,
}
