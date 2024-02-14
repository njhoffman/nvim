local Hydra = require('hydra')

local function hydra_git()
  local function diffmaster()
    local branch = 'origin/master'
    local master = vim.fn.systemlist('git rev-parse --verify develop')
    if not master[1]:find('^fatal') then
      branch = 'origin/develop'
    else
      master = vim.fn.systemlist('git rev-parse --verify master')
      if not master[1]:find('^fatal') then
        branch = 'origin/master'
      else
        master = vim.fn.systemlist('git rev-parse --verify main')
        if not master[1]:find('^fatal') then
          branch = 'origin/main'
        end
      end
    end
    local current_branch = vim.fn.systemlist('git branch --show-current')[1]
    -- git rev-list --boundary feature/FDEL-3386...origin/main | grep "^-"
    -- local cmd = string.format([[git rev-list --boundary %s...%s | grep "^-"]], current_branch, branch)
    local cmd = string.format([[git merge-base %s %s ]], branch, current_branch)
    local hash = vim.fn.systemlist(cmd)[1]

    if hash then
      vim.notify('DiffviewOpen ' .. hash)
      vim.cmd('DiffviewOpen ' .. hash)
    else
      vim.notify('DiffviewOpen ' .. branch)
      vim.cmd('DiffviewOpen ' .. branch)
    end
  end
  local hint = [[
 _d_iffView   _s_tage hunk     diff_M_aster    file_H_istory _S_tageBufr
 hunkq_f_     _u_nstage hunk   _p_ view hunk   _B_lameFull   _l_og
 buff_D_iff   _g_ diff staged  _m_erge        _x_ show del󰛌 _c_onflict
 _/_ show base resetHun_k_     _r_eset buffer   _<Enter>_ Neo  _q_uit
]]
  --  _b_uf gutter _F_iff buf       _U_stage        _G_staged
  local gitsigns = require('gitsigns')
  -- local vgit = require("vgit")
  local function gitsigns_visual_op(op)
    return function()
      return gitsigns[op]({ vim.fn.line('.'), vim.fn.line('v') })
    end
  end
  Hydra({
    hint = hint,
    config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
        position = 'bottom',
        float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          border = 'rounded',
          style = 'minimal',
          focusable = false,
          noautocmd = true,
        },
      },
      on_enter = function()
        vim.bo.modifiable = false
        -- gitsigns.toggle_signs(true)
        gitsigns.toggle_linehl(true)
      end,
      on_exit = function()
        -- gitsigns.toggle_signs(false)
        gitsigns.toggle_linehl(false)
        gitsigns.toggle_deleted(false)
        vim.cmd('echo') -- clear the echo area
      end,
    },
    mode = { 'n', 'x' },
    body = '<Space>g',
    -- stylua: ignore start
    heads = {
      { 'd', ':DiffviewOpen<CR>', { silent = true, exit = true } },
      { 'M', diffmaster, { silent = true, exit = true } },
      { 'H', ':DiffviewFileHistory<CR>', { silent = true, exit = true } },
      { 's', gitsigns.stage_hunk, { silent = true } },
      { 'u', gitsigns.undo_stage_hunk, { exit = true } },
      { 'r', gitsigns.reset_buffer, { exit = true } },
      { 'k', gitsigns.reset_hunk, { exit = true } },
      { 'S', gitsigns.stage_buffer, { exit = true } },
      { 'p', gitsigns.preview_hunk, { exit = true } },
      { 'x', gitsigns.toggle_deleted, { nowait = true } },
      { 'D', gitsigns.diffthis },
      -- { "b", gitsigns.blame_line },
      {
        'f',
        function()
          gitsigns.setqflist('all')
        end,
        { exit = true },
      },
      { 'g', gitsigns.setqflist, { exit = true } },
      {
        'B',
        function()
          gitsigns.blame_line({ full = true })
        end,
        { exit = true },
      },
      {
        'd',
        gitsigns.toggle_deleted,
        { nowait = true, desc = 'show deleted lines', exit = true },
      },
      -- fugitive
      -- { "l", "Git log --oneline --decorate --graph --all<CR>" },
      { 'l', 'Flogsplit<CR>' },
      { 'm', ':Git mergetool<CR>' },
      { 'c', ':GitConflictListQf<CR>' },
      { '/', gitsigns.show, { exit = true } }, -- show the base of the file

      -- vgit
      -- { "b", vgit.buffer_gutter_blame_preview, { exit = true } },
      -- { "F", vgit.buffer_diff_preview, { exit = true } },
      -- { "g", vgit.buffer_diff_staged_preview, { exit = true } },
      -- { "P", vgit.project_staged_hunks_preview },
      -- { "f", vgit.project_hunks_qf },
      -- { "U", vgit.buffer_unstage },
      -- { "G", vgit.buffer_diff_staged_preview },

      { '<Enter>', '<cmd>Neogit<CR>', { exit = true } },
      { 'q', nil, { exit = true, nowait = true } },
    },
  })
