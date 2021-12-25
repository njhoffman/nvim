vim.cmd [[let g:conflict_marker_begin = '^<<<<<<< \@=']]
vim.cmd [[let g:conflict_marker_common_ancestors = '^||||||| .*$']]
vim.cmd [[let g:conflict_marker_separator = '^=======$']]
vim.cmd [[let g:conflict_marker_end   = '^>>>>>>> \@=']]
vim.g.conflict_marker_enable_highlight = 1

-- begin conflict marker (<<<<<<<)
--   ConflictMarkerBegin
-- ours part of the conflict
--   ConflictMarkerOurs
-- common ancestors marker
--    (`\	\	\	\	\	\	\	`)ConflictMarkerCommonAncestors
-- common ancestors part of the conflict
--   ConflictMarkerCommonAncestorsHunk
-- separator conflict marker (=======)
--   ConflictMarkerSeparator
-- theirs part of the conflict
--   ConflictMarkerTheirs
-- end conflict marker (>>>>>>>)
--   ConflictMarkerEnd

-- let g:conflict_marker_highlight_group = 'Error'
-- ConflictMarkerOurs, ConflictMarkerTheirs,
-- and ConflictMarkerCommonAncestors are not linked to any syntax group by default,
-- and can be used to customize the highlight of the ours and theirs parts of the conflict.
-- To use a specific highlight for each marker, disable the default highlight group,
-- and define your own highlights for each syntax group.
-- Example:
-- " disable the default highlight group
-- let g:conflict_marker_highlight_group = ''
-- " Include text after begin and end markers
-- let g:conflict_marker_begin = '^<<<<<<< .*$'
-- let g:conflict_marker_end   = '^>>>>>>> .*$'
-- highlight ConflictMarkerBegin guibg=#2f7366
-- highlight ConflictMarkerOurs guibg=#2e5049
-- highlight ConflictMarkerTheirs guibg=#344f69
-- highlight ConflictMarkerEnd guibg=#2f628e
-- highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
--
-- This plugin defines mappings as default: ct for theirs, co for ours, cn for none and cb for both.
-- Use the following option to disable mappings:
-- let g:conflict_marker_enable_mappings = 0
-- theirs:   ↓ct or :ConflictMarkerThemselves
-- ours:     ↓co or :ConflictMarkerOurselves
-- both:     ↓cb or :ConflictMarkerBoth
-- both rev: ↓cB or :ConflictMarkerBoth!
-- none:     ↓cn or :ConflictMarkerNone
