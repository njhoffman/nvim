if exists('b:current_syntax')
  let s:current_syntax = b:current_syntax
  unlet b:current_syntax
endif

if exists('s:current_syntax')
  let b:current_syntax = s:current_syntax
endif


"" Leepfrog spidermonkey keywords and PSL flags in javascript context
syn match spiderCodeBlock "%spidercode%"
syn match spiderCodeKeyword "\b(\|print_doc\|print_stdout\|print_debug\|print_filetodoc\|md5base64\|base64\|iconv\|getenv\|query_pdb\|query_pagedb_oneline\|attr_all\|load_tcf\|revert_tcf\|sendfilehash\|addwarning\|getwarnings\|addrepublish\|addapprovelist\|html_diff\|settcfdiff\|htmltidy\|attr_diff\|get_pends\|http_get\|get_email\|attr_write\|mkpage\|spell_check\|spell_suggest\|spell_add\|jpeg_getheight\|jpeg_getwidth\|resizeimage\|image_info\|image_manip\|image_text\|dbquery\|dbexec\|dbconstruct\|docXML\|escxml\|escjsvar\|escattr\|escurl\|escid\|esccss\|safehtml\|fopen\|fgets\|feof\|zipFile)\b"
syn match pslPositive '%?\w\+?%'
syn match pslNegative '%!\w\+!%'

if get(g:, 'vim_jsx_pretty_disable_js', 0)
  finish
endif

source <sfile>:h/jsx.vim
