-- vim.cmd([[
--   silent! map <unique> <C-f>      <Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)
--   silent! map <unique> <C-b>      <Plug>(SmoothieUpwards)
--   silent! map <unique> G          <Plug>(Smoothie_G)
--   silent! map <unique> gg         <Plug>(Smoothie_gg)
--   silent! map <unique> <Space>    <Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)
-- ]])

-- M.map("Movement", "n", "<C-f>", "scroll_forwards", { noremap = false })
-- M.map("Movement", "n", " ", "scroll_forwards2", { noremap = false })
-- M.map("Movement", "n", "<C-b>", "scroll_backwards", { noremap = false })
-- -- M.map("Movement", "n", "<space>", "scroll_forwardsx3", {noremap = false})
-- M.map("Movement", "n", "G", "scroll_bottom", { noremap = false })
-- M.map("Movement", "n", "gg", "scroll_top", { noremap = false })

-- `g:smoothie_experimental_mappings`: Set this to true to enable additional,

-- vim.g.smoothie_speed_constant_factor = 5
-- if !exists('g:smoothie_minimum_speed')
--   ""
--   " Minimum scrolling speed (in lines per second) the animation will stay
--   " over. This hard limit ensures that the user will never have to wait too
--   " long for the animation to finish, regardless of the velocity curve and
--   " ease-out algorithm used.
--   let g:smoothie_minimum_speed = 10.0
-- endif

-- if !exists('g:smoothie_speed_exponentiation_factor')
--   let g:smoothie_minimum_speed = 0.9

-- if !get(g:, 'smoothie_no_default_mappings', v:false)
--   silent! map <unique> <C-D>      <Plug>(SmoothieDownwards)
--   silent! map <unique> <C-U>      <Plug>(SmoothieUpwards)
--   silent! map <unique> <C-F>      <Plug>(SmoothieForwards)
--   silent! map <unique> <S-Down>   <Plug>(SmoothieForwards)
--   silent! map <unique> <PageDown> <Plug>(SmoothieForwards)
--   silent! map <unique> <C-B>      <Plug>(SmoothieBackwards)
--   silent! map <unique> <S-Up>     <Plug>(SmoothieBackwards)
--   silent! map <unique> <PageUp>   <Plug>(SmoothieBackwards)
--   if get(g:, 'smoothie_experimental_mappings', v:false)
--     silent! map <unique> gg         <Plug>(Smoothie_gg)
--     silent! map <unique> G          <Plug>(Smoothie_G)
--   endif
-- endif

-- f !exists('g:smoothie_enabled')
--   ""
--   " Set it to 0 to disable vim-smoothie.  Useful for very slow connections.
--   let g:smoothie_enabled = 1
-- endif

-- if !exists('g:smoothie_update_interval')
--   ""
--   " Time (in milliseconds) between subsequent screen/cursor position updates.
--   " Lower value produces smoother animation.  Might be useful to increase it
--   " when running Vim over low-bandwidth/high-latency connections.
--   let g:smoothie_update_interval = 20
-- endif

-- if !exists('g:smoothie_speed_constant_factor')
--   ""
--   " This value controls constant term of the velocity curve. Increasing this
--   " boosts primarily cursor speed at the end of animation.
--   let g:smoothie_speed_constant_factor = 10
-- endif

-- if !exists('g:smoothie_speed_linear_factor')
--   ""
--   " This value controls linear term of the velocity curve. Increasing this
--   " boosts primarily cursor speed at the beginning of animation.
--   let g:smoothie_speed_linear_factor = 10
-- endif

-- if !exists('g:smoothie_speed_exponentiation_factor')
--   ""
--   " This value controls exponent of the power function in the velocity curve.
--   " Generally should be less or equal to 1.0. Lower values produce longer but
--   " perceivably smoother animation.
--   let g:smoothie_speed_exponentiation_factor = 0.9
-- endif

-- if !exists('g:smoothie_break_on_reverse')
--   ""
--   " Stop immediately if we're moving and the user requested moving in opposite
--   " direction.  It's mostly useful at very low scrolling speeds, hence
--   " disabled by default.
--   let g:smoothie_break_on_reverse = 0
-- endif
