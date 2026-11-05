-- Shows a random tip, or one from a chosen category.

local tips_list = require("core.commands.tips.list")

local nl = "\n   ➜ "
local parse_tip_args = function(args)
  local custom_keys = vim.tbl_keys(tips_list)
  local rand_cat = custom_keys[math.random(1, #custom_keys)]
  if args and #args > 0 then
    if tips_list[args[1]] then
      rand_cat = args[1]
    else
      vim.notify("Invalid category: " .. args[1], 3)
    end
  end
  local rand_tip = tips_list[rand_cat][math.random(1, #tips_list[rand_cat])]
  if args and #args > 1 then
    if tips_list[rand_cat][tonumber(args[2])] then
      rand_tip = tips_list[rand_cat][tonumber(args[2])]
    else
      vim.notify("Invalid tip index: " .. args[2] .. " (" .. rand_cat .. ")", 3)
    end
  end
  return rand_cat, rand_tip
end

local get_tip = function(cmd)
  local rand_cat, rand_tip = parse_tip_args(cmd.fargs)
  if type(rand_tip) == "table" then
    rand_tip = vim.fn.join(rand_tip, nl)
  end
  vim.notify(rand_tip, 2, {
    title = rand_cat,
    -- render = 'simple-notitle',
    -- filetype = 'pandoc.markdown',
    filetype = "markdown",
    timeout = 8000,
  })
end

local complete = function(query, cmd)
  if query == "" then
    local cmds = vim.tbl_keys(tips_list)
    return cmds
  end
end

return {
  get_tip = get_tip,
  complete = complete,
}
