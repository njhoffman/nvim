-- Flash telescope

if true then
  return
end

local opts = function(_, opts)
  if not Util.has("flash.nvim") then
    return
  end
  local function flash(prompt_bufnr)
    require("flash").jump({
      pattern = "^",
      label = { after = { 0, 0 } },
      search = {
        mode = "search",
        exclude = {
          function(win)
            return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
          end,
        },
      },
      action = function(match)
        local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        picker:set_selection(match.pos[1] - 1)
      end,
    })
  end
  opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
    mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
  })
end

--
vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "InsertEnter" }, {
  group = vim.api.nvim_create_augroup("flash_char", { clear = true }),
  callback = function(event)
    local hide = event.event == "InsertEnter" or not M.jumping
    if hide and M.state then
      M.state:hide()
    end
  end,
})

vim.on_key(function(key)
  if M.state and key == Util.ESC and (vim.fn.mode() == "n" or vim.fn.mode() == "v") then
    M.state:hide()
  end
end)
-- One thing you could do, is run jump with remote_op.restore = false. This will return a state object.
-- Once that function returns, you will be at the remote location.

-- So now you could create a buffer local mapping <enter> for example that does state:restore() and deletes the mapping again.
-- This way you could do remotely what you want and eventually press <enter> to get back to your original position.

local lib = require("modules.movement.flash.nav.lib")

local mappings = {
  {
    "*",
    function()
      require("lasterisk").search()
      lib.search_win()
    end,
    desc = "Search cword *",
  },
  {
    "*",
    function()
      require("lasterisk").search({ is_whole = false })
      vim.schedule(lib.search_win)
      return "<C-\\><C-N>"
    end,
    mode = { "x" },
    expr = true,
    desc = "Search cword *",
  },
  {
    "g*",
    function()
      require("lasterisk").search({ is_whole = false })
      lib.search_win()
    end,
    desc = "Search cword g*",
  },
  {
    "#",
    function()
      if lib.search_ref() then
        return
      end
      require("lasterisk").search()
      lib.search_win()
    end,
    desc = "Search cword (ref) # ",
  },
  {
    "#",
    function()
      require("lasterisk").search({ is_whole = false })

      vim.schedule(lib.search_win)
      return "<C-\\><C-N>"
    end,
    mode = { "x" },
    expr = true,
    desc = "Search #",
  },
  {
    "g#",
    function()
      require("lasterisk").search({ is_whole = false })
      lib.search_win()
    end,

    desc = "Search g#",
  },
}

local current_dir =
  vim.fn.expand(vim.fn.stdpath("config") .. "/lua/modules/movement/flash/keybinds")
local keybinds = {}

local function add_keybinds(keybinds_list)
  for _, keybind in ipairs(keybinds_list) do
    table.insert(keybinds, keybind)
  end
end
local function walk_dir(dir)
  local files = vim.fn.readdir(dir)
  for _, file in ipairs(files) do
    if file ~= "init.lua" then
      local path = dir .. "/" .. file
      local stat = vim.uv.fs_stat(path)
      if stat.type == "directory" then
        walk_dir(path)
      else
        local keybinds_list = require("modules.movement.flash.keybinds." .. file:gsub(".lua", ""))
        add_keybinds(keybinds_list)
      end
    end
  end
end

walk_dir(current_dir)
vim.dbglog(keybinds)

