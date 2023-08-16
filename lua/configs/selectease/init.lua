local actions = require('configs.selectease.actions')
local keymap = require('configs.selectease.mapping')
local M = require('mapper')

local select_ease = require('SelectEase')

-- local vmap = require("mapper").vmap

-- SelectEase is a tool designed to identify all nodes that match a query and select the relevant target
-- from the cursor, all in Select Mode. Its purpose is to efficiently locate nodes near the cursor
-- and enable the user to easily edit that node by typing over it.
--
-- Vim's Select Mode allows you to type over a visual selection instead of using commands
-- to delete or clear it, making text editing more efficient in certain cases.

-- For more language support check the `Queries` section

M.map({ 'n', 's', 'i' }, keymap.select_down[1], actions.select_node_down, keymap.select_down[2])
M.map({ 'n', 's', 'i' }, keymap.select_up[1], actions.select_node_up, keymap.select_up[2])
M.map({ 'n', 's', 'i' }, keymap.select_left[1], actions.select_node_left, keymap.select_left[2])
M.map({ 'n', 's', 'i' }, keymap.select_right[1], actions.select_node_right, keymap.select_right[2])

M.map({ 'n', 's', 'i' }, keymap.swap_down[1], actions.swap_nodes_down, keymap.swap_down[2])
M.map({ 'n', 's', 'i' }, keymap.swap_up[1], actions.swap_nodes_up, keymap.swap_up[2])
M.map({ 'n', 's', 'i' }, keymap.swap_left[1], actions.swap_nodes_left, keymap.swap_left[2])
M.map({ 'n', 's', 'i' }, keymap.swap_right[1], actions.swap_nodes_right, keymap.swap_right[2])
