
function! health#nick#check()
  lua require 'healthcheck'.check_health()
endfunction
