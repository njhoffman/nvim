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

local ns_vis = vim.api.nvim_create_namespace("modeman/visual")
local visual_from = function(ev)
  vim.api.nvim_buf_clear_namespace(ev.buf, ns_vis, 0, -1)
  vim.dbglog("end", ev.buf)
end

local visual_to = function(ev)
  -- get visual mode range
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- highlight number signs for lines inlucded in visual range
  for i = start_pos[2], end_pos[2], 1 do
    -- highlightt number column extmarks
    local bars = { thick = "▎", thin = "│" }
    vim.dbglog("vis", ev.buf, i, end_pos[2])
    vim.api.nvim_buf_set_extmark(ev.buf, ns_vis, i, 0, {
      -- virt_text = { { " " .. i .. " ", "SmoothCursor" } },
      -- virt_text_pos = "overlay",
      hl_mode = "combine",
      sign_text = bars.thick,
      sign_hl_group = "SmoothCursorPurple",
      number_hl_group = "SmoothCursorCyan",
    })
  end
end

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
    if vim.fn.tolower(string.sub(from, 1)) == "v" then
      visual_to(ev)
    elseif vim.fn.tolower(string.sub(to, 1)) == "v" then
      visual_from(ev)
    end

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
