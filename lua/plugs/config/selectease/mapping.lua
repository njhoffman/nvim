-- <M-C-L><M-C-L><M-C-H><M-NL><M-C-K>
-- <M-C-Right><M-C-Left><M-C-Up><M-C-S-Down>
-- <M-C-S-Right> <M-C-S-Up><M-C-S-Left><M-C-S-Right>

local keymap = {
  select_left = {
    '<M-C-H>',
    { desc = 'select left node', plugin = 'SelectEase', category = 'Motion' },
  },
  select_right = {
    '<M-C-L>',
    {
      desc = 'select right node',
      plugin = 'SelectEase',
      category = 'Motion',
    },
  },
  select_up = {
    '<M-C-K>',
    {
      desc = 'select up node',
      plugin = 'SelectEase',
      category = 'Motion',
    },
  },
  select_down = {
    '<M-NL>',
    { desc = 'select down node', plugin = 'SelectEase', category = 'Motion' },
  },
  swap_left = {
    '<M-C-S-Left>',
    {
      desc = 'swap left node',
      plugin = 'SelectEase',
      category = 'Motion',
    },
  },
  swap_right = {
    '<M-C-S-Right>',
    { desc = 'swap right node', plugin = 'SelectEase', category = 'Motion' },
  },
  swap_up = {
    '<M-C-S-Up>',
    {
      desc = 'swap up node',
      plugin = 'SelectEase',
      category = 'Motion',
    },
  },
  swap_down = {
    '<M-C-S-Down>',
    { desc = 'swap down node', plugin = 'SelectEase', category = 'Motion' },
  },
}

return keymap

-- vim.keymap.set({ "n", "s", "i" }, "<C-A-k>", function()
--            select_ease.select_node({
--                queries = queries,
--                direction = "previous",
--                vertical_drill_jump = true,
--                -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
--                fallback = function()
--                    -- if there's no target, this function will be called
--                    select_ease.select_node({ queries = queries, direction = "previous" })
--                end,
--            })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-j>", function()
--            select_ease.select_node({
--                queries = queries,
--                direction = "next",
--                vertical_drill_jump = true,
--                -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
--                fallback = function()
--                    -- if there's no target, this function will be called
--                    select_ease.select_node({ queries = queries, direction = "next" })
--                end,
--            })
--        end, {})
--
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-h>", function()
--            select_ease.select_node({
--                queries = queries,
--                direction = "previous",
--                current_line_only = true,
--                -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
--            })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-l>", function()
--            select_ease.select_node({
--                queries = queries,
--                direction = "next",
--                current_line_only = true,
--                -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
--            })
--        end, {})
--
--        -- previous / next node that matches query
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-p>", function()
--            select_ease.select_node({ queries = queries, direction = "previous" })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-n>", function()
--            select_ease.select_node({ queries = queries, direction = "next" })
--        end, {})
--
--
--        -- Swap Nodes
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-S-k>", function()
--            select_ease.swap_nodes({
--                queries = queries,
--                direction = "previous",
--                vertical_drill_jump = true,
--
--                -- swap_in_place option. Default behavior is cursor will jump to target after the swap
--                -- jump_to_target_after_swap = false --> this will keep cursor in place after the swap
--            })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-S-j>", function()
--            select_ease.swap_nodes({
--                queries = queries,
--                direction = "next",
--                vertical_drill_jump = true,
--            })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-S-h>", function()
--            select_ease.swap_nodes({
--                queries = queries,
--                direction = "previous",
--                current_line_only = true,
--            })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-S-l>", function()
--            select_ease.swap_nodes({
--                queries = queries,
--                direction = "next",
--                current_line_only = true,
--            })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-S-p>", function()
--            select_ease.swap_nodes({ queries = queries, direction = "previous" })
--        end, {})
--        vim.keymap.set({ "n", "s", "i" }, "<C-A-S-n>", function()
--            select_ease.swap_nodes({ queries = queries, direction = "next" })
--        end, {})
--    end,
