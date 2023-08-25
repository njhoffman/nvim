local function round(x, n)
  n = math.pow(10, n or 0)
  x = x * n
  if x >= 0 then
    x = math.floor(x + 0.5)
  else
    x = math.ceil(x - 0.5)
  end
  return x / n
end

local function roundString(x, n)
  n = n or 0
  return string.format('%.' .. n .. 'f', tostring(round(x, n)))
end

return { round = round, roundString = roundString }
