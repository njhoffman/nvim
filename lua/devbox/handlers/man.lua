local man_handler = function(done, provider)
  local word = vim.fn.expand('<cword>') or ''
  local result = { summary = ' man ', hl = 'DebugMsg', name = provider.name, content = '' }
  if string.len(word) == 0 then
    done(provider, result)
  end

  local output = vim.fn.system('man ' .. word)
  if string.match(output, 'No manual entry for ') then
    done(provider, result)
  else
    result.summary = ' man  ' .. word .. ' ' .. #output .. ' lines'
    result.hl = 'MoreMsg'
    done(provider, result)
  end
  done(provider, result)
end

return { handler = man_handler }
