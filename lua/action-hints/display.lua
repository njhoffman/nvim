local config = require('action-hints.config').values
local state = require('action-hints.state')

local references_namespace = vim.api.nvim_create_namespace('action_hints_references')

local last_virtual_text_line = nil

local function set_virtual_text(bufnr, line, chunks)
  -- Clear the virtual text from the previous line
  if last_virtual_text_line then
    vim.api.nvim_buf_clear_namespace(bufnr, references_namespace, last_virtual_text_line, last_virtual_text_line + 1)
  end

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
  vim.api.nvim_buf_set_virtual_text(bufnr, references_namespace, line, virtual_text_chunks, {})
  last_virtual_text_line = line
end

local function update_virtual_text()
  if config.use_virtual_text then
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
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

    set_virtual_text(bufnr, cursor[1] - 1, chunks)
  end
end

local clear_virtual_text = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if last_virtual_text_line then
    vim.api.nvim_buf_clear_namespace(bufnr, references_namespace, last_virtual_text_line, last_virtual_text_line + 1)
    last_virtual_text_line = nil
  end
end

local statusline = function()
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

local set_highlights = function()
  if vim.o.termguicolors then
    vim.api.nvim_command('highlight ActionHintsDefinition ctermfg=NONE guifg=' .. config.template.definition.color)
    vim.api.nvim_command('highlight ActionHintsReferences ctermfg=NONE guifg=' .. config.template.references.color)
    vim.api.nvim_command('highlight ActionHintsCodeActions ctermfg=NONE guifg=' .. config.template.codeactions.color)
  else
    vim.api.nvim_command('highlight ActionHintsDefinition guifg=NONE ctermfg=' .. config.template.definition.color)
    vim.api.nvim_command('highlight ActionHintsReferences guifg=NONE ctermfg=' .. config.template.references.color)
    vim.api.nvim_command('highlight ActionHintsCodeActions guifg=NONE ctermfg=' .. config.template.codeactions.color)
  end
end

return {
  set_virtual_text = set_virtual_text,
  update_virtual_text = update_virtual_text,
  clear_virtual_text = clear_virtual_text,
  statusline = statusline,
  set_highlights = set_highlights,
}