end

local hint_telescope = [[
 _g_itfiles   _r_eg       _j_umps      _b_uffers       _y_ neo󰏢
 _z_ Z        _p_roject    _w_ grep     _/_ searchhist  _d_umbjump
 _C_lap 👏    co_m_mands   buf_l_ines   _s_ colo🌈      _c_mdhist
 _o_ldfiles   _k_eys 🔑    _f_ 📁       _h_arpoon       _M_marks
               _<Enter>_🔭              _q_uit
]]

local telescope = require('telescope')
Hydra({
  hint = hint_telescope,
  config = {
    color = 'pink',
    invoke_on_body = true,
    hint = {
      position = 'bottom',
      float_opts = {
        -- row, col, height, width, relative, and anchor should not be
        -- overridden
        border = 'rounded',
        style = 'minimal',
        focusable = false,
        noautocmd = true,
      },
    },
  },
  mode = 'n',
  body = '<Leader>f',
  heads = {
    { 'g', ':Telescope git_files<CR>', { exit = true } },
    { 'r', ':Telescope registers<CR>', { exit = true } },
    { 'b', ':Telescope buffers<CR>', { exit = true } },
    { 'j', ":lua require'utils.telescope'.jump()<CR>", { exit = true } },
    { 'z', telescope.extensions.zoxide.list },
    { 'p', telescope.extensions.projects.projects },
    { 'f', ":lua require'utils.telescope'.folder_search()<CR>", { exit = true } },
    { 'w', ':Telescope grep_string<CR>', { exit = true } },
    { '/', ':Telescope search_history<CR>', { exit = true } },
    { 'c', ':Telescope command_history<CR>', { exit = true } },
    { 'C', ':Clap<CR>', { exit = true } },
    { 'm', ':Telescope commands<CR>', { exit = true } },
    { 'o', ':Telescope oldfiles<CR>', { exit = true } },
    { 'k', ':Telescope keymaps<CR>', { exit = true } },
    { 'h', ':Telescope harpoon marks<CR>', { exit = true } },
    { 'd', ':Clap dumb_jump<CR>', { exit = true } },
    { 'l', require('telescope.builtin').current_buffer_fuzzy_find, { exit = true } },
    { 's', ':Telescope colorscheme<CR>', { exit = true } },
    { 'M', require('telescope.builtin').marks },
    { 'o', ':Clap history<CR>', { exit = true } },
    { 'y', ':Telescope neoclip<CR>', { exit = true } },
    { '<Enter>', '<cmd>Telescope<CR>', { exit = true } },
    { 'q', nil, { exit = true, nowait = true } },
  },
})

-- local window_hint = [[
--  ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
--  ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
--  ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally
--  _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
--  ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
--  focus^^^^^^  window^^^^^^  ^_=_: equalize^   _z_: maximize
--  ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
--  _b_: choose buffer
-- ]]
-- local cmd = require('hydra.keymap-util').cmd
-- local pcmd = require('hydra.keymap-util').pcmd
--
Hydra({
  name = 'resize',
  mode = 'n',
  body = '<C-w>',
  heads = {
    { '=', '<C-w>+', { desc = 'equalize' } },
    { '+', '<C-w>+', { desc = 'res +1' } },
    { '-', '<C-w>-', { desc = 'res -1' } },
    { '>', '<C-w>>', { desc = 'vres +1' } },
    { '<', '<C-w><', { desc = 'res -1' } },
    { 's', '<C-w>s', { desc = 'res -1' } },
    { 'v', '<C-w>v', { desc = 'res -1' } },
    { '=', '<C-w>=', { desc = 'equalize' } },
    { 'q', '<cmd>close<CR>', { desc = 'close' } },
    { 'o', '<cmd>only<CR>', { desc = 'only' } },
    { '_', '<C-w>_', { desc = 'expand vertically ' } },
    { '|', '<C-w>|', { desc = 'expand horiz' } },
    { '<Esc>', nil, { exit = true, desc = false } },
  },
})

