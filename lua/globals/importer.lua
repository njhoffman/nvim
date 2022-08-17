local function backup_import(mod_name)
  local mod_ok, mod = pcall(require, mod_name)
  if not mod_ok then
    local msg = "failed loading: " .. mod_name .. "\n " .. vim.inspect(mod)
    vim.notify(msg, "error")
  end
end

local ok, importmod = pcall(require, 'import')
if ok then
  importmod.config()

  if importmod ~= nil and importmod.import ~= nil then
    vim.import = importmod.import
    vim.reload = importmod.reload
  else
    vim.notify({ 'could not attach import wrapper', importmod }, 'warn')
  end
else
  vim.import = backup_import
end
