" smoothie/benchmark.vim: Benchmarking infrastructure for vim-smoothie
" Autoload functions for tracking timing, performance metrics, and turbulence

" Benchmark data structure
let s:benchmark_data = {
      \ 'enabled': 0,
      \ 'operations': [],
      \ 'current_op': {},
      \ 'frame_times': [],
      \ 'stats': {
      \   'total_lines': 0,
      \   'total_time_ms': 0,
      \   'operation_count': 0,
      \   'turbulence_events': 0,
      \ }
      \}

""
" Enable benchmarking
function! smoothie#benchmark#enable()
  let s:benchmark_data.enabled = 1
  let g:smoothie_benchmark_enabled = 1
  echohl MoreMsg
  echo 'Smoothie benchmarking enabled'
  echohl None
endfunction

""
" Disable benchmarking
function! smoothie#benchmark#disable()
  let s:benchmark_data.enabled = 0
  let g:smoothie_benchmark_enabled = 0
  echohl MoreMsg
  echo 'Smoothie benchmarking disabled'
  echohl None
endfunction

""
" Toggle benchmarking
function! smoothie#benchmark#toggle()
  if s:benchmark_data.enabled
    call smoothie#benchmark#disable()
  else
    call smoothie#benchmark#enable()
  endif
endfunction

""
" Reset benchmark data
function! smoothie#benchmark#reset()
  let s:benchmark_data.operations = []
  let s:benchmark_data.frame_times = []
  let s:benchmark_data.stats = {
        \ 'total_lines': 0,
        \ 'total_time_ms': 0,
        \ 'operation_count': 0,
        \ 'turbulence_events': 0,
        \ }
  echohl MoreMsg
  echo 'Smoothie benchmark data reset'
  echohl None
endfunction

""
" Start tracking a scroll operation
function! smoothie#benchmark#start_op(operation_type, target_lines)
  if !s:benchmark_data.enabled
    return
  endif

  let s:benchmark_data.current_op = {
        \ 'type': a:operation_type,
        \ 'start_time': reltime(),
        \ 'start_line': line('.'),
        \ 'target_lines': a:target_lines,
        \ 'frames': [],
        \ 'frame_count': 0,
        \ 'turbulence_score': 0.0,
        \ }
endfunction

""
" Record a frame during animation
function! smoothie#benchmark#record_frame()
  if !s:benchmark_data.enabled || empty(s:benchmark_data.current_op)
    return
  endif

  let l:now = reltime()
  let l:frame_data = {
        \ 'time': l:now,
        \ 'line': line('.'),
        \ }

  " Calculate frame interval if we have a previous frame
  if len(s:benchmark_data.current_op.frames) > 0
    let l:prev_frame = s:benchmark_data.current_op.frames[-1]
    let l:interval_ms = reltimefloat(reltime(l:prev_frame.time, l:now)) * 1000.0
    let l:frame_data.interval_ms = l:interval_ms

    " Detect turbulence: frame interval significantly different from update_interval
    let l:expected_interval = g:smoothie_update_interval
    let l:deviation = abs(l:interval_ms - l:expected_interval)
    let l:turbulence_threshold = l:expected_interval * 0.5  " 50% deviation threshold

    if l:deviation > l:turbulence_threshold
      let s:benchmark_data.current_op.turbulence_score += l:deviation
      let s:benchmark_data.stats.turbulence_events += 1
    endif
  endif

  call add(s:benchmark_data.current_op.frames, l:frame_data)
  let s:benchmark_data.current_op.frame_count += 1
endfunction