-- stylua: ignore end

local spell_hint = [[_f_: fix word     _s_: suggestions       _ra_: repeat for all instances
_<Esc>_/_q_    _ag_: add as good word   _ab_: add as bad word     _u_ _[_/_]_/_b_]]

Hydra({
  name = 'Spellcheck',
  hint = spell_hint,
  config = {
    foreign_keys = 'run',
    invoke_on_body = true,
    hint = {
      float_opts = {
        -- row, col, height, width, relative, and anchor should not be
        -- overridden
        border = 'rounded',
        style = 'minimal',
        focusable = false,
        noautocmd = true,
      },
    },
  },
  mode = 'n',
  body = '<localleader>s',
  heads = {
    { ']', ']s' },
    { '[', '[s', { desc = 'Navigate' } },
    { 'b', '[s', { desc = 'Back' } },
    { 's', 'z=', { exit = true, desc = 'Suggestions' } },
    { 'f', '1z=', { desc = 'Fix word Automatically' } },
    { 'ra', cmd('spellrepall'), { desc = 'Repeat fix for all instances' } },
    { 'ag', 'zg', { desc = 'Add as good' } },
    { 'ab', 'zg', { desc = 'Add as bad' } },
    { 'u', 'u' },
    { '<Esc>', nil, { exit = true, nowait = true } },
    { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
  },
})

-- LSP

local hint_lsp = [[
^^ LSP
^
_d_: Definition _D_: Declaration _i_: Implementation _r_: References _s_: Signature help
_I_: Info _R_: Rename _a_: Code action
_[_: Prev diagnostic _]_: Next diagnostic _l_: Diagnostics loclist _f_: Diagnostics float _t_: Diagnostics telescope
_<Esc>_: Exit
]]

local lsp_hydra = Hydra({
  name = 'LSP',
  hint = hint_lsp,
  config = {
    color = 'pink',
    hint = {
      float_opts = {
        -- row, col, height, width, relative, and anchor should not be
        -- overridden
        border = 'rounded',
        style = 'minimal',
        focusable = false,
        noautocmd = true,
      },
      offset = 2,
    },
  },
  heads = {
    { 'd', '<cmd>lua vim.lsp.buf.definition()<CR>', { exit = true, nowait = true, desc = 'definition' } },
    { 'D', '<cmd>lua vim.lsp.buf.declaration()<CR>', { exit = true, nowait = true, desc = 'declaration' } },
    { 'i', '<cmd>lua vim.lsp.buf.implementation()<CR>', { exit = true, nowait = true, desc = 'implementation' } },
    { 'r', '<cmd>lua vim.lsp.buf.references()<CR>', { exit = true, nowait = true, desc = 'references' } },
    { 's', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { exit = true, nowait = true, desc = 'signature_help' } },

    { 'I', '<cmd>lua vim.lsp.buf.hover()<CR>', { exit = true, nowait = true, desc = 'hover' } },
    { 'R', '<cmd>lua vim.lsp.buf.rename()<CR>', { exit = true, nowait = true, desc = 'rename' } },
    { 'a', '<cmd>lua vim.lsp.buf.code_action()<CR>', { nowait = true, desc = 'code_actions' } },

    {
      '[',
      '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
      { nowait = true, desc = 'diagnostic prev' },
    },
    {
      ']',
      '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
      { nowait = true, desc = 'diagnostic next' },
    },
    { 'f', '<cmd>lua vim.diagnostic.open_float()<CR>', { nowait = true, desc = 'diagnostics float' } },
    { 'l', '<cmd>lua vim.diagnostic.setloclist()<CR>', { nowait = true, desc = 'diagnostics loclist' } },
    {
      't',
      '<cmd>Telescope diagnostics<CR>',
      { nowait = true, exit = true, desc = 'diagnostics telescope' },
    },

    { '<Esc>', nil, { exit = true, nowait = true, desc = 'exit' } },
  },
})

-- Misc

local hint_misc = [[
^^ Miscellaneous
^
_r_: Reload buffers
_s_: Source buffer vimscript/lua
_[_: Auto-fix prev spelling issue
_]_: Auto-fix next spelling issue
_m_: Marks in telescope
_j_: Jumplist in telescope
_<Esc>_: Exit
]]

local misc_hydra = hydra({
  name = 'Miscellaneous',
  hint = hint_misc,
  config = {
    color = 'pink',
    hint = {
      float_opts = {
        -- row, col, height, width, relative, and anchor should not be
        -- overridden
        border = 'rounded',
        style = 'minimal',
        focusable = false,
        noautocmd = true,
      },
      offset = 2,
    },
  },
  heads = {
    { 'r', require('user.utils.misc').reload_session, { exit = true, nowait = true, desc = 'reload' } },
    { 's', '<cmd>so %<CR>', { exit = true, nowait = true, desc = 'source file' } },

    -- can we improve with this https://stackoverflow.com/questions/5312235/how-do-i-correct-vim-spelling-mistakes-quicker
    { '[', '[s1z=<c-o>', { nowait = true, desc = 'prev spelling error' } },
    { ']', ']s1z=<c-o>', { nowait = true, desc = 'next spelling error' } },

    { 'm', '<cmd>Telescope marks<CR>', { nowait = true, exit = true, desc = 'marks in telescope' } },
    {
      'j',
      '<cmd>Telescope jumplist<CR>',
      { nowait = true, exit = true, desc = 'jumplist in telescope' },
    },

    { '<Esc>', nil, { exit = true, nowait = true, desc = 'exit' } },
  },
})

local ts_move = require('nvim-treesitter.textobjects.move')
local leader = '\\<leader>'
local hydra = require('hydra')
local border = require('custom.border').styles.type_1

local mx = function(feedkeys, type)
  local type = type or 'm'
  return function()
    if type == 'v' then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('v', true, true, true), 'n', true)
    end

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feedkeys, true, false, true), type, false)
  end
