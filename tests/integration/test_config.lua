-- Integration tests using mini.test
-- Tests that require full Neovim environment

local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_case = function()
      -- Setup before each test case
      -- Create a scratch buffer for testing
      vim.cmd("enew")
    end,
    post_case = function()
      -- Cleanup after each test case
      vim.cmd("bwipeout!")
    end,
  },
})

T["buffer_operations"] = new_set()

T["buffer_operations"]["can create and write to buffer"] = function()
  local bufnr = vim.api.nvim_get_current_buf()
  MiniTest.expect.no_error(function()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "line 1", "line 2", "line 3" })
  end)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  MiniTest.expect.equality(#lines, 3)
  MiniTest.expect.equality(lines[1], "line 1")
end

T["buffer_operations"]["can modify buffer content"] = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "original" })

  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "modified" })
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  MiniTest.expect.equality(lines[1], "modified")
end

T["window_operations"] = new_set()

T["window_operations"]["can split windows"] = function()
  local initial_wins = #vim.api.nvim_list_wins()

  vim.cmd("split")
  local after_split = #vim.api.nvim_list_wins()

  MiniTest.expect.equality(after_split, initial_wins + 1)

  vim.cmd("close")
end

T["window_operations"]["can navigate between windows"] = function()
  vim.cmd("split")
  local win1 = vim.api.nvim_get_current_win()

  vim.cmd("wincmd w")
  local win2 = vim.api.nvim_get_current_win()

  MiniTest.expect.no_equality(win1, win2)

  vim.cmd("close")
end

T["autocommands"] = new_set()

T["autocommands"]["can create and trigger autocommand"] = function()
  local triggered = false

  local group = vim.api.nvim_create_augroup("TestGroup", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      triggered = true
    end,
  })

  -- Trigger by creating new buffer
  vim.cmd("enew")

  MiniTest.expect.equality(triggered, true)

  -- Cleanup
  vim.api.nvim_del_augroup_by_id(group)
end

T["keymaps"] = new_set()

T["keymaps"]["can set and execute keymap"] = function()
  local executed = false

  vim.keymap.set("n", "<leader>test", function()
    executed = true
  end, { buffer = true })

  -- Execute the keymap
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>test", true, false, true), "x", false)

  vim.wait(100, function()
    return executed
  end)

  MiniTest.expect.equality(executed, true)
end

T["options"] = new_set()

T["options"]["can set buffer-local options"] = function()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.bo[bufnr].filetype = "lua"
  MiniTest.expect.equality(vim.bo[bufnr].filetype, "lua")

  vim.bo[bufnr].tabstop = 4
  MiniTest.expect.equality(vim.bo[bufnr].tabstop, 4)
end

T["options"]["can set window-local options"] = function()
  local winid = vim.api.nvim_get_current_win()

  vim.wo[winid].number = true
  MiniTest.expect.equality(vim.wo[winid].number, true)

  vim.wo[winid].relativenumber = true
  MiniTest.expect.equality(vim.wo[winid].relativenumber, true)
end

return T
