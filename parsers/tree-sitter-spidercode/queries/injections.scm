; Inject JavaScript into code_content nodes (inside %spidercode% blocks)
((code_content) @injection.content
  (#set! injection.language "javascript"))

; Inject HTML into text_content nodes (outside %spidercode% blocks)
; Using injection.combined to merge all text_content regions into a single
; HTML document, allowing tags to match across spidercode block boundaries
((text_content) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined))
