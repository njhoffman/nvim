" Vim syntax file
" Language:         /var/log/messages file
" Maintainer:       Yakov Lerner <iler.ml@gmail.com>
" Latest Revision:  2008-06-29
" Changes:          2008-06-29 support for RFC3339 tuimestamps James Vega
" 		    2016 Jan 19: messagesDate changed by Bram
" 		    2021 Jan 27: messagesHourRFC3339 changed from #946

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match   syslogBegin       display '^' nextgroup=syslogDate,syslogDateRFC3339
syn match   syslogDate        contained display '[[:lower:][:upper:]][[:lower:][:upper:]][[:lower:][:upper:]] [ 0-9]\d *'
                                \ nextgroup=syslogHour
syn match   syslogHour        contained display '\d\d:\d\d:\d\d\s*'
                                \ nextgroup=syslogHost
syn match   syslogDateRFC3339 contained display '\d\{4}-\d\d-\d\d'
                                \ nextgroup=syslogRFC3339T
syn match   syslogRFC3339T    contained display '\cT'
                                \ nextgroup=syslogHourRFC3339
syn match   syslogHourRFC3339 contained display '\c\d\d:\d\d:\d\d\(\.\d\+\)\=\([+-]\d\d:\d\d\|Z\)\s*'
                                \ nextgroup=syslogHost
syn match   syslogHost        contained display '\S*\s*'
                                \ nextgroup=syslogLabel
syn match   syslogLabel       contained display '\s*[^:]*:\s*'
                                \ nextgroup=syslogText contains=syslogKernel,syslogPID
syn match   syslogPID         contained display '\[\zs\d\+\ze\]'
syn match   syslogKernel      contained display 'kernel:'
syn match   syslogIP          '\d\+\.\d\+\.\d\+\.\d\+'
syn match   syslogURL         '\w\+://\S\+'
syn match   syslogText        contained display '.*'
                                \ contains=syslogNumber,syslogIP,syslogURL,syslogError,logString
syn match   syslogNumber      contained '0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'
syn match   syslogError       contained '\c.*\<\(FATAL\|ERROR\|ERRORS\|FAILED\|FAILURE\).*'

" message syntax 

hi def link syslogDate        Constant
hi def link syslogHour        Type
hi def link syslogDateRFC3339 Constant
hi def link syslogHourRFC3339 Type
hi def link syslogRFC3339T    Normal
hi def link syslogHost        Identifier
hi def link syslogLabel       Label
hi def link syslogPID         Float
hi def link syslogKernel      WarningMsg
hi def link syslogError       ErrorMsg
hi def link syslogIP          Constant
hi def link syslogURL         Underlined
hi def link syslogText        Normal
hi def link syslogNumber      Number