end
local motion_type = {
  D = 'Del',
  C = 'Cut',
  Y = 'Yank',
}
local bracket = { 'h', 'j', 'k', 'l' }

local function make_core_table(core_table, second_table)
  for _, v in pairs(second_table) do
    table.insert(core_table, v)
  end
  table.insert(core_table, '\n')
end

local function starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

local function create_table_normal(var, sorted, string_len, start_val)
  start_val = start_val or nil
  var = {}
  for _, v in pairs(sorted) do
    if string.len(v) == string_len and not vim.tbl_contains(bracket, v) then
      if start_val ~= nil then
        if starts(v, start_val) then
          table.insert(var, v)
        end
      else
        table.insert(var, v)
      end
    end
  end
  table.sort(var, function(a, b)
    return a:lower() < b:lower()
  end)

  return var
end

local config = {}

local exit = { nil, { exit = true, desc = 'EXIT' } }
-- TODO: make a toggler for cursorhold events, so we can show peek
local function toggle(lhs, on_enter, on_exit)
  return {
    color = 'pink',
    body = lhs,
    [lhs] = exit,
    on_exit = on_exit,
    on_enter = on_enter,
  }
end

config.parenth_mode = {
  color = 'pink',
  body = leader,
  mode = { 'n', 'v', 'x', 'o' },
  [leader] = { nil, { exit = true } },
  ['<ESC>'] = { nil, { exit = true } },
  j = {
    function()
      ts_move.goto_next_start({ '@function.outer', '@class.outer' })
    end,
    { nowait = true, desc = 'Move [N] ←' },
  },
  h = {
    function()
      ts_move.goto_next_end({ '@function.outer', '@class.outer' })
    end,
    { nowait = true, desc = 'Move [N] →' },
  },
  k = {
    function()
      ts_move.goto_previous_start({ '@function.outer', '@class.outer' })
    end,
    { nowait = true, desc = 'Move [P] ←' },
  },
  l = {
    function()
      ts_move.goto_previous_start({ '@function.outer', '@class.outer' })
    end,
    { nowait = true, desc = 'Move [P] →' },
  },
  ['c'] = { mx('ac', 'v'), { nowait = true, desc = 'Cls  [ac]' } }, -- ts: all class
  ['C'] = { mx('ic', 'v'), { nowait = true, desc = 'Cls  [ic]' } }, -- ts: inner class

  ['a'] = { mx('af', 'v'), { nowait = true, desc = 'Func [af]' } }, -- ts: all function
  ['A'] = { mx('if', 'v'), { nowait = true, desc = 'Func [if]' } }, -- ts: inner function

  ['i'] = { mx('aC', 'v'), { nowait = true, desc = 'Cond [aC]' } }, -- ts: all conditional
  ['I'] = { mx('iC', 'v'), { nowait = true, desc = 'Cond [iC]' } }, -- ts: inner conditional
}

