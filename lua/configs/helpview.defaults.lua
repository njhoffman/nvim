---@field icon? string
---@field corner_left? string
---@field corner_right? string
---@field padding_left? string
---@field padding_right? string
--- Primary highlight group. Used by other `*_hl` option(s) when a value isn't given.
---@field hl? string
---@field corner_left_hl? string
---@field corner_right_hl? string
---@field padding_left_hl? string
---@field padding_right_hl? string
---@field icon_hl? string

local defaults = {
  renderers = {},
  preview = {
    enable = true,
    enable_hybrid_mode = true,
    modes = { "n", "c", "no" },
    hybrid_modes = {},
    linewise_hybrid_mode = false,
    filetypes = { "help" },
    ignore_previews = {},
    ignore_buftypes = {},
    condition = nil,
    max_buf_lines = 500,
    draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
    edit_range = { 0, 0 },
    debounce = 150,
    callbacks = {},
    icon_provider = "internal",
    splitview_winopts = { split = "right" },
    preview_winopts = { width = math.floor(80) },
  },
  vimdoc = {
    arguments = {
      enable = true,
      default = {
        hl = "Argument",
        padding_left = " ",
        padding_right = " ",
      },
    },
    code_blocks = {
      enable = true,
      border_hl = "Code",
      default = { block_hl = "HelpviewCode" },
      ["diff"] = {
        block_hl = function(_, line)
          if line:match("^%s*%+") then
            return "HelpviewPalette4"
          elseif line:match("^%s*%-") then
            return "HelpviewPalette1"
          else
            return "HelpviewCode"
          end
        end,
      },
    },
    headings = {
      enable = true,
      heading_1 = {
        sign = " ⣾⣿⠛⣿⣷ ",
        sign_hl = "Palette1Inv",
        marker_hl = "Palette1Bg",
        hl = "Palette1Fg",
      },
      heading_2 = {
        sign = " ⣠⠞⠛⠳⣄ ",
        sign_hl = "Palette2Inv",
        marker_hl = "Palette2",
        hl = "Palette2Fg",
      },
      heading_3 = {
        sign = " ⣯⣤⠛⣤⣽ ",
        sign_hl = "Palette3Inv",
        marker_hl = "Palette3",
        hl = "Palette3",
      },
      heading_4 = {
        sign = " ⠓⣠⣿⣄⠚ ",
        sign_hl = "Palette4Inv",
        marker_hl = "Palette4",
        hl = "Palette4",
      },
    },
    highlight_groups = {
      enable = true,
    },
    horizontal_rules = {
      parts = {
        {
          type = "repeating",
          repeat_amount = function(buffer)
            return math.ceil((vim.bo[buffer].tw - 3) / 2)
          end,
          text = "─",
          hl = {
            "HelpviewGradient1",
            "HelpviewGradient1",
            "HelpviewGradient2",
            "HelpviewGradient2",
            "HelpviewGradient3",
            "HelpviewGradient3",
            "HelpviewGradient4",
            "HelpviewGradient4",
            "HelpviewGradient5",
            "HelpviewGradient5",
            "HelpviewGradient6",
            "HelpviewGradient6",
            "HelpviewGradient7",
            "HelpviewGradient7",
            "HelpviewGradient8",
            "HelpviewGradient8",
            "HelpviewGradient8",
            "HelpviewGradient8",
          },
        },
        {
          type = "text",
          text = " ◈ ",
        },
        {
          type = "repeating",
          repeat_amount = function(buffer)
            return math.floor((vim.bo[buffer].tw - 3) / 2)
          end,
          direction = "right",
          text = "─",
          hl = {
            "HelpviewGradient1",
            "HelpviewGradient1",
            "HelpviewGradient2",
            "HelpviewGradient2",
            "HelpviewGradient3",
            "HelpviewGradient3",
            "HelpviewGradient4",
            "HelpviewGradient4",
            "HelpviewGradient5",
            "HelpviewGradient5",
            "HelpviewGradient6",
            "HelpviewGradient6",
            "HelpviewGradient7",
            "HelpviewGradient7",
            "HelpviewGradient8",
            "HelpviewGradient8",
            "HelpviewGradient8",
            "HelpviewGradient8",
          },
        },
      },
    },
    inline_codes = {
      enable = true,
      hl = "Palette5",
      padding_left = " ",
      padding_right = " ",
    },
    keycodes = {
      enable = true,
      default = {
        hl = "Keycode",
        padding_left = " ",
        padding_right = " ",
      },
    },
    modelines = {
      enable = true,
      border = "─",
      border_hl = "@text.todo.unchecked",
      data_types = {
        ["nil"] = { value_hl = "@constant.builtin" },
        ["string"] = { value_hl = "String" },
        ["number"] = { value_hl = "Number" },
        ["boolean"] = { value_hl = "Boolean" },
      },
      default = {
        option_hl = "@property",
        value_hl = "Comment",
      },
    },
    notes = {
      enable = true,
      default = {
        hl = "Palette5Inv",
        padding_left = " ",
        padding_right = " ",
      },
      ["[dD]eprecated"] = {
        hl = "Palette1Inv",
      },
      ["[wW]arning"] = {
        hl = "Palette3Inv",
      },
    },
    optionlinks = {
      enable = true,
      default = {
        hl = "Optionlink",
        padding_left = " ",
        padding_right = " ",
      },
    },
    tags = {
      enable = true,
      default = {
        hl = "Tag",
        padding_left = " ",
        padding_right = " ",
      },
      ["%.txt$"] = {
        hl = "Palette3",
      },
    },
    taglinks = {
      enable = true,
      default = {
        hl = "Taglink",
        padding_left = " ",
        padding_right = " ",
      },
    },
    urls = {
      enable = true,
      default = {
        icon = "󰌷 ",
        hl = "@string.special.url.vimdoc",
      },
      ---+${lua, Github sites}
      ["github%.com/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return string.match(item.label, "github%.com/([%a%d%-%_%.]+)%/?$")
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>
        icon = "󰳐 ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/?$")
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/tree/<branch>
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          local repo, branch = string.match(
            item.label,
            "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)/tree/([%a%d%-%_%.]+)%/?$"
          )
          return repo .. " at " .. branch
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/commits/<branch>
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return string.match(
            item.label,
            "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+)%/?$"
          )
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
        --- github.com/<user>/<repo>/releases
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return "Releases • "
            .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/releases$")
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
        --- github.com/<user>/<repo>/tags
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return "Tags • "
            .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/tags$")
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
        --- github.com/<user>/<repo>/issues
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return "Issues • "
            .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/issues$")
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
        --- github.com/<user>/<repo>/pulls
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return "Pull requests • "
            .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/pulls$")
        end,
      },
      ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
        --- github.com/<user>/<repo>/wiki
        icon = " ",
        hl = "HelpviewPalette0Fg",
        text = function(_, item)
          return "Wiki • "
            .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/wiki$")
        end,
      },
      ---_
      ---+${lua, Commonly used sites by programmers}
      ["developer%.mozilla%.org"] = {
        priority = -9999,
        icon = "󰖟 ",
        hl = "HelpviewPalette5Fg",
      },
      ["w3schools%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette4Fg",
      },
      ["stackoverflow%.com"] = {
        priority = -9999,
        icon = "󰓌 ",
        hl = "HelpviewPalette2Fg",
      },
      ["reddit%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette2Fg",
      },
      ["github%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette6Fg",
      },
      ["gitlab%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette2Fg",
      },
      ["dev%.to"] = {
        priority = -9999,
        icon = "󱁴 ",
        hl = "HelpviewPalette0Fg",
      },
      ["codepen%.io"] = {
        priority = 9999,
        icon = " ",
        hl = "HelpviewPalette6Fg",
      },
      ["replit%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette2Fg",
      },
      ["jsfiddle%.net"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette5Fg",
      },
      ["npmjs%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette0Fg",
      },
      ["pypi%.org"] = {
        priority = -9999,
        icon = "󰆦 ",
        hl = "HelpviewPalette0Fg",
      },
      ["mvnrepository%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette1Fg",
      },
      ["medium%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette6Fg",
      },
      ["linkedin%.com"] = {
        priority = -9999,
        icon = "󰌻 ",
        hl = "HelpviewPalette5Fg",
      },
      ["news%.ycombinator%.com"] = {
        priority = -9999,
        icon = " ",
        hl = "HelpviewPalette2Fg",
      },
      ---_
      ["neovim%.io/doc/user/.*#%_?.*$"] = {
        icon = " ",
        hl = "HelpviewPalette4Fg",
        text = function(_, item)
          local file, tag = string.match(item.label, "neovim%.io/doc/user/(.*)#%_?(.*)$")
          --- The actual website seems to show
          --- _ in the site name so, we won't
          --- be replacing `_`s with ` `s.
          file = string.gsub(file, "%.html$", "")
          -- return string.format("%s(%s) - Neovim docs", utils.normalize_str(file), tag)
        end,
      },
      ["neovim%.io/doc/user/.*$"] = {
        icon = " ",
        hl = "HelpviewPalette4Fg",
        text = function(_, item)
          local file = string.match(item.label, "neovim%.io/doc/user/(.*)$")
          file = string.gsub(file, "%.html$", "")
          -- return string.format("%s - Neovim docs", utils.normalize_str(file))
        end,
      },
      ["github%.com/vim/vim"] = {
        priority = -100,
        icon = " ",
        hl = "HelpviewPalette4Fg",
      },
      ["github%.com/neovim/neovim"] = {
        priority = -100,
        icon = " ",
        hl = "HelpviewPalette4Fg",
      },
      ["vim%.org"] = {
        icon = " ",
        hl = "HelpviewPalette4Fg",
      },
      ["luals%.github%.io/wiki/?.*$"] = {
        icon = " ",
        hl = "HelpviewPalette5Fg",
        text = function(_, item)
          if string.match(item.label, "luals%.github%.io/wiki/(.-)/#(.+)$") then
            local page_mappings = {
              annotations = {
                ["as"] = "@as",
                ["alias"] = "@alias",
                ["async"] = "@async",
                ["cast"] = "@cast",
                ["class"] = "@class",
                ["deprecated"] = "@deprecated",
                ["diagnostic"] = "@diagnostic",
                ["enum"] = "@enum",
                ["field"] = "@field",
                ["generic"] = "@generic",
                ["meta"] = "@meta",
                ["module"] = "@module",
                ["nodiscard"] = "@nodiscard",
                ["operator"] = "@operator",
                ["overload"] = "@overload",
                ["package"] = "@package",
                ["param"] = "@param",
                ["see"] = "@see",
                ["source"] = "@source",
                ["type"] = "@type",
                ["vaarg"] = "@vaarg",
                ["version"] = "@version",
              },
            }
            local page, section = string.match(item.label, "luals%.github%.io/wiki/(.-)/#(.+)$")
            if page_mappings[page] and page_mappings[page][section] then
              section = page_mappings[page][section]
            else
              section = utils.normalize_str(string.gsub(section, "%-", " "))
            end
            return string.format("%s(%s) | Lua Language Server", utils.normalize_str(page), section)
          elseif string.match(item.label, "") then
            local page = string.match(item.label, "luals%.github%.io/wiki/(.-)/?$")
            return string.format("%s | Lua Language Server", utils.normalize_str(page))
          else
            return item.label
          end
        end,
      },
    },
  },
}

