function! ingo#plugin#setting#GetFromScope( variableName, scopeList, ... )
    for l:scope in a:scopeList
	let l:variable = l:scope . ':' . a:variableName
	if exists(l:variable)
	    execute 'return' l:variable
	endif
    endfor
    if a:0
	return a:1
    else
	throw 'GetFromScope: No variable named "' . a:variableName . '" defined.'
    endif
endfunction

function! ingo#plugin#setting#GetBufferLocal( variableName, ... )
    return call('ingo#plugin#setting#GetFromScope', [a:variableName, ['b', 'g']] + a:000)
endfunction


