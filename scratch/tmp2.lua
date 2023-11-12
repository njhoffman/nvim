local clear_local = function(state)
  for _, provider in ipairs(state.providers) do
    for _, key in ipairs(vim.tbl_keys(provider)) do
      if string.match(key, '^_.*') then
        provider[key] = nil
      end
    end
  end
  state.enabled = {}
end

local state = {
  providers = {
    {
      one = 'val one',
      two = 'val two',
      _local_one = 'local one',
      _local_two = 'local two',
    },
  },
}

clear_local(state)
vim.dbglog('state', state)
