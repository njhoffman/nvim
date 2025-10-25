-- Unit tests for colorscheme_export command
-- Tests the ColorschemeExport functionality that exports Neovim colorschemes to bat theme format

describe("ColorschemeExport", function()
  local colorscheme_export

  before_each(function()
    colorscheme_export = require("commands.colorscheme_export")
  end)

  after_each(function()
    -- Clean up any test buffers
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buftype") == "nofile" then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      end
    end
  end)

  describe("Module structure", function()
    it("exports required functions", function()
      assert.is_not_nil(colorscheme_export)
      assert.are.equal("table", type(colorscheme_export))
      assert.are.equal("function", type(colorscheme_export.export))
      assert.are.equal("function", type(colorscheme_export.generate_tmtheme))
    end)
  end)

  describe("generate_tmtheme", function()
    it("generates valid XML output", function()
      local result = colorscheme_export.generate_tmtheme("test-theme")
      assert.is_not_nil(result)
      assert.is_true(type(result) == "string")

      -- Check XML declaration
      assert.is_true(result:match('<?xml version="1.0"') ~= nil)
      assert.is_true(result:match("<!DOCTYPE plist") ~= nil)

      -- Check structure
      assert.is_true(result:match("<plist version") ~= nil)
      assert.is_true(result:match("<dict>") ~= nil)
      assert.is_true(result:match("</dict>") ~= nil)
      assert.is_true(result:match("</plist>") ~= nil)
    end)

    it("includes theme name", function()
      local theme_name = "my-custom-theme"
      local result = colorscheme_export.generate_tmtheme(theme_name)

      assert.is_true(result:match("<key>name</key>") ~= nil)
      -- Use vim.pesc to escape pattern characters
      assert.is_true(result:match("<string>" .. vim.pesc(theme_name) .. "</string>") ~= nil)
    end)

    it("includes settings array", function()
      local result = colorscheme_export.generate_tmtheme("test-theme")

      assert.is_true(result:match("<key>settings</key>") ~= nil)
      assert.is_true(result:match("<array>") ~= nil)
      assert.is_true(result:match("</array>") ~= nil)
    end)

    it("includes global background and foreground", function()
      -- Set up some basic highlight groups
      vim.api.nvim_set_hl(0, "Normal", { fg = "#ffffff", bg = "#000000" })

      local result = colorscheme_export.generate_tmtheme("test-theme")

      -- Should contain background and foreground settings
      assert.is_true(result:match("<key>background</key>") ~= nil)
      assert.is_true(result:match("<key>foreground</key>") ~= nil)
      assert.is_true(result:match("#[0-9a-fA-F]+") ~= nil)
    end)

    it("handles missing highlight groups gracefully", function()
      -- Clear all highlight groups
      vim.cmd("highlight clear")

      -- Should not error
      local ok, result = pcall(colorscheme_export.generate_tmtheme, "minimal-theme")
      assert.is_true(ok)
      assert.is_not_nil(result)
      assert.is_true(type(result) == "string")
    end)
  end)

  describe("export function", function()
    it("creates a new buffer", function()
      local initial_bufs = #vim.api.nvim_list_bufs()

      colorscheme_export.export({ colorscheme = "test-theme" })

      local final_bufs = #vim.api.nvim_list_bufs()
      assert.is_true(final_bufs > initial_bufs)
    end)

    it("sets correct buffer options", function()
      local bufnr = colorscheme_export.export({ colorscheme = "test-theme" })

      assert.is_true(vim.api.nvim_buf_is_valid(bufnr))
      assert.are.equal("nofile", vim.api.nvim_buf_get_option(bufnr, "buftype"))
      assert.are.equal("hide", vim.api.nvim_buf_get_option(bufnr, "bufhidden"))
      assert.are.equal(false, vim.api.nvim_buf_get_option(bufnr, "swapfile"))
      assert.are.equal("xml", vim.api.nvim_buf_get_option(bufnr, "filetype"))
    end)

    it("sets buffer name with .tmTheme extension", function()
      local bufnr = colorscheme_export.export({ colorscheme = "my-theme" })

      local bufname = vim.api.nvim_buf_get_name(bufnr)
      assert.is_true(bufname:match("my%-theme%.tmTheme$") ~= nil)
    end)

    it("uses custom filename when provided", function()
      local custom_name = "custom-export.tmTheme"
      local bufnr = colorscheme_export.export({
        colorscheme = "test-theme",
        filename = custom_name,
      })

      local bufname = vim.api.nvim_buf_get_name(bufnr)
      assert.is_true(bufname:match(vim.pesc(custom_name) .. "$") ~= nil)
    end)

    it("uses current colorscheme when not specified", function()
      -- Set a known colorscheme name
      vim.g.colors_name = "default"

      local bufnr = colorscheme_export.export({})

      local bufname = vim.api.nvim_buf_get_name(bufnr)
      -- Should use vim.g.colors_name
      assert.is_not_nil(bufname)
      assert.is_true(bufname:match("%.tmTheme$") ~= nil)
    end)

    it("populates buffer with XML content", function()
      local bufnr = colorscheme_export.export({ colorscheme = "test-theme" })

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.is_true(#lines > 0)

      -- First line should be XML declaration
      assert.is_true(lines[1]:match('<?xml version="1.0"') ~= nil)

      -- Should have DOCTYPE
      local has_doctype = false
      for _, line in ipairs(lines) do
        if line:match("<!DOCTYPE") then
          has_doctype = true
          break
        end
      end
      assert.is_true(has_doctype)
    end)

    it("returns buffer number", function()
      local result = colorscheme_export.export({ colorscheme = "test-theme" })

      assert.is_not_nil(result)
      assert.are.equal("number", type(result))
      assert.is_true(result > 0)
      assert.is_true(vim.api.nvim_buf_is_valid(result))
    end)
  end)

  describe("Highlight group mapping", function()
    it("exports common syntax groups", function()
      -- Set up common highlight groups
      vim.api.nvim_set_hl(0, "Comment", { fg = "#808080", italic = true })
      vim.api.nvim_set_hl(0, "String", { fg = "#00ff00" })
      vim.api.nvim_set_hl(0, "Function", { fg = "#ffff00", bold = true })
      vim.api.nvim_set_hl(0, "Keyword", { fg = "#ff00ff" })

      local result = colorscheme_export.generate_tmtheme("test-theme")

      -- Should contain scope mappings for these groups
      assert.is_true(result:match("<key>scope</key>") ~= nil)

      -- Should have color values
      assert.is_true(result:match("#[0-9a-fA-F]+") ~= nil)
    end)

    it("handles font styles (bold, italic)", function()
      vim.api.nvim_set_hl(0, "Comment", { fg = "#808080", italic = true })
      vim.api.nvim_set_hl(0, "Keyword", { fg = "#ff00ff", bold = true })
      vim.api.nvim_set_hl(0, "Function", { fg = "#ffff00", bold = true, italic = true })

      local result = colorscheme_export.generate_tmtheme("test-theme")

      -- Should contain fontStyle tags
      assert.is_true(result:match("<key>fontStyle</key>") ~= nil)
    end)

    it("exports UI highlight groups", function()
      vim.api.nvim_set_hl(0, "Normal", { fg = "#ffffff", bg = "#000000" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#333333" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#111111" })

      local result = colorscheme_export.generate_tmtheme("test-theme")

      -- Should have global settings for these
      assert.is_true(result:match("<key>background</key>") ~= nil)
      assert.is_true(result:match("<key>foreground</key>") ~= nil)
      assert.is_true(result:match("<key>selection</key>") ~= nil)
      assert.is_true(result:match("<key>lineHighlight</key>") ~= nil)
    end)
  end)

  describe("Color conversion", function()
    it("generates valid hex colors", function()
      vim.api.nvim_set_hl(0, "TestGroup", { fg = "#123456", bg = "#abcdef" })

      local result = colorscheme_export.generate_tmtheme("test-theme")

      -- Should contain hex color patterns
      local has_valid_color = false
      for color in result:gmatch("#[0-9A-Fa-f]+") do
        -- Hex colors should be 6 characters (plus #)
        if #color == 7 then
          has_valid_color = true
          break
        end
      end
      assert.is_true(has_valid_color)
    end)
  end)

  describe("Edge cases", function()
    it("handles empty colorscheme name", function()
      local ok, _ = pcall(colorscheme_export.generate_tmtheme, "")
      assert.is_true(ok)
    end)

    it("handles nil colorscheme in export", function()
      -- Should use fallback
      local ok, bufnr = pcall(colorscheme_export.export, {})
      assert.is_true(ok)
      if bufnr then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end)

    it("handles special characters in theme name", function()
      local ok, result = pcall(colorscheme_export.generate_tmtheme, "theme-with-dashes_and_underscores")
      assert.is_true(ok)
      assert.is_not_nil(result)
    end)
  end)

  describe("XML validity", function()
    it("produces well-formed XML", function()
      local result = colorscheme_export.generate_tmtheme("test-theme")

      -- Count opening and closing tags
      local _, open_dict = result:gsub("<dict>", "")
      local _, close_dict = result:gsub("</dict>", "")
      assert.are.equal(open_dict, close_dict)

      local _, open_array = result:gsub("<array>", "")
      local _, close_array = result:gsub("</array>", "")
      assert.are.equal(open_array, close_array)

      local _, open_plist = result:gsub("<plist", "")
      local _, close_plist = result:gsub("</plist>", "")
      assert.are.equal(open_plist, close_plist)
    end)

    it("properly escapes XML characters if present", function()
      -- This tests that if theme names or values contain special chars,
      -- they should be escaped (though in practice theme names are usually safe)
      local result = colorscheme_export.generate_tmtheme("test-theme")

      -- XML should not have unescaped < or > outside tags
      local content_sections = {}
      for content in result:gmatch("<string>([^<]*)</string>") do
        table.insert(content_sections, content)
      end

      -- If we extracted string contents, they shouldn't have < or >
      -- (unless properly escaped as &lt; or &gt;)
      for _, content in ipairs(content_sections) do
        -- Allow empty strings, hex colors, alphanumeric content, and dots (for scopes)
        assert.is_true(
          content:match("^[%w%s%-_#%.]*$") ~= nil or content == "",
          "String content should not have unescaped XML characters: " .. content
        )
      end
    end)
  end)
end)
