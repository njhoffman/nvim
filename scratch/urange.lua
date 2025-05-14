local buffer_commands = function()
  local Buffer = require("u.buffer")
  local buf = Buffer.current()
  buf:line_count() -- the number of lines in the current buffer
  buf:get_option("...")
  -- buf:set_option("...", ...)
  buf:get_var("...")
  -- buf:set_var("...", ...)
  buf:all() -- returns a Range representing the entire buffer
  buf:is_empty() -- returns true if the buffer has no text
  buf:append_line("...")
  buf:line0(0) -- returns a Range representing the first line in the buffer
  buf:line0(-1) -- returns a Range representing the last line in the buffer
  buf:lines(0, 1) -- returns a Range representing the first two lines in the buffer
  buf:lines(1, -2) -- returns a Range representing all but the first and last lines of a buffer
  buf:text_object("iw") -- returns a Range representing the text object 'iw' in the give buffer
end

local range_commands = function()
  -- get the first line in a buffer:
  local Range = require("u.range")
  Range.from_line(0, 0)

  -- Text Objects (any text object valid in your configuration is supported):
  -- get the word the cursor is on:
  Range.from_text_object("iw")
  -- get the WORD the cursor is on:
  Range.from_text_object("iW")
  -- get the "..." the cursor is within:
  Range.from_text_object('a"')

  -- Get the currently visually selected text:
  -- NOTE: this does NOT work within certain contexts; more specialized utilities are more appropriate in certain circumstances
  Range.from_vtext()
end

local setup_commands = function()
  local Range = require("u.range")

  -- Get the operated on text obtained from a motion:
  -- (HINT: use the opkeymap utility to make this less verbose)
  --
  function MyOpFunc(ty)
    local range = Range.from_op_func(ty)
    -- do something with the range
  end

  -- Try invoking this with: `<Leader>toaw`, and the current word will be the context:
  vim.keymap.set("<Leader>to", function()
    vim.g.operatorfunc = "v:lua.MyOpFunc"
    return "g@"
  end, { expr = true })

  -- When executing commands in a visual context, getting the selected text has to be done differently:
  vim.api.nvim_create_user_command("MyCmd", function(args)
    local range = Range.from_cmd_args(args)
    if range == nil then
    -- the command was executed in normal mode
    else
      -- ...
    end
  end, { range = true })
end

local setup_mappings = function()
  local opkeymap = require("u.opkeymap")
  -- invoke this function by typing, for example, `<leader>riw`:
  -- `range` will contain the bounds of the motion `iw`.
  opkeymap("n", "<leader>r", function(range)
    print(range:text()) -- Prints the text within the selected range
  end)
end

buffer_commands()
range_commands()
setup_commands()
setup_mappings()
