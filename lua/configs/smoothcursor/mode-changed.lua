--         ﲵ       嶺 淪 ▷   輪 ﯖ  
-- 濾      礪 閭 驪 麗 ﱵ 隷   •   ● ●        
local ns_id = vim.api.nvim_create_namespace("smoothcursor")

-- stylua: ignore
local icons = {
  ["n"]   = "▷", --    ◆ ﮜ ▷
  ["o"]   = "", --    ◆ ﮜ ▷
  ["v"]   = "",
  ["V"]   = "",
  [""]  = "礪",
  ["r"]   = "",
  ["R"]   = " ",
  ["i"]   = "",
  ["s"]   = "",
  ["S"]   = "",
  [""]  = "",
  ["c"]   = "",
  ["*"]   = "",
}

local colors = {
  -- ['n'] = { fg = '#fa4842', bold = true },
  ["n"] = { fg = "#0081ca", bold = true },
  ["o"] = { fg = "#aa80af", bold = true },
  ["v"] = { fg = "#8f41fa", bold = true },
  ["V"] = { fg = "#8f41fa", bold = true },
  [""] = { fg = "#8f41fa", bold = true },
  ["r"] = { fg = "#fa4842", bold = true },
  ["R"] = { fg = "#fa4842", bold = true },
  ["i"] = { fg = "#00afaf", bold = true },
  ["s"] = { fg = "#0f61ba", bold = true },
  ["S"] = { fg = "#0f61ba", bold = true },
  [""] = { fg = "#0f61ba", bold = true },
  ["c"] = { fg = "#8f216a", bold = true },
  ["*"] = { fg = "#fa4842", bold = true },
  -- ! C C R S V c i n r s t v
}

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
  callback = function(ev)
    local set_mode = function(icon, opts)
      vim.api.nvim_set_hl(0, "SmoothCursor", {
        fg = opts.fg or nil,
        bg = opts.bg or nil,
        sp = opts.sp or nil,
        bold = opts.bold or nil,
        italic = opts.italic or nil,
        style = opts.style or nil,
        link = opts.link or nil,
      })
      vim.fn.sign_define("smoothcursor", { text = icon })
      vim.cmd("redraw")
    end

    local from, to = unpack(vim.split(ev.match, ":"))
    local icon, color = icons[string.sub(to, 1, 1)], colors[string.sub(to, 1, 1)]
    if icon == nil then
      icon = icons["*"]
      vim.dbglog("mode missing icon to: " .. to .. " (from " .. from .. ")")
    end
    if color == nil then
      color = colors["*"]
      vim.dbglog("mode missing color to: " .. to .. " (from " .. from .. ")")
    end

    set_mode(icon, color)
  end,
})
