;; extends
(
  (shortcut_link (link_text) @linkTxt (#eq? @linkTxt "<")) @conceal
  (#set! conceal "")
)
(
  (shortcut_link (link_text) @linkTxt (#eq? @linkTxt ">")) @conceal
  (#set! conceal "")
)
(
  (strikethrough) @punctuation.strikethrough
)
(code_span
  (code_span_delimiter) @markdown_code_span_delimiter
  (#set! conceal ""))
