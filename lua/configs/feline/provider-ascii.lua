local ascii = function(_, opts)
  local charcode = string.gsub(vim.fn.execute("normal! g8"), "\n", "")
  return #charcode < 3 and "0x" .. charcode or charcode or ""
  -- return '0x%B'
end
-- 	   ©'
-- 		Also see |strlen()| and |strcharlen()|.
-- 		    echo strutf16len('a')		" returns 1
-- 		    echo strutf16len('©')		" returns 1
-- 		    echo strutf16len('😊')		" returns 2
-- 		    echo strutf16len('ą́')		" returns 1
-- 		    echo strutf16len('ą́', v:true)	" returns 3
-- Enable if current window width is higher than 100

return {
  name = "ascii",
  provider = ascii,
}