local renderers = {
  vimdoc_argument = {},
  vimdoc_hl = {},
  vimdoc_hr = {},
  vimdoc_inline_code = {},
  vimdoc_keycode = {},
  vimdoc_modeline = {},
  vimdoc_note = {},
  vimdoc_optionlink = {},
  vimdoc_tag = {},
  vimdoc_taglink = {},
  vimdoc_url = {},
  vimdoc_heading = {
    --     delimiter = "------------------------------------------------------------------------------",
    --     description = "Hello Neovim!",
    --     level = 2,
    --     range = { col_end = 0, col_start = 0, desc_end = 13, desc_start = 0, row_end = 9, row_start = 7 },
    --     tags = { {
    --       col_start = 70,
    --       tag = "*tag-1*",
    --     }, {
    --       col_start = 78,
    --       tag = "*tag-2*",
    --     } },
    --     text = { "------------------------------------------------------------------------------", "Hello Neovim!                                                  *tag-1* *tag-2*" }
  },
  vimdoc_code_block = function(ns, buffer, item)
    -- item.bottom_border = { false, false },
    -- item.class = "vimdoc_code_block",
    -- item.language = "diff",
    -- item.range = { col_end = 0, col_start = 0, row_end = 5, row_start = 3, },
    -- item.text = { ">diff", "    + h" },
    -- item.top_border = { false, false },
  end,
}