for surround, motion in pairs({ c = 'ac', C = 'ic', a = 'af', A = 'if', i = 'aC', I = 'iC' }) do
  for doc, key in pairs({ D = 'd', C = 'c', Y = 'y' }) do
    local motiondoc = surround
    local exit = false
    local mapping = table.concat({ doc, surround })
    config.parenth_mode[mapping] = {
      mx(table.concat({ key, motion })),
      { desc = motion_type[doc] .. ' [' .. key .. motion .. ']', exit = exit },
    }
  end
end

local mapping = {
  color = function(t, rhs)
    t.config.color = rhs
  end,
  body = function(t, rhs)
    t.body = rhs
  end,
  on_enter = function(t, rhs)
    t.config.on_enter = rhs
  end,
  on_exit = function(t, rhs)
    t.config.on_exit = rhs
  end,
  mode = function(t, rhs)
    t.config.mode = rhs
  end,
}
-- Create a Auto Hinting Table same as above but with auto generated

local new_hydra = {
  name = 'TS',
  config = {
    hint = {
      position = 'middle-right',
      float_opts = {
        -- row, col, height, width, relative, and anchor should not be
        -- overridden
        border = border,
        style = 'minimal',
        focusable = false,
        noautocmd = true,
      },
    },
    timeout = false,
    invoke_on_body = true,
  },
  heads = {},
}

for name, spec in pairs(config) do
  for lhs, rhs in pairs(spec) do
    local action = mapping[lhs]
    if action == nil then
      new_hydra.heads[#new_hydra.heads + 1] = { lhs, table.unpack(rhs) }
    else
      action(new_hydra, rhs)
    end
  end
end

--
local function auto_hint_generate()
  container = {}
  for x, y in pairs(config.parenth_mode) do
    local mapping = x
    if type(y[1]) == 'function' then
      for x, y in pairs(y[2]) do
        if x == 'desc' then
          container[mapping] = y
        end
      end
    end
  end
  sorted = {}
  for k, v in pairs(container) do
    table.insert(sorted, k)
  end
  table.sort(sorted)

  single = create_table_normal({}, sorted, 1)
  yank = create_table_normal({}, sorted, 2, 'Y')
  delete = create_table_normal({}, sorted, 2, 'D')
  change = create_table_normal({}, sorted, 2, 'C')

  core_table = {}

  make_core_table(core_table, bracket)
  make_core_table(core_table, single)
  make_core_table(core_table, yank)
  make_core_table(core_table, delete)
  make_core_table(core_table, change)

  hint_table = {}
  string_val = '^ ^  Tree Sitter    ^ ^\n\n'
  string_val = string_val .. '^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n'

  for _, v in pairs(core_table) do
    if v == '\n' then
      hint = '\n'
      hint = hint .. '^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n'
    else
      hint = '^ ^ _' .. v .. '_: ' .. container[v] .. ' ^ ^\n'
    end
    table.insert(hint_table, hint)
    string_val = string_val .. hint
    -- end
  end
  return string_val
end

val = auto_hint_generate()
new_hydra.hint = val
hydra(new_hydra)

return {
  hydra_git = hydra_git,
}
