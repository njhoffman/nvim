local package_name = 'commands.testing.tipper.tip'
local packages = {}
local package_path = ''

for package_name in string.gmatch(package_name, '[^.]+') do
  package_path = package_path .. (#package_path > 0 and '.' or '') .. package_name
  vim.dbglog(package_path)
  if package.loaded[package_path] then
    table.insert(packages, package_path)
  end
end

for _, package_path in ipairs(packages) do
  vim.notify(package_path)
  -- package.loaded[package_path] = nil
  -- vim.cmd.source(package_path)
  -- require(package_path)
end
