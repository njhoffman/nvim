
local opts = _opts or {}
opts.symbol = "│" -- symbol = "▏"
-- opts.draw = { animation = require("mini.indentscope").gen_animation.none() }
opts.try_as_border = true
require("mini.indentscope").setup(opts)
