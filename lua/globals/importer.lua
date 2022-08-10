local function backup_import(mod_name)
  local mod_ok, mod = pcall(require, mod_name)
  if not mod_ok then
    local msg = "failed loading: " .. mod_name .. "\n " .. vim.inspect(mod)
    vim.notify(msg, "error")
  end
end

local ok, importmod = pcall(require, 'import')
if ok then
  importmod.config({
    keypress_select = "<Enter>",
    keypress_close = '<Esc>',
    keypress_scroll_output_down = '<C-Down>',
    keypress_scroll_output_up = '<C-Up>',
    output_split_type = 'horizontal',
    -- "⨀ ","🔷","🔵 ", "✅",
    import_failed_icon = "⛔",
    import_success_icon = " ❎",
    import_enable_better_printing = true
    -- import_enable_better_printing = false
  })

  if importmod ~= nil and importmod.import ~= nil then
    vim.import = importmod.import
    vim.reload = importmod.reload
  else
    vim.notify({ 'could not attach import wrapper', importmod }, 'warn')
  end
else
  vim.import = backup_import
end
