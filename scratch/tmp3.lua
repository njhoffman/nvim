local scan = require('plenary.scandir')
function find(self, fn)
  return coroutine.wrap(function()
    for f in scan(self) do
      if f ~= '.' and f ~= '..' then
        local _f = self .. '/' .. f
        if not fn or fn(_f) then
          coroutine.yield(_f)
        end
        if lfs.attributes(_f, 'mode') == 'directory' then
          for n in find(_f, fn) do
            coroutine.yield(n)
          end
        end
      end
    end
  end)
end

for f in
  find(vim.fn.getcwd(), function(self)
    return self:match('^%.prettierrc')
  end)
do
  print(f)
end

--   vim.dbglog(utils.has_file({ '.prettierrc', '.prettierrc.js' }))
--   return utils.has_file({ '.prettierrc.js', '.prettierrc', '.prettierrc.json' })
