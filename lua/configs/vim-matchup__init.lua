local init = function()
  vim.g.matchup_text_obj_linewise_operators = { "c", "d", "y" }
  vim.g.loaded_matchit = 1
  vim.g.disable_virtual_text = 1
  -- disable virtual text highlighting virtual end of blocks for langs without markers

  vim.g.matchup_enabled = 1 -- enable/disable plugin entirely
  vim.g.matchup_matchparen_enabled = 1
  vim.g.matchup_motion_enabled = 1
  vim.g.matchup_text_obj_enabled = 1
  vim.g.matchup_surround_enabled = 1 -- adds ds% and cs%

  vim.g.matchup_delim_noskips = 1 -- matching between strings and constants (0 always, 1 no words, 2 never)
  vim.g.matchup_delim_stopline = 2000 -- 1500  (# of lines to search for motions/text objects)

  vim.g.matchup_matchparen_pumvisible = 0
  -- 1 (show matching even when pum-completion is visible)
  vim.g.matchup_matchparen_offscreen = {} -- method = popup, status, status_minimal, empty dict to disable

  vim.g.matchup_motion_override_Npercent = 0 -- enable vim default {count}%
  vim.g.matchup_matchparen_timeout = 300 -- 300
  vim.g.matchup_matchparen_insert_timeout = 30 -- 60
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_deferred_fade_time = 0 -- 0 (ms match will disappear after no movement)
  vim.g.matchup_matchparen_deferred_show_delay = 100 -- 50 (time between cursor stop moving and match check)
  vim.g.matchup_matchparen_deferred_hide_delay = 700 -- 700 (hide stale matches after n seconds of cursor movement)
  vim.g.matchup_matchparen_hi_surround_always = 1
  vim.g.matchup_matchparen_stopline = 2000 -- (# of lines to search for highlighting only)
end

return init
