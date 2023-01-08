local differ = {}

differ.simple = function(a, b)
  local aa = {}
  for _, v in pairs(a) do aa[v] = true end
  for _, v in pairs(b) do aa[v] = nil end
  local ret = {}
  local n = 0
  for _, v in pairs(a) do
    if aa[v] then n = n + 1
      ret[n] = v
    end
  end
  return ret
end

differ.get_diff = function(t1, t2)
  t2 = t2 or {}
  local dtable = { changed = {}, removed = {}, added = {}, total = 0 }
  for i, v in pairs(t1) do
    if t2[i] and type(v) == "table" then
      local deep_diff = differ.get_diff(t1[i], t2[i])
      if deep_diff then
        dtable[i] = deep_diff
      end
    elseif t2[i] then
      if not (t1[i] == t2[i]) then
        dtable.changed[i] = { t1[i], t2[i] }
        dtable.total = dtable.total + 1
      end
    else
      dtable.removed[i] = t1[i]
      dtable.total = dtable.total + 1
    end
  end

  for i, _ in pairs(t2) do
    if not t1[i] then
      dtable.added[i] = t2[i]
      dtable.total = dtable.total + 1
    end
  end
  return dtable
end

return differ