"""""""""""""""""""""""""""""

" " Operators
" "---------------------------------------------------------------------------
syn match logOperator display '[;,\?\:\.\<=\>\~\/\@\!$\%&\+\-\|\^(){}\*#]'
syn match logBrackets display '[\[\]]'
syn match logEmptyLines display '-\{3,}'
syn match logEmptyLines display '\*\{3,}'
syn match logEmptyLines display '=\{3,}'
syn match logEmptyLines display '- - '
"
"
" " Constants
" "---------------------------------------------------------------------------
syn match logNumber       '\<-\?\d\+\>'
syn match logHexNumber    '\<0[xX]\x\+\>'
syn match logHexNumber    '\<\d\x\+\>'
syn match logBinaryNumber '\<0[bB][01]\+\>'
syn match logFloatNumber  '\<\d.\d\+[eE]\?\>'

syn keyword logBoolean    TRUE FALSE True False true false
syn keyword logNull       NULL Null null
"
syn region logString      start=/"/ end=/"/ end=/$/ skip=/\\./
" " Quoted strings, but no match on quotes like "don't", "plurals' elements"
syn region logString      start=/'\(s \|t \| \w\)\@!/ end=/'/ end=/$/ end=/s / skip=/\\./
"
"
" " Dates and Times
" "---------------------------------------------------------------------------
" " Matches 2018-03-12T or 12/03/2018 or 12/Mar/2018
syn match logDateFull '\d\{2,4}[-\/]\(\d\{2}\|Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\)[-\/]\d\{2,4}T\?'
" " Matches 8 digit numbers at start of line starting with 20
" syn match logDateFull '^20\d\{6}'
" " " Matches Fri Jan 09 or Feb 11 or Apr  3 or Sun 3
" syn keyword logDateFull Mon Tue Wed Thu Fri Sat Sun Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec nextgroup=logDateFullDay
syn match logDateFullDay '\s\{1,2}\d\{1,2}' contained
"
" " Matches 12:09:38 or 00:03:38.129Z or 01:32:12.102938 +0700
syn match logTimeFull '\d\{2}:\d\{2}:\d\{2}\(\.\d\{2,6}\)\?\(\s\?[-+]\d\{2,4}\|Z\)\?\>' nextgroup=logTimeFullZone,logSysColumns skipwhite
"
" " Follows logTime, matches UTC or PDT 2019 or 2019 EDT
syn match logTimeFullZone '[A-Z]\{2,5}\>\( \d\{4}\)\?' contained
syn match logTimeFullZone '\d\{4} [A-Z]\{2,5}\>' contained

"<function 2>
"
" " Syslog Columns
" "---------------------------------------------------------------------------
" " Syslog hostname, program and process number columns
" syn match logSysColumns '\w\(\w\|\.\|-\)\+ \(\w\|\.\|-\)\+\(\[\d\+\]\)\?:' contains=logOperator,logSysProcess contained
" syn match logSysProcess '\(\w\|\.\|-\)\+\(\[\d\+\]\)\?:' contains=logOperator,logNumber,logBrackets contained
"
"
" " XML Tags
" "---------------------------------------------------------------------------
" " Simplified matches, not accurate with the spec to avoid false positives
" syn match logXmlHeader       /<?\(\w\|-\)\+\(\s\+\w\+\(="[^"]*"\|='[^']*'\)\?\)*?>/ contains=logString,logXmlAttribute,logXmlNamespace
" syn match logXmlDoctype      /<!DOCTYPE[^>]*>/ contains=logString,logXmlAttribute,logXmlNamespace
" " syn match logXmlTag          /<\/\?\(\(\w\|-\)\+:\)\?\(\w\|-\)\+\(\(\n\|\s\)\+\(\(\w\|-\)\+:\)\?\(\w\|-\)\+\(="[^"]*"\|='[^']*'\)\?\)*\s*\/\?>/ contains=logString,logXmlAttribute,logXmlNamespace
" " syn match logXmlAttribute    contained "\w\+=" contains=logOperator
" " syn match logXmlAttribute    contained "\(\n\|\s\)\(\(\w\|-\)\+:\)\?\(\w\|-\)\+\(=\)\?" contains=logXmlNamespace,logOperator
" syn match logXmlNamespace    contained "\(\w\|-\)\+:" contains=logOperator
" syn region logXmlComment     start=/<!--/ end=/-->/
" syn match logXmlCData        /<!\[CDATA\[.*\]\]>/
" syn match logXmlEntity       /&#\?\w\+;/

" " Entities
" "---------------------------------------------------------------------------
" syn match logUrl        'http[s]\?:\/\/[^\n|,; '"]\+'
syn match logDomain     /\v(^|\s)(\w|-)+(\.(\w|-)+)+\s/
" syn match logUUID       '\w\{8}-\w\{4}-\w\{4}-\w\{4}-\w\{12}'
" syn match logMD5        '\<[a-z0-9]\{32}\>'
" syn match logIPV4       '\<\d\{1,3}\(\.\d\{1,3}\)\{3}\>'
" syn match logIPV6       '\<\x\{1,4}\(:\x\{1,4}\)\{7}\>'
" syn match logMacAddress '\<\x\{2}\(:\x\{2}\)\{5}'
syn match logFilePath   '\<\w:\\[^\n|,; ()'"\]{}]\+'
syn match logFilePath   '[^a-zA-Z0-9"']\@<=\/\w[^\n|,; ()'"\]{}]\+'
syn match logFunction   '\<function \d\+\>'
syn match logTable   '\<table \d\+\>'
syn match logMetatable   '\<metatable\>'

"
" " Levels
" "---------------------------------------------------------------------------
syn keyword logLevelEmergency EMERGENCY EMERG
syn keyword logLevelAlert ALERT
syn keyword logLevelCritical CRITICAL CRIT FATAL
syn keyword logLevelError ERROR ERR FAILURE SEVERE
syn keyword logLevelWarning WARNING WARN
syn keyword logLevelNotice NOTICE
syn keyword logLevelInfo INFO
syn keyword logLevelDebug DEBUG FINE
syn keyword logLevelTrace TRACE FINER FINEST
"

syn keyword logLevelError ERROR ERR FAILURE SEVERE   
syn keyword logLevelWarning WARNING WARN   
syn keyword logLevelInfo INFO  
syn keyword logLevelDebug DEBUG FINE   󰌵
syn keyword logLevelTrace TRACE FINER FINEST   ✎
"
" " Highlight links
" "---------------------------------------------------------------------------
hi def link logNumber Number
hi def link logHexNumber Number
hi def link logBinaryNumber Number
hi def link logFloatNumber Float
hi def link logBoolean Boolean
hi def link logNull Constant
hi def link logString String
"
hi def link logDateFull Identifier
hi def link logDateFullDay Identifier
hi def link logTime Comment 
hi def link logTimeFull Function
hi def link logTimeFullZone Identifier
"

" hi def link logSysColumns Conditional
" hi def link logSysProcess Include
"
hi def link logXmlHeader Function
hi def link logXmlDoctype Function
hi def link logXmlTag Identifier
hi def link logXmlAttribute Type
hi def link logXmlNamespace Include
hi def link logXmlComment Comment
hi def link logXmlCData String
hi def link logXmlEntity Special


hi def link logDomain Label
hi def link logFilePath Conditional
hi def link logFunction Operator
hi def link logMetatable Operator
hi def link logTable Operator
hi def link logOperator Operator
hi def link logBrackets Comment
hi def link logEmptyLines Comment
"
hi def link logLevelEmergency ErrorMsg
hi def link logLevelAlert ErrorMsg
hi def link logLevelCritical ErrorMsg
hi def link logLevelError ErrorMsg
hi def link logLevelWarning WarningMsg
hi def link logLevelNotice Character
hi def link logLevelInfo Repeat
hi def link logLevelDebug Debug
hi def link logLevelTrace Comment

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let b:current_syntax = "syslog"

let &cpo = s:cpo_save
unlet s:cpo_save
