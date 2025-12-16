; extends

; NOTE: For HTML files with %spidercode% blocks, the HTML parser breaks on '<'
; characters in JavaScript code. Use filetype 'spidercode' instead for files
; that contain %spidercode% blocks with JavaScript that uses '<' operators.
;
; The spidercode parser handles this correctly by treating the block content
; as raw text before injecting JavaScript.
;
; To use: set filetype to 'spidercode' for files with these blocks, or use
; the autocommand in filetype.lua that auto-detects %spidercode% in HTML files.

; Simple injection for HTML files where JS doesn't contain '<' characters
; (This won't work reliably if JS has comparison operators like '<')
((text) @injection.content
  (#lua-match? @injection.content "^%%spidercode%%\n")
  (#lua-match? @injection.content "\n%%spidercode%%$")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.language "javascript"))
