  --         ﲵ       嶺 淪 ▷   輪 ﯖ  
  -- 濾      礪 閭 驪 麗 ﱵ 隷   •   ● ●  
-- stylua: ignore
local ns_id = vim.api.nvim_create_namespace("smoothcursor")

local icons = {
  ["n"] = "▷", --    ◆ ﮜ ▷
  ["o"] = "", --    ◆ ﮜ ▷
  ["no"] = "", --    ◆ ﮜ ▷
  ["v"] = "",
  ["V"] = "",
  [""] = "礪",
  ["R"] = " ",
  ["i"] = "",
  ["s"] = "",
  ["S"] = "",
  ["c"] = "",
  ["C"] = "",
  ["*"] = "",
}

local colors = {
  -- ['n'] = { fg = '#fa4842', bold = true },
  ["n"] = { fg = "#0081ca", bold = true },
  ["no"] = { fg = "#0081ca", bold = true },
  ["o"] = { fg = "#0081ca", bold = true },
  ["v"] = { fg = "#8f41fa", bold = true },
  ["V"] = { fg = "#8f41fa", bold = true },
  [""] = { fg = "#8f41fa", bold = true },
  ["R"] = { fg = "#fa4842", bold = true },
  ["s"] = { fg = "#0f61ba", bold = true },
  ["S"] = { fg = "#0f61ba", bold = true },
  ["c"] = { fg = "#8f216a", bold = true },
  ["C"] = { fg = "#8f216a", bold = true },
  ["i"] = { fg = "#00afaf", bold = true },
  ["*"] = { fg = "#fa4842", bold = true },
  -- ! C C R S V c i n r s t v
}

local handle_visual = function(ev)
  -- get visual mode range
  local visual_start = vim.fn.getpos("'<")
  local visual_end = vim.fn.getpos("'>")

  -- highlight number signs for lines inlucded in visual range
  for i = visual_start[2], visual_end[2], 1 do
    -- highlightt number column extmarks

    local bars = { thick = "▎", thin = "│" }
    -- vim.api.nvim_buf_set_extmark(0, ns_id, i, 0, {
    --   -- virt_text = { { " " .. i .. " ", "SmoothCursor" } },
    --   -- virt_text_pos = "overlay",
    --   hl_mode = "combine",
    --   sign_text = bars.thick,
    --   sign_hl_group = "SmoothCursorPurple",
    --   number_hl_group = "SmoothCursorCyan",
    -- })
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
    -- vim.dbglog("set mode from " .. from .. " to " .. to .. " icon")
    if vim.fn.tolower(to) == "v" then
      handle_visual(ev)
    end

    if type(icons[to]) ~= "nil" then
      set_mode(icons[to], colors[to])
    else
      vim.dbglog("mode no icon to: " .. to, from)
      set_mode(icons["*"], colors["*"])
    end
  end,
})
