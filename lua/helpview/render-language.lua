-- try to match config of render-markdown
-- code = {
--   enabled = true,
--   sign = true,
--   style = "full",
--   position = "left",
--   language_pad = 0,
--   language_name = true,
--   disable_background = { "diff" },
--   width = "full",
--   left_margin = 0,
--   left_pad = 0,
--   right_pad = 0,
--   min_width = 0,
--   border = "thin",
--   above = "▄",
--   below = "▀",
--   highlight = "RenderMarkdownCode",
--   highlight_inline = "RenderMarkdownCodeInline",
--   highlight_language = nil,
-- },

-- function Render:render()
--     local disabled_language = self.code.disable_background
--     if type(disabled_language) == 'table' then
--         disabled_language = vim.tbl_contains(disabled_language, self.data.language)
--     end
--     local background = vim.tbl_contains({ 'normal', 'full' }, self.code.style) and not disabled_language

--     local icon = self:language()
--     self:border(icon)
--     if background then
--         self:background(self.node.start_row + 1, self.node.end_row - 2)
--     end
--     self:left_pad(background)
-- end

local render = function(ft_map, icons)
  return {
    icon = function(name)
      if not name then
        return ""
      end

      if ft_map[name:lower()] then
        name = ft_map[name:lower()]
      end

      if icons[name:lower()] then
        return icons[name:lower()]
      end

      return "󰡯 "
    end,

    name = function(str)
      if not str or str == "" then
        return ""
      end

      local name = str

      for nm, ft in pairs(ft_map) do
        if str == ft then
          name = nm
          break
        end
      end
      return string.gsub(name, "^%l", string.upper)
    end,
  }

  -- if self.code.language_name then
  --     icon_text = icon_text .. node.text
  -- end
  -- local win_col = self.data.max_width - self.data.language_padding
  -- if self.code.width == 'block' then
  --     win_col = win_col - Str.width(icon_text) + self.data.indent
  -- end
  -- return self.marks:add('code_language', node.start_row, 0, {
  --     virt_text = { { icon_text, highlight } },
  --     virt_text_win_col = win_col,
  -- })
end

return render
