local M = {
  -- ds: delete_surround <Plug>Dsurround
  you_surround = {
    short = "you surround (add)",
  },
  you_surround_nl = {
    short = "you surround on new line",
  },
  you_surround_line_trim_nl1 = {
    short = "you surround line on new line, trimmed",
  },
  you_surround_line_trim_nl2 = {
    short = "you surround line on new line, trimmed",
  },
  you_surround_line_trim = {
    short = "you surround line trimmed",
  },
  surround_around_nl = { short = "surround around line on new line, trimmed" },
  surround_around = {
    short = "surround around line, whitespace trimmed",
  },
  surround_around_line_trim_nl2 = {
    short = "surround around line on new line, trimmed",
  },
  surround_around_line_trim_nl1 = {
    short = "surround around line on new line, trimmed",
  },
  surround_around_line_trim = {
    short = "surround around line whitespace trimmed",
  },
  surround_visual_add_inner = {
    short = "surround add inside visual selection",
  },
  surround_visual_add_outer = {
    short = "surround add around visual selection",
  },
  surround_visual_add_newline = {
    short = "surround add newline whitespace no indent",
    long = "surround visual selection new line whitespace no indent",
  },
  change_surround = {
    short = "change surround"
  },
  change_paren = {
    short = "change surround paren ()"
  },
  change_brace = {
    short = "change surround brace {}"
  },
  change_bracket = {
    short = "change surround bracket []"
  },
  change_block = {
    short = "change surround block"
  },
  change_func = {
    short = "change surround function"
  },
  change_quote = {
    short = 'change surround quote "'
  },
  change_grave = {
    short = "change surround grave mark`"
  },
  change_single_quote = {
    short = "change surround single-quote"
  },
  change_tag = {
    short = "change surround tag"
  },
  delete_surround = {
    short = "delete surround"
  },
  delete_paren = {
    short = "delete surround paren ()"
  },
  delete_brace = {
    short = "delete surround brace {}"
  },
  delete_bracket = {
    short = "delete surround bracket []"
  },
  delete_block = {
    short = "delete surround block"
  },
  delete_func = {
    short = "delete surround function"
  },
  delete_quote = {
    short = 'delete surround quote ""'
  },
  delete_grave = {
    short = "delete surround grave mark`"
  },
  delete_single_quote = {
    short = "delete surround single-quote ''"
  },
  delete_tag = {
    short = "delete surround tag <></>"
  },
  -- cs: change (replace) surround
  -- ys: you surround (add)
  -- as: add surround alias
  -- s: add surround visual
  -- add surround insert
}
return M
