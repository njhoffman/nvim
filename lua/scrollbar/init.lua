local scrollbar = require("scrollbar.scrollbar")
local const = require("scrollbar.const")
local utils = require("scrollbar.utils")

local augroup = vim.api.nvim_create_augroup(const.AUGROUP, { clear = true })
local setup = function(overrides)
  local config = require("scrollbar.config").set(overrides)

  if config.throttle_ms > 0 then
    scrollbar.throttled_render = utils.throttle(scrollbar.render, config.throttle_ms)
  end

  if config.set_highlights then
    utils.set_highlights()
    vim.api.nvim_create_autocmd(
      { "ColorScheme" },
      { group = augroup, callback = utils.set_highlights }
    )

    -- vim.cmd([[
    --     augroup scrollbar_setup_highlights
    --         autocmd!
    --         autocmd ColorScheme * lua require('scrollbar.utils').set_highlights()
    --     augroup END
    --     ]])
  end

  utils.set_commands()

  if config.autocmd and config.autocmd.render and #config.autocmd.render > 0 then
    vim.api.nvim_create_autocmd(config.autocmd.render, {
      group = augroup,
      callback = scrollbar.on_scroll,
    })
    -- vim.cmd(string.format(
    --   [[
    --     augroup scrollbar_render
    --         autocmd!
    --         autocmd %s * lua require('scrollbar.scrollbar').on_scroll()
    --     augroup END
    --     ]],
    --   table.concat(config.autocmd.render, ",")
    -- ))
  end

  if config.handlers.cursor then
    require("scrollbar.handlers.cursor").setup()
  end

  if config.handlers.diagnostic then
    require("scrollbar.handlers.diagnostic").setup()
  end

  if config.handlers.gitsigns then
    require("scrollbar.handlers.gitsigns").setup()
  end

  if config.handlers.search then
    require("scrollbar.handlers.search").setup()
  end

  if config.handlers.ale then
    require("scrollbar.handlers.ale").setup()
  end

  if config.show_in_active_only then
    vim.cmd(string.format(
      [[
        augroup scrollbar_clear
            autocmd!
            autocmd %s * lua require('scrollbar.scrollbar').clear()
        augroup END
        ]],
      table.concat(config.autocmd.clear, ",")
    ))
  end
end

return { setup = setup }
