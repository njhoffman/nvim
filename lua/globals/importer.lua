local backup_import = function(mod_name, cb)
  local mod_ok, mod = pcall(require, mod_name)
  if not mod_ok then
    local msg = "failed loading: " .. mod_name .. "\n " .. vim.inspect(mod)
    vim.notify(msg, "error")
  end
  if type(cb) == 'function' then cb(mod) end
end


local import_ok, importer = pcall(require, 'import')
if import_ok then
  importer.init()
  if importer ~= nil and importer.import ~= nil then
    vim.import = importer.import
    vim.reload = importer.reload
  else
    print(vim.inspect({ 'could not attach import wrapper', importer }))
  end
else
  print('booooo ', vim.inspect(importer))
  print('Error initializing import: ',  vim.inspect(importer))
  vim.import = backup_import
end
