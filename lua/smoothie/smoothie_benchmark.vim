" smoothie_benchmark.vim: Benchmarking commands for vim-smoothie
" Commands to control and view smoothie benchmarking

if !exists('g:smoothie_benchmark_enabled')
  let g:smoothie_benchmark_enabled = 0
endif

" Commands
command! SmoothieBenchmarkEnable call smoothie#benchmark#enable()
command! SmoothieBenchmarkDisable call smoothie#benchmark#disable()
command! SmoothieBenchmarkToggle call smoothie#benchmark#toggle()
command! SmoothieBenchmarkReset call smoothie#benchmark#reset()
command! SmoothieBenchmarkStats call smoothie#benchmark#show_stats()

" Shorter aliases
command! SBEnable call smoothie#benchmark#enable()
command! SBDisable call smoothie#benchmark#disable()
command! SBToggle call smoothie#benchmark#toggle()
command! SBReset call smoothie#benchmark#reset()
command! SBStats call smoothie#benchmark#show_stats()

" vim: et ts=2 sw=2
