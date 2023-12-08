local ascii = function(_, opts)
  return '0x%B'
end

-- Enable if current window width is higher than 100
return {
  name = 'ascii',
  provider = ascii,
}
