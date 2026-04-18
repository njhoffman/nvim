local cmp = require("cmp")
local keymap = require("cmp.utils.keymap")
local types = require("cmp.types")

local toggle_docs = function()
  if cmp.visible() and cmp.visible_docs() then
    cmp.close_docs()
  else
    cmp.open_docs()
  end
end

local mapping = require("cmp.config.mapping")
local feedkeys = require("cmp.utils.feedkeys")

local cmdline = {
  ["<M-?>"] = { c = toggle_docs },
  ["<F37>"] = { c = toggle_docs },
  ["<M-S-Down>"] = { c = mapping.scroll_docs(1) },
  ["<M-S-Up>"] = { c = mapping.scroll_docs(-1) },
  ["<C-e>"] = {
    c = mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  },
  ["<C-Y>"] = mapping({
    c = mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  }),

  ["<C-Space>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.abort()
      elseif not cmp.complete() then
        fallback()
      end
    end,
  },

  ["<M-'>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      end
      if type(fallback) == "function" then
        fallback()
      end
    end,
  },

  ["<C-F>"] = {
    c = cmp.mapping.select_next_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  ["<C-B>"] = {
    c = cmp.mapping.select_prev_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },

  ["<Esc>"] = {
    c = function()
      if cmp.get_selected_entry() then
        cmp.abort()
      else
        feedkeys.call(keymap.t("<C-c>"), "c")
      end
    end,
  },

  ["<C-n>"] = {
    c = function()
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },

  ["<C-p>"] = {
    c = function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },
  ["<M-P>"] = {
    c = function()
      feedkeys.call(keymap.t("<Up>"), "c")
    end,
  },
  ["<M-n>"] = {
    c = function()
      feedkeys.call(keymap.t("<Down>"), "c")
    end,
  },

  ["<M-BS>"] = {
    c = function(fallback)
      local cmdpos = vim.fn.getcmdpos()
      if cmdpos < 2 then
        return cmp.close()
      elseif type(fallback) == "function" then
        fallback()
      end
    end,
  },

  ["<CR>"] = mapping(function(fallback)
    local opts = { confirm_opts = { behavior = cmp.ConfirmBehavior.Insert, select = false } }
    if cmp.visible() then
      local confirm_opts = vim.deepcopy(opts.confirm_opts)
      local is_insert_mode = function()
        return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
      end
      if is_insert_mode() then -- prevent overwriting brackets
        confirm_opts.behavior = types.cmp.ConfirmBehavior.Insert
      end
      local entry = cmp.get_selected_entry()
      local is_copilot = entry and entry.source.name == "copilot"
      if is_copilot then
        confirm_opts.select = true
      end
      if cmp.confirm(confirm_opts) then
        return -- success, exit early
      end
    end
    fallback()
  end, { "c" }),

  ["<Tab>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.select_next_item()
    end
  end, { "c" }),

  ["<S-Tab>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.select_prev_item()
    end
  end, { "c" }),
}
return cmdline
