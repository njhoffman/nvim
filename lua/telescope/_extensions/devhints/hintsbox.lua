local config = {
  window = {
    width = "40%",
    height = "40%",
  },
}

local scroll_float = function(mapping, winnr)
  if winnr and winnr ~= 0 and vim.api.nvim_win_is_valid(winnr) then
    local scroll_up = vim.api.nvim_replace_termcodes("<Up>", true, false, true)
    if mapping == scroll_up then
      local linenr = vim.api.nvim_win_get_cursor(winnr)[1]
      local scrolloff = vim.api.nvim_get_option("scrolloff")
      local winheight = vim.api.nvim_win_get_height(winnr)
      if linenr > (winheight - scrolloff) then
        vim.fn.win_execute(winnr, "normal! " .. mapping)
      end
    else
      vim.fn.win_execute(winnr, "normal! " .. mapping)
    end
  end
end

local delete_keymaps = function()
  vim.keymap.del({ "n" }, "q")
  vim.keymap.del({ "n", "i" }, "<C-Up>")
  vim.keymap.del({ "n", "i" }, "<C-Down>")
end

local init_aucommands = function(winnr)
  vim.api.nvim_create_augroup("DevHints", { clear = true })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(ev)
      if ev.match == tostring(winnr) then
        vim.api.nvim_del_augroup_by_name("DevHints")
        delete_keymaps()
      end
    end,
    group = "DevHints",
  })
end

local init_keymaps = function(winnr)
  vim.keymap.set({ "n" }, "q", function()
    vim.api.nvim_win_close(winnr, true)
  end, { noremap = true, silent = true })

  local scroll_up = vim.api.nvim_replace_termcodes("<Up>", true, false, true)
  local scroll_down = vim.api.nvim_replace_termcodes("<Down>", true, false, true)

  vim.keymap.set({ "i", "n" }, "<C-Up>", function()
    scroll_float(scroll_up, winnr)
  end, { noremap = true, silent = true })
  vim.keymap.set({ "i", "n" }, "<C-Down>", function()
    scroll_float(scroll_down, winnr)
  end, { noremap = true, silent = true })
end

local update_preview = function(bufnr, topics)
  -- topic[1] = Category, topic[2] = Topic, topic[3] = Line numbers
  local lines = {}
  for _, topic in ipairs(topics) do
    local topic_lines = topic.value[4]
    for _, line in ipairs(topic_lines) do
      table.insert(lines, line)
    end
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end

local get_dimensions = function(topics, parent)
  local window = { height = 0, width = 0 }
  for _, topic in ipairs(topics) do
    local topic_lines = topic.value[4]
    for _, line in ipairs(topic_lines) do
      window.width = #line > window.width and #line or window.width
      window.height = window.height + 1
    end
  end

  -- TODO: handle pixels and perentile
  local configWidth = string.gsub(config.window.width, "%%", "")
  local maxWidth = math.floor((tonumber(configWidth) / 100) * parent.w)
  local configHeight = string.gsub(config.window.height, "%%", "")
  local maxHeight = math.floor((tonumber(configHeight) / 100) * parent.h)
  vim.dbglog(window, configHeight, maxHeight, parent.h)
  -- window.height = window.height > maxHeight and maxHeight or window.height
  window.height = 14
  window.width = window.width > maxWidth and maxWidth or window.width
  window.scrolloff = 7
  -- local scrolloff = get_height("50%")
  -- if scrolloff > 7 then
  --   scrolloff = 7
  -- end
  -- vim.api.nvim_set_option_value("scrolloff", scrolloff, {})

  return window
end

local init = function(topics)
  local parent = {
    w = vim.api.nvim_win_get_width(0),
    h = vim.api.nvim_win_get_height(0),
  }

  local window = get_dimensions(topics, parent)
  vim.dbglog(window)
  local winnr = vim.api.nvim_open_win(0, false, {
    relative = "win",
    height = window.height,
    width = window.width,
    focusable = false,
    border = "rounded",
    bufpos = { 0, 0 },
    row = parent.h,
    col = parent.w,
    anchor = "SE",
    zindex = 2,
    style = "minimal",
  })
  vim.api.nvim_win_set_option(winnr, "winblend", 20)

  init_aucommands(winnr)
  init_keymaps(winnr)

  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_win_set_buf(winnr, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")

  update_preview(bufnr, topics)

  vim.diagnostic.reset(nil, bufnr)

  local scrolloff = vim.api.nvim_get_option("scrolloff")
  local scroll_down = vim.api.nvim_replace_termcodes("<Down>", true, false, true)
  if window.height > scrolloff then
    for _ = 1, window.height - scrolloff do
      scroll_float(scroll_down, winnr)
    end
  end
end

return { init = init }