local Flash = lambda.reqidx("flash")
local cfg_2 = {
  "f",
  "t",
  "F",
  "T",
  {
    "x",
    mode = { "o", "x" },
    function()
      -- Flash: exact mode, multi window, all directions, with a backdrop
      Flash.jump({
        search = { forward = true, wrap = false, multi_window = false },
      })
    end,
    desc = "Operator Pending Flash Forward",
  },
  {
    "X",
    mode = { "o", "x" },
    function()
      require("flash").jump({
        search = { forward = false, wrap = false, multi_window = false },
      })
    end,
    desc = "Operator Pending Flash Backward",
  },

  {
    "s",
    mode = { "n" },
    function()
      -- default options: exact mode, multi window, all directions, with a backdrop
      Flash.jump({
        search = { forward = true, wrap = false, multi_window = false },
      })
    end,
    desc = "Normal Mode Flash Forward",
  },
  {
    "S",
    mode = { "n" },
    function()
      Flash.jump({
        search = { forward = false, wrap = false, multi_window = false },
      })
    end,
    desc = "Normal Mode Flash Backward",
  },
  --
  {
    "S",
    mode = { "o", "x" },
    function()
      Flash.treesitter()
    end,
    desc = "Operator Pending Flash Treesitter",
  },

  --  ╭────────────────────────────────────────────────────────────────────╮
  --  │         Word Jumpers                                               │
  --  ╰────────────────────────────────────────────────────────────────────╯
  {
    "?",
    mode = { "n" },
    function()
      Flash.jump({ mode = "fuzzy" })
    end,
    desc = "Fuzzy search",
  },
  {
    "?",
    mode = { "o" },
    function()
      Flash.remote({ mode = "select" })
    end,
    desc = "Fuzzy Sel",
  },
  {
    "?",
    mode = "x",
    function()
      Flash.jump({ mode = "select" })
    end,
    desc = "Fuzzy Sel",
  },
  "/",
  {
    "<leader>W",
    mode = { "n", "o", "x" },
    function()
      Flash.jump({
        pattern = vim.fn.expand("<cword>"),
      })
    end,

    desc = "Flash Current word",
  },

  {
    "<S-cr>",

    mode = { "n", "o", "x" },
    function()
      ---@param opts Flash.Format
      local function format(opts)
        -- always show first and second label
        return {
          { opts.match.label1, "FlashMatch" },
          { opts.match.label2, "FlashLabel" },
        }
      end

      Flash.jump({
        search = { mode = "search" },
        label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
        pattern = [[\<]],
        action = function(match, state)
          state:hide()
          Flash.jump({
            search = { max_length = 0 },
            highlight = { matches = false },
            label = { format = format },
            matcher = function(win)
              -- limit matches to the current label
              return vim.tbl_filter(function(m)
                return m.label == match.label and m.win == win
              end, state.results)
            end,
            labeler = function(matches)
              for _, m in ipairs(matches) do
                m.label = m.label2 -- use the second label
              end
            end,
          })
        end,
        labeler = function(matches, state)
          local labels = state:labels()
          for m, match in ipairs(matches) do
            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
            match.label2 = labels[(m - 1) % #labels + 1]
            match.label = match.label1
          end
        end,
      })
    end,

    desc = "Flash Current Screen",
  },

  {
    --  TODO: (vsedov) (21:59:14 - 24/06/23): Return this to normal if this is not viable
    "<c-s>",
    mode = { "n", "o", "x" },
    function()
      Flash.jump({
        search = {
          multi_window = true,
          mode = "textcase",
        },
      })
    end,
    desc = "Flash Current buffer",
  },
  {
    "<c-s>",
    mode = { "c" },
    function()
      Flash.toggle()
    end,
    desc = "Toggle Flash Search",
  },
  {
    "\\/",
    mode = { "n", "x", "o" },
    function()
      Flash.jump({
        pattern = ".", -- initialize pattern with any char
        search = {
          mode = function(pattern)
            -- remove leading dot
            if pattern:sub(1, 1) == "." then
              pattern = pattern:sub(2)
            end
            -- return word pattern and proper skip pattern
            return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
          end,
        },
        -- select the range
        jump = { pos = "range" },
      })
    end,
    desc = "Select any word",
  },
}
local lib = require("modules.movement.flash.nav.lib")
local Flash = lambda.reqidx("flash")

local cfg_3 = {
  --  ╭────────────────────────────────────────────────────────────────────╮
  --  │ lsp                                                                │
  --  ╰────────────────────────────────────────────────────────────────────╯
  --  'gt' - go to definition
  -- 'gT' - go to type definition
  -- 'gr' - references
  -- 'gd' - go to declaration
  {
    "g;",
    -- https://github.com/folke/flash.nvim/discussions/79
    function()
      local prev_timeout = vim.opt.timeout

      vim.opt.timeout = false

      Flash.jump({
        action = function(match, state)
          state:hide()

          local row, col = unpack(vim.api.nvim_win_get_cursor(0))

          vim.api.nvim_set_current_win(match.win)
          vim.api.nvim_win_set_cursor(match.win, match.pos)

          local key = vim.api.nvim_replace_termcodes("<Ignore>" .. "g", true, true, true)

          vim.api.nvim_feedkeys(key, "i", false)

          vim.schedule(function()
            vim.api.nvim_win_set_cursor(match.win, { row, col })
            vim.opt.timeout = prev_timeout
            require("flash.jump").restore_remote(state)
          end)
        end,
        search = {
          max_length = 2,
        },
        label = {
          before = { 0, 2 },
          after = false,
        },
      })
    end,
    desc = "Go to definition on jump",
  },
  {
    "<c-;>",
    desc = "Hover",
    function()
      Flash.jump({ mode = "hover" })
    end,
  },
  --  ──────────────────────────────────────────────────────────────────────
  {
    "D",
    mode = { "n" },
    function()
      vim.cmd.Lspsaga("show_cursor_diagnostics")
    end,
    desc = "Show diagnostics at target, without changing cursor position",
  },
  {
    ";d",
    mode = { "n" },
    function()
      lib.flash_diagnostics({
        action = function()
          require("wtf").ai()
        end,
      })
    end,
    desc = "Debug diagnostic with AI",
  },
  {
    ";D",
    mode = { "n" },
    function()
      lib.flash_diagnostics({
        action = function()
          require("wtf").search()
        end,
      })
    end,
    desc = "Search diagnostic with Google",
  },
  --  ──────────────────────────────────────────────────────────────────────
  {
    "<leader>s",
    mode = { "n" },
    lib.flash_references,
    desc = "Flash Lsp References",
  },
  {
    "dD",
    function()
      lib.flash_diagnostics({
        action = require("actions-preview").code_actions,
      })
    end,
    desc = "Diagnostics + Code Action",
  },
}

local lib = require("modules.movement.flash.nav.lib")
local Flash = lambda.reqidx("flash")

local cfg_4 = {

  --  ╭────────────────────────────────────────────────────────────────────╮
  --  │         Window Jump and jump lines                                 │
  --  ╰────────────────────────────────────────────────────────────────────╯

  {
    "<c-p>",
    mode = { "n" },
    lib.jump_windows,
    desc = "Jump Windows",
  },
  {
    "<c-e>",
    mode = { "n" },
    -- lib.flash_lines,
    function()
      require("flash").jump({
        search = { mode = "search", max_length = 0 },
        highlight = {
          label = { after = { 0, 0 } },
          matches = false,
        },
        pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
      })
    end,
    desc = "Jump Lines",
  },

  --  ╭────────────────────────────────────────────────────────────────────╮
  --  │         Fold                                                       │
  --  ╰────────────────────────────────────────────────────────────────────╯
  {
    "z<cr>",
    function()
      Flash.treesitter()
      vim.cmd("normal! Vzf")
    end,
    mode = { "n" },
    silent = true,
    desc = "God Fold",
  },
}

local Flash = lambda.reqidx("flash")
local lib = require("modules.movement.flash.nav.lib")
local gen_dyn_matcher = function(gen_query, check)
  if type(gen_query) ~= "function" then
    vim.notify(
      "@param{gen_query} in function{gen_dyn_matcher} must be a function that returns the treesitter query string",
      vim.log.levels.ERROR
    )
    return
  end
  check = check or "full"

  return function(win, state)
    local wininfo = vim.fn.getwininfo(win)[1]
    local wintop = wininfo.topline - 1 ---@type number
    local winbot = wininfo.botline + 1 ---@type number
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_filetype = vim.fn.getbufvar(buf, "&filetype") or "lua"
    local pattern_string = state.pattern.pattern

    local ranges = {} ---@type TSNode[]
    local matches = {} ---@type Flash.Match[]

    local parser = vim.treesitter.get_parser(buf)
    local syntax_tree = parser:parse()[1]
    local root = syntax_tree:root()
    local search_query = vim.treesitter.query.parse(buf_filetype, gen_query(pattern_string))

    for _, node, _ in search_query:iter_captures(root, buf, wintop, winbot) do
      table.insert(ranges, { node:range() })
    end

    for _, range in ipairs(ranges) do
      ---@type Flash.Match
      local match = {
        pos = { range[1] + 1, range[2] },
        end_pos = { range[3] + 1, range[4] - 1 },
      }
      local start_in_view = match.pos[1] > wintop and match.pos[1] < winbot
      local end_in_view = match.end_pos[1] > wintop and match.end_pos[1] < winbot
      local fully_in_view = start_in_view and end_in_view

      local test ---@type boolean
      if check == "end" then
        test = end_in_view
      end
      if check == "start" then
        test = start_in_view
      end
      if check == "full" then
        test = fully_in_view
      end

      if test then
        table.insert(matches, match)
      end
    end

    return matches
  end
end
local basic_query = function(pattern_string)
  return ([[
  (
  (identifier) @capture
  (#match? @capture "^%s")
  )
  ]]):format(pattern_string)
end
local O = {
  goto_prefix = ";;",
  goto_next = ";;",
  goto_previous = ";;",
  goto_next_outer = "]]",
  goto_previous_outer = "[[",
  goto_next_end = "<leader>]", -- ")",
  goto_previous_end = "<leader>[", -- "(",
  goto_next_outer_end = "<leader>]]", -- "))",
  goto_previous_outer_end = "<leader>[[", -- "((",
  select = "&",
  select_dynamic = "m",
  select_remote = "r",
  select_remote_dynamic = "ir",
  select_outer = "<M-S-7>", -- M-&
  select_next = "in",
  select_previous = "iN",
  select_next_outer = "an",
  select_previous_outer = "aN",
}

O.goto_prev = O.goto_previous
O.select_prev = O.select_previous

return {
  --  ╭────────────────────────────────────────────────────────────────────╮
  --  │         Remote Jumps  and treesitter bindings                      │
  --  ╰────────────────────────────────────────────────────────────────────╯

  {
    "<cr>",
    mode = { "o", "x" },
    function()
      Flash.remote()
    end,
    desc = "Remote Jump",
  },
  {
    "R",
    function()
      Flash.treesitter_search({
        label = { before = true, after = true, style = "inline" },
        remote_op = { restore = true },
      })
    end,
    mode = { "n" },
    desc = "Treesitter Search | show labeled treesitter nodes around the search matches",
  },
  {
    "M",
    function()
      Flash.treesitter_search({
        label = { before = true, after = true, style = "inline" },
        remote_op = { restore = true },
      })
    end,
    mode = { "x", "o" },
    desc = "Treesitter Search | show labeled treesitter nodes around the search matches",
  },

  {
    O.select_remote_dynamic,
    mode = { "o", "x" },
    desc = "Remote Node",
    function()
      require("flash").jump({ mode = "remote_ts" })
    end,
  },
  {
    O.goto_next .. O.select_remote_dynamic,
    mode = { "o", "x" },
    function()
      require("flash").jump({ mode = "remote_ts", treesitter = { starting_from_pos = true } })
    end,
    desc = "Select node",
  },
  {
    O.goto_prev .. O.select_remote_dynamic,
    mode = { "o", "x" },
    function()
      require("flash").jump({ mode = "remote_ts", treesitter = { ending_at_pos = true } })
    end,
    desc = "Select node",
  },
  {
    O.goto_next .. O.select_remote_dynamic,
    mode = "n",
    function()
      require("flash").jump({
        mode = "remote_ts",
        treesitter = { end_of_node = true },
        jump = { pos = "end" },
      })
    end,
    desc = "Jump to end of node",
  },
  {
    O.goto_prev .. O.select_remote_dynamic,
    mode = "n",
    function()
      require("flash").jump({
        mode = "remote_ts",
        treesitter = { start_of_node = true },
        jump = { pos = "start" },
      })
    end,
    desc = "Jump to start of node",
  },
  {
    O.goto_prefix .. "w", -- TODO: stop verbs from being labels
    -- TODO: allow searching continuations
    function()
      require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cword>") })
    end,
    desc = "Flash <cword>",
  },
  {
    O.goto_prefix .. "W",
    function()
      require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cWORD>") })
    end,
    desc = "Flash <cWORD>",
  },
  {
    O.goto_prefix .. "n",
    function()
      require("flash").jump({ continue = true })
    end,
    desc = "Continue Flash",
  },
  {
    "rix", -- TODO: better keymap?
    -- FIXME: its broken??
    mode = { "x", "n" },
    desc = "Exchange <motion1> with <node>",
    function()
      lib.swap_with({ mode = "remote_ts" })
    end,
  },
  -- TODO: y<motion><something><leap><motion>
  {
    "rx",
    mode = { "n", "x" },
    desc = "Exchange <motion1> with <motion2>",
    -- TODO: use leap?
    function()
      lib.swap_with()
    end,
  },
  {
    "rxx",
    mode = { "n", "x" },
    desc = "Exchange V<motion1> with V<motion2>",
    -- TODO: use leap?
    function()
      lib.swap_with({ exchange = {
        visual_mode = "V",
      } })
    end,
  },
  {
    ";R",
    mode = { "n" },
    desc = "Remote Replace",
    function()
      vim.api.nvim_feedkeys(";r", "m", false)

      vim.schedule(function()
        require("flash").jump({ mode = "remote_ts" })
      end)
    end,
  },
  -- TODO: Copy there, Paste here
  { -- FIXME: this
    ";ry",
    mode = { "x", "n" },
    desc = "Replace with <remote-motion>",
    function()
      lib.swap_with({ exchange = { not_there = true } })
    end,
  },
  { -- FIXME: this
    ";rd",
    mode = { "x", "n" },
    desc = "Replace with d<remote-motion>",
    function()
      lib.swap_with({ exchange = { not_there = true } })
    end,
  },
  { -- FIXME: this
    ";rc",
    mode = { "x", "n" },
    desc = "Replace with c<remote-motion>",
    function()
      lib.swap_with({ exchange = { not_there = true } })
    end,
  },
  { -- FIXME: this
    ";rY",
    mode = { "n" },
    desc = "Replace with <node>",
    function()
      lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
    end,
  },
  { -- FIXME: this
    ";rD",
    mode = { "x", "n" },
    desc = "Replace with d<node>",
    function()
      lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
    end,
  },
  { -- FIXME: this
    ";rC",
    mode = { "x", "n" },
    desc = "Replace with c<node>",
    function()
      lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
    end,
  },
  {
    "u", -- unit textobject
    mode = { "o", "x" },
    function()
      Flash.treesitter({
        filter = function(matches)
          ---@param m Flash.Match.TS
          -- for all matches,  match[n+1] should use previous match[n] label. Do in reverse order, to prevet copying first label to all matches
          for i = #matches, 2, -1 do
            matches[i].label = matches[i - 1].label
          end
          table.remove(matches, 1) -- remove first match, as it is same as word under cursor thus redundant with word motion
        end,
        label = {
          rainbow = {
            enabled = true,
          },
        },
      })
    end,
  },
  {
    ";rw",
    function()
      Flash.jump({
        matcher = gen_dyn_matcher(basic_query),
        -- select the range
        jump = { pos = "range" },
      })
    end,
    mode = { "n" },
  },
}
--
--
