local actions = require("plugs.config.selectease.actions")
local keymap = require("plugs.config.selectease.mapping")
local M = require("mapper")

-- local vmap = require("mapper").vmap

M.map({ "n", "s", "i" }, keymap.select_down[1], actions.select_node_down, keymap.select_down[2])
M.map({ "n", "s", "i" }, keymap.select_up[1], actions.select_node_up, keymap.select_up[2])
M.map({ "n", "s", "i" }, keymap.select_left[1], actions.select_node_left, keymap.select_left[2])
M.map({ "n", "s", "i" }, keymap.select_right[1], actions.select_node_right, keymap.select_right[2])
M.map({ "n", "s", "i" }, keymap.swap_down[1], actions.swap_nodes_down, keymap.swap_down[2])
M.map({ "n", "s", "i" }, keymap.swap_up[1], actions.swap_nodes_up, keymap.swap_up[2])
M.map({ "n", "s", "i" }, keymap.swap_left[1], actions.swap_nodes_left, keymap.swap_left[2])
M.map({ "n", "s", "i" }, keymap.swap_right[1], actions.swap_nodes_right, keymap.swap_right[2])
