let s:err = {}
let s:errmsg = ''
function! ingo#err#Get( ... )
    return (a:0 ? get(s:err, a:1, '') : s:errmsg)
endfunction
