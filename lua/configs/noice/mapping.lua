local is_lsp_float_open = function(window_id)
  return window_id and window_id ~= 0 and vim.api.nvim_win_is_valid(window_id)
end

local scroll = function(sendkeys)
  for _, kind in ipairs({ "hover", "signature" }) do
    local message = require("noice.lsp.docs").get(kind)
    local win = message:win()
    if is_lsp_float_open(win) then
      -- vim.api.nvim_feedkeys(sendkeys, 'n', true)
      -- sendkeys = '\\<Plug>(SmoothieDownwards)'
      -- vim.fn.win_execute(win, 'normal! ' .. sendkeys)
      return true
    end
  end
  return false
end

local function escape_term_codes(str)
  return vim.api.nvim_replace_termcodes(str, true, false, true)
end

local scroll_keys = {
  page_up = escape_term_codes("kkk"),
  page_down = escape_term_codes("jjj"),
  scroll_up = escape_term_codes("<Up>"),
  scroll_down = escape_term_codes("<Down>"),
}

local function scroll_popup(key, scroll_height)
  return function()
    if not require("noice.lsp").scroll(scroll_height) then
      return key
    end
  end
end

local setup = function()
  vim.keymap.set(
    { "n", "i", "s" },
    "<M-f>",
    scroll_popup("<M-f>", 4),
    { silent = true, expr = true }
  )
  vim.keymap.set(
    { "n", "i", "s" },
    "<M-b>",
    scroll_popup("<M-b>", -4),
    { silent = true, expr = true }
  )

  -- vim.keymap.set({ 'n', 'i', 's' }, '<C-S-Up>', scroll_lsp_popups('<C-S-Up>', -2), { silent = true, expr = true })
  -- vim.keymap.set({ 'n', 'i', 's' }, '<C-S-Down>', scroll_lsp_popups('<C-S-Down>', 2), { silent = true, expr = true })

  -- Adding the following keymap, will redirect the active cmdline when pressing <S-Enter>. The cmdline stays open, so you can change the command and execute it again. When exiting the cmdline, the popup window will be focused.
  -- vim.keymap.set("c", "<S-Enter>", function()
  --   require("noice").redirect(vim.fn.getcmdline())
  -- end, { desc = "Redirect Cmdline" })
end

return { setup = setup }