""
" End tracking a scroll operation
function! smoothie#benchmark#end_op()
  if !s:benchmark_data.enabled || empty(s:benchmark_data.current_op)
    return
  endif

  let s:benchmark_data.current_op.end_time = reltime()
  let s:benchmark_data.current_op.end_line = line('.')

  " Calculate actual lines scrolled
  let l:actual_lines = abs(s:benchmark_data.current_op.end_line - s:benchmark_data.current_op.start_line)
  let s:benchmark_data.current_op.actual_lines = l:actual_lines

  " Calculate duration in milliseconds
  let l:duration_ms = reltimefloat(reltime(s:benchmark_data.current_op.start_time, s:benchmark_data.current_op.end_time)) * 1000.0
  let s:benchmark_data.current_op.duration_ms = l:duration_ms

  " Calculate average speed (lines per second)
  if l:duration_ms > 0
    let s:benchmark_data.current_op.avg_speed_lps = (l:actual_lines / l:duration_ms) * 1000.0
  else
    let s:benchmark_data.current_op.avg_speed_lps = 0
  endif

  " Normalize turbulence score
  if s:benchmark_data.current_op.frame_count > 0
    let s:benchmark_data.current_op.turbulence_score = s:benchmark_data.current_op.turbulence_score / s:benchmark_data.current_op.frame_count
  endif

  " Update aggregate stats
  let s:benchmark_data.stats.total_lines += l:actual_lines
  let s:benchmark_data.stats.total_time_ms += l:duration_ms
  let s:benchmark_data.stats.operation_count += 1

  " Store completed operation
  call add(s:benchmark_data.operations, s:benchmark_data.current_op)
  let s:benchmark_data.current_op = {}
endfunction

""
" Get current benchmark data
function! smoothie#benchmark#get_data()
  return s:benchmark_data
endfunction

""
" Calculate statistics from benchmark data
function! smoothie#benchmark#calculate_stats()
  let l:data = s:benchmark_data

  if l:data.stats.operation_count == 0
    return {
          \ 'error': 'No operations recorded',
          \ }
  endif

  " Calculate average lines per minute
  let l:avg_lpm = 0
  if l:data.stats.total_time_ms > 0
    let l:avg_lpm = (l:data.stats.total_lines / l:data.stats.total_time_ms) * 60000.0
  endif

  " Calculate speed statistics from operations
  let l:speeds = []
  let l:turbulence_scores = []
  for op in l:data.operations
    call add(l:speeds, op.avg_speed_lps)
    call add(l:turbulence_scores, op.turbulence_score)
  endfor

  " Calculate min, max, mean, stddev
  let l:min_speed = min(l:speeds)
  let l:max_speed = max(l:speeds)
  let l:mean_speed = eval(join(l:speeds, '+')) / len(l:speeds)

  " Standard deviation calculation
  let l:variance_sum = 0.0
  for speed in l:speeds
    let l:diff = speed - l:mean_speed
    let l:variance_sum += l:diff * l:diff
  endfor
  let l:stddev = sqrt(l:variance_sum / len(l:speeds))

  " Average turbulence
  let l:avg_turbulence = eval(join(l:turbulence_scores, '+')) / len(l:turbulence_scores)

  return {
        \ 'operation_count': l:data.stats.operation_count,
        \ 'total_lines': l:data.stats.total_lines,
        \ 'total_time_ms': l:data.stats.total_time_ms,
        \ 'avg_lines_per_minute': l:avg_lpm,
        \ 'avg_speed_lps': l:mean_speed,
        \ 'min_speed_lps': l:min_speed,
        \ 'max_speed_lps': l:max_speed,
        \ 'speed_stddev': l:stddev,
        \ 'turbulence_events': l:data.stats.turbulence_events,
        \ 'avg_turbulence': l:avg_turbulence,
        \ 'consistency_score': 100.0 - (l:stddev / l:mean_speed * 100.0),
        \ }
endfunction

