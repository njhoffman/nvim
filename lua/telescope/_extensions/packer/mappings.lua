local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local mappings = function(prompt_bufnr, map)
  actions.select_default:replace(function()
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd(string.format(":e %s", selection.readme))
  end)

  local Job = require("plenary.job")
  local open_online = function()
    local selection = action_state.get_selected_entry()
    actions._close(prompt_bufnr)

    local cmd = vim.fn.has("win32") == 1 and "explorer" or vim.fn.has("mac") == 1 and "open" or "xdg-open"
    local url = vim.fn.trim(vim.fn.system(string.format("git -C %s ls-remote --get-url", selection.path)))
    Job:new({ command = cmd, args = { url } }):start()
  end

  local builtin = require("telescope.builtin")

  local open_finder = function()
    local selection = action_state.get_selected_entry()
    actions._close(prompt_bufnr, true)
    builtin.find_files({ cwd = selection.path })
  end

  local open_browser = function()
    local ok, file_browser = pcall(require, "telescope._extensions.file_browser")
    if not ok then
      vim.notify(
        "nvim-telescope/telescope-file-browser.nvim is required to use this action",
        vim.log.levels.ERROR,
        { title = "Telescope" }
      )
      return
    end
    local selection = action_state.get_selected_entry()
    actions._close(prompt_bufnr, true)
    file_browser.exports.file_browser({ cwd = selection.path })
  end

  local open_grep = function()
    local selection = action_state.get_selected_entry()
    actions._close(prompt_bufnr, true)
    builtin.live_grep({ cwd = selection.path })
  end

  map("i", "<C-o>", open_online)
  map("i", "<<C-Space>>", open_finder)
  map("i", "<C-g>", open_browser)
  map("i", "<C-e>", open_grep)
  return true
end

return mappings
