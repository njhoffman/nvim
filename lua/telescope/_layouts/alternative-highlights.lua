local highlights = {
  -- Sets the highlight for selected items within the picker.
  TelescopeSelection = { link = "Visual" },
  TelescopeSelectionCaret = { link = "TelescopeSelection" },
  TelescopeMultiSelection = { link = "Type" },
  TelescopeMultiIcon = { link = "Identifier" },

  -- "Normal" in the floating windows created by telescope.
  TelescopeNormal = { bg = main },
  -- TelescopePreviewNormal = { link = "TelescopeNormal" },
  TelescopePromptNormal = { bg = prompt },
  -- TelescopeResultsNormal = { link = "TelescopeNormal" },

  -- Border highlight groups.
  --   Use TelescopeBorder to override the default.
  --   Otherwise set them specifically
  TelescopeBorder = { fg = main, bg = theme.background },
  TelescopePromptBorder = { fg = prompt, bg = main },
  -- TelescopeResultsBorder = { link = "TelescopeBorder" },
  -- TelescopePreviewBorder = { link = "TelescopeBorder" },

  -- Title highlight groups.
  --   Use TelescopeTitle to override the default.
  --   Otherwise set them specifically
  TelescopeTitle = tel_theme.title,
  TelescopePromptTitle = { link = "TelescopeTitle" },
  TelescopeResultsTitle = { link = "TelescopeTitle" },
  TelescopePreviewTitle = { link = "TelescopeTitle" },

  TelescopePromptCounter = { link = "NonText" },

  -- Used for highlighting characters that you match.
  TelescopeMatching = { link = "Special" },

  -- Used for the prompt prefix
  TelescopePromptPrefix = tel_theme.promptPrefix,

  -- Used for highlighting the matched line inside Previewer. Works only for (vim_buffer_ previewer)
  TelescopePreviewLine = { link = "Visual" },
  TelescopePreviewMatch = { link = "Search" },

  TelescopePreviewPipe = tel_theme.pipe,
  TelescopePreviewCharDev = tel_theme.charDev,
  TelescopePreviewDirectory = { link = "Directory" },
  TelescopePreviewBlock = tel_theme.block,
  TelescopePreviewLink = { link = "Special" },
  TelescopePreviewSocket = { link = "Statement" },
  TelescopePreviewRead = tel_theme.read,
  TelescopePreviewWrite = { link = "Statement" },
  TelescopePreviewExecute = { link = "String" },
  TelescopePreviewHyphen = { link = "NonText" },
  TelescopePreviewSticky = { link = "Keyword" },
  TelescopePreviewSize = { link = "String" },
  TelescopePreviewUser = tel_theme.user,
  TelescopePreviewGroup = tel_theme.group,
  TelescopePreviewDate = { link = "Directory" },
  TelescopePreviewMessage = { link = "TelescopePreviewNormal" },
  TelescopePreviewMessageFillchar = { link = "TelescopePreviewMessage" },

  -- Used for Picker specific Results highlighting
  TelescopeResultsClass = { link = "Function" },
  TelescopeResultsConstant = tel_theme.constant,
  TelescopeResultsField = { link = "Function" },
  TelescopeResultsFunction = { link = "Function" },
  TelescopeResultsMethod = { link = "Method" },
  TelescopeResultsOperator = { link = "Operator" },
  TelescopeResultsStruct = { link = "Struct" },
  TelescopeResultsVariable = { link = "SpecialChar" },

  TelescopeResultsLineNr = { link = "LineNr" },
  TelescopeResultsIdentifier = { link = "Identifier" },
  TelescopeResultsNumber = tel_theme.number,
  TelescopeResultsComment = { link = "Comment" },
  TelescopeResultsSpecialComment = { link = "SpecialComment" },

  -- Used for git status Results highlighting
  TelescopeResultsDiffChange = { link = "DiffChange" },
  TelescopeResultsDiffAdd = { link = "DiffAdd" },
  TelescopeResultsDiffDelete = { link = "DiffDelete" },
  TelescopeResultsDiffUntracked = { link = "NonText" },
}

for k, v in pairs(highlights) do
  vim.api.nvim_set_hl(0, k, v)
end
