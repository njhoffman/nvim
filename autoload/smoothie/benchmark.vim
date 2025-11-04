" smoothie/benchmark.vim: Thin wrapper that loads from lua/smoothie
" This file exists to maintain autoload compatibility while keeping code in lua/smoothie

" Source the actual implementation from lua/smoothie
let s:smoothie_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h')
execute 'source ' . s:smoothie_path . '/lua/smoothie/benchmark_viml.vim'