""
" Format stats for display
function! smoothie#benchmark#format_stats()
  let l:stats = smoothie#benchmark#calculate_stats()

  if has_key(l:stats, 'error')
    return [l:stats.error]
  endif

  let l:lines = []
  call add(l:lines, '╔═══════════════════════════════════════════════════╗')
  call add(l:lines, '║       SMOOTHIE BENCHMARK STATISTICS (VimL)        ║')
  call add(l:lines, '╠═══════════════════════════════════════════════════╣')
  call add(l:lines, printf('║ Operations:              %20d ║', l:stats.operation_count))
  call add(l:lines, printf('║ Total Lines Scrolled:    %20d ║', l:stats.total_lines))
  call add(l:lines, printf('║ Total Time:              %17.2f ms ║', l:stats.total_time_ms))
  call add(l:lines, '╠═══════════════════════════════════════════════════╣')
  call add(l:lines, '║                 SPEED METRICS                     ║')
  call add(l:lines, '╠═══════════════════════════════════════════════════╣')
  call add(l:lines, printf('║ Avg Lines/Minute:        %20.2f ║', l:stats.avg_lines_per_minute))
  call add(l:lines, printf('║ Avg Speed:               %17.2f l/s ║', l:stats.avg_speed_lps))
  call add(l:lines, printf('║ Min Speed:               %17.2f l/s ║', l:stats.min_speed_lps))
  call add(l:lines, printf('║ Max Speed:               %17.2f l/s ║', l:stats.max_speed_lps))
  call add(l:lines, printf('║ Speed StdDev:            %17.2f l/s ║', l:stats.speed_stddev))
  call add(l:lines, '╠═══════════════════════════════════════════════════╣')
  call add(l:lines, '║              SMOOTHNESS METRICS                   ║')
  call add(l:lines, '╠═══════════════════════════════════════════════════╣')
  call add(l:lines, printf('║ Turbulence Events:       %20d ║', l:stats.turbulence_events))
  call add(l:lines, printf('║ Avg Turbulence Score:    %17.2f ms ║', l:stats.avg_turbulence))
  call add(l:lines, printf('║ Consistency Score:       %18.2f%% ║', l:stats.consistency_score))
  call add(l:lines, '╚═══════════════════════════════════════════════════╝')
  call add(l:lines, '')
  call add(l:lines, 'Turbulence: Frame timing deviations from expected interval')
  call add(l:lines, 'Consistency: 100% = perfectly consistent speed')

  return l:lines
endfunction

""
" Show benchmark statistics in a floating window
function! smoothie#benchmark#show_stats()
  let l:lines = smoothie#benchmark#format_stats()

  " Calculate window dimensions
  let l:width = max(map(copy(l:lines), 'len(v:val)'))
  let l:height = len(l:lines)

  " Create floating window
  let l:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(l:buf, 0, -1, v:true, l:lines)

  " Set buffer options
  call nvim_buf_set_option(l:buf, 'modifiable', v:false)
  call nvim_buf_set_option(l:buf, 'bufhidden', 'wipe')
  call nvim_buf_set_option(l:buf, 'filetype', 'smoothie-benchmark')

  " Center the window
  let l:ui = nvim_list_uis()[0]
  let l:col = (l:ui.width - l:width) / 2
  let l:row = (l:ui.height - l:height) / 2

  let l:opts = {
        \ 'relative': 'editor',
        \ 'width': l:width,
        \ 'height': l:height,
        \ 'col': l:col,
        \ 'row': l:row,
        \ 'style': 'minimal',
        \ 'border': 'rounded',
        \ 'title': ' Smoothie Benchmarks (VimL) ',
        \ 'title_pos': 'center',
        \ }

  let l:win = nvim_open_win(l:buf, v:true, l:opts)

  " Set window options
  call nvim_win_set_option(l:win, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')

  " Close on q or <Esc>
  call nvim_buf_set_keymap(l:buf, 'n', 'q', ':close<CR>', {'nowait': v:true, 'noremap': v:true, 'silent': v:true})
  call nvim_buf_set_keymap(l:buf, 'n', '<Esc>', ':close<CR>', {'nowait': v:true, 'noremap': v:true, 'silent': v:true})
endfunction

" vim: et ts=2 sw=2
