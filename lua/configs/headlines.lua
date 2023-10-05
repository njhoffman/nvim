local default_cfg = {
  markdown = {
    query = vim.treesitter.query.parse(
      'markdown',
      [[
          (atx_heading [
              (atx_h1_marker)
              (atx_h2_marker)
              (atx_h3_marker)
              (atx_h4_marker)
              (atx_h5_marker)
              (atx_h6_marker)
          ] @headline)

          (thematic_break) @dash

          (fenced_code_block) @codeblock

          (block_quote_marker) @quote
          (block_quote (paragraph (inline (block_continuation) @quote)))
      ]]
    ),
    headline_highlights = { 'Headline' },
    codeblock_highlight = 'CodeBlock',
    dash_highlight = 'Dash',
    dash_string = '-',
    quote_highlight = 'Quote',
    quote_string = '┃',
    fat_headlines = true,
    fat_headline_upper_string = '▃',
    fat_headline_lower_string = '🬂',
  },
  rmd = {
    query = vim.treesitter.query.parse(
      'markdown',
      [[
          (atx_heading [
              (atx_h1_marker)
              (atx_h2_marker)
              (atx_h3_marker)
              (atx_h4_marker)
              (atx_h5_marker)
              (atx_h6_marker)
          ] @headline)

          (thematic_break) @dash

          (fenced_code_block) @codeblock

          (block_quote_marker) @quote
          (block_quote (paragraph (inline (block_continuation) @quote)))
      ]]
    ),
    treesitter_language = 'markdown',
    headline_highlights = { 'Headline' },
    codeblock_highlight = 'CodeBlock',
    dash_highlight = 'Dash',
    dash_string = '-',
    quote_highlight = 'Quote',
    quote_string = '┃',
    fat_headlines = true,
    fat_headline_upper_string = '▃',
    fat_headline_lower_string = '🬂',
  },
  norg = {
    query = vim.treesitter.query.parse(
      'norg',
      [[
          [
              (heading1_prefix)
              (heading2_prefix)
              (heading3_prefix)
              (heading4_prefix)
              (heading5_prefix)
              (heading6_prefix)
          ] @headline

          (weak_paragraph_delimiter) @dash
          (strong_paragraph_delimiter) @doubledash

          ([(ranged_tag
              name: (tag_name) @_name
              (#eq? @_name "code")
          )
          (ranged_verbatim_tag
              name: (tag_name) @_name
              (#eq? @_name "code")
          )] @codeblock (#offset! @codeblock 0 0 1 0))

          (quote1_prefix) @quote
      ]]
    ),
    headline_highlights = { 'Headline' },
    codeblock_highlight = 'CodeBlock',
    dash_highlight = 'Dash',
    dash_string = '-',
    doubledash_highlight = 'DoubleDash',
    doubledash_string = '=',
    quote_highlight = 'Quote',
    quote_string = '┃',
    fat_headlines = true,
    fat_headline_upper_string = '▃',
    fat_headline_lower_string = '🬂',
  },
  org = {
    query = vim.treesitter.query.parse(
      'org',
      [[
          (headline (stars) @headline)

          (
              (expr) @dash
              (#match? @dash "^-----+$")
          )

          (block
              name: (expr) @_name
              (#eq? @_name "src")
          ) @codeblock

          (paragraph . (expr) @quote
              (#eq? @quote ">")
          )
      ]]
    ),
    headline_highlights = { 'Headline' },
    codeblock_highlight = 'CodeBlock',
    dash_highlight = 'Dash',
    dash_string = '-',
    quote_highlight = 'Quote',
    quote_string = '┃',
    fat_headlines = true,
    fat_headline_upper_string = '▃',
    fat_headline_lower_string = '🬂',
  },
}
-- TODO: make gradient headlines
local config = {
  markdown = {
    headline_highlights = { 'Headline1', 'Headline2', 'Headline3', 'Headline4', 'Headline5', 'Headline6' },
    -- codeblock_highlight = 'CodeBlock',
    -- dash_highlight = 'Dash',
    -- dash_string = '-',
    -- quote_highlight = 'Quote',
    -- quote_string = '┃',
    -- fat_headlines = true,
    -- fat_headline_upper_string = '▃',
    -- fat_headline_lower_string = '🬂',
    fat_headline_lower_string = '▔',
    -- (lower blocks) ▃ ▁▂▃▄▅▆▇█  (upper blocks)▔🬂▀
  },
  pandoc = {
    headline_highlights = { 'Headline1', 'Headline2', 'Headline3', 'Headline4', 'Headline5', 'Headline6' },
  },
  org = {
    headline_highlights = { 'Headline1', 'Headline2' },
  },
  yaml = {
    query = vim.treesitter.query.parse(
      'yaml',
      [[
          (
              (comment) @dash
              (#match? @dash "^# ---+$")
          )
      ]]
    ),
    dash_highlight = 'Dash',
  },
}

require('headlines').setup(config)
