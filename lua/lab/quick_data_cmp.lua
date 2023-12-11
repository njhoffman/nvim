local cmp = require('cmp')

local source = {}

source.data = {}
source.data_lookup = {}
source.update_record = nil

source.init = function(data_path, update_fn)
  vim.defer_fn(function()
    source.update_record = update_fn
    if vim.fn.filereadable(data_path) ~= 0 then
      source.data = vim.fn.json_decode(vim.fn.readfile(data_path))
      for k, v in ipairs(source.data) do
        source.data_lookup[v.word] = k
      end
    else
      vim.notify('Error loading quick data source', 'error', { title = 'Lab.nvim' })
    end
  end, 1)
end

source.new = function()
  return setmetatable({}, { __index = source })
end

source.complete = function(self, params, callback)
  callback({ items = source.data })
end

cmp.event:on('complete_done', function(evt)
  if not evt.entry or not evt.entry.confirmed then
    return
  end
  if not evt.entry.completion_item._mod or not evt.entry.completion_item._method then
    return
  end
  local index = source.data_lookup[evt.entry.completion_item.word]
  local function update(new_data)
    source.data[index].insertText = new_data.text
  end
  source.update_record(index, evt.entry.completion_item._mod, evt.entry.completion_item._method, update)
end)

return source
