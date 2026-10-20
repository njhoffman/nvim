local recall = require("recall")

recall.setup({
  -- sign = "",
  -- sign_highlight = "@comment.note",
  sign = "",
  sign_highlight = "RecallMark",
  -- TODO: make more keybindings and commands for filters
  filters = {
    -- Read more about `exrc`: `:h exrc`.
    same_project = false,
    same_file = false,
    same_filetype = false,
    only_loaded = false,
  },
  telescope = {
    autoload = true,
    mappings = {
      unmark_selected_entry = {
        normal = "dd",
        insert = "<M-d>",
      },
    },
  },

  wshada = false,
})

-- stylua: ignore
--  
local mappings = {
  { "mm", recall.toggle,           "  marks toggle" },
  { "mn", recall.goto_next,        "  marks  go to next " },
  { "mp", recall.goto_prev,        "  marks go to prev " },
  { "mt", ":Telescope recall<CR>", "  marks open telescope" },
  { "md", recall.clear,            "  marks remove at cursor" },
  { "mx", recall.clear,            "  marks remove cursor" },
  { "mX", recall.clear,            "  marks clear all" },
}

local map = require("mapper").map
local create_mappings = function()
  for _, mapping in ipairs(mappings) do
    map("n", mapping[1], mapping[2], { desc = mapping[3] })
  end
end

create_mappings()

-- -- In your Neovim configuration:
-- vim.opt.exrc = true
-- vim.opt.secure = true
--
-- -- /path/to/your/project/.nvim.lua:
-- vim.opt.shadafile = ".vim/project.shada"
--
-- -- Optionally, in the project's .gitignore or ~/.config/git/ignore:
-- .vim
