#!/usr/bin/env -S nvim -l

-- Manual test script for ColorschemeExport
-- Run with: nvim -l tests/manual/test_colorscheme_export.lua

-- Add config to runtime path
vim.opt.rtp:prepend(".")

print("=== ColorschemeExport Manual Test ===\n")

-- Load the module
local colorscheme_export = require("commands.colorscheme_export")
print("✓ Module loaded successfully")

-- Test 1: Generate tmTheme
print("\nTest 1: Generate tmTheme XML")
local xml = colorscheme_export.generate_tmtheme("test-theme")
assert(xml ~= nil, "XML should not be nil")
assert(type(xml) == "string", "XML should be a string")
assert(xml:match('<?xml'), "Should have XML declaration")
assert(xml:match("<plist"), "Should have plist tag")
assert(xml:match("test%-theme"), "Should contain theme name")
print("✓ Generated " .. #xml .. " bytes of XML")
print("✓ Contains valid XML structure")

-- Test 2: Check XML structure
print("\nTest 2: Validate XML structure")
local _, open_dict = xml:gsub("<dict>", "")
local _, close_dict = xml:gsub("</dict>", "")
assert(open_dict == close_dict, "Dict tags should be balanced")
print("✓ XML tags are balanced")

-- Test 3: Check for required elements
print("\nTest 3: Check required elements")
assert(xml:match("<key>name</key>"), "Should have name key")
assert(xml:match("<key>settings</key>"), "Should have settings key")
assert(xml:match("<array>"), "Should have settings array")
print("✓ Contains required tmTheme elements")

-- Test 4: Check color definitions
print("\nTest 4: Check color definitions")
local colors = {}
for color in xml:gmatch("#[0-9a-fA-F]+") do
  table.insert(colors, color)
end
print("✓ Found " .. #colors .. " color definitions")

-- Test 5: Test export function (creates buffer)
print("\nTest 5: Test export function")
local bufnr = colorscheme_export.export({ colorscheme = "manual-test" })
assert(bufnr ~= nil, "Should return buffer number")
assert(vim.api.nvim_buf_is_valid(bufnr), "Buffer should be valid")
local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
assert(buftype == "nofile", "Buffer should be nofile type")
local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
assert(#lines > 0, "Buffer should have content")
print("✓ Created buffer with " .. #lines .. " lines")
print("✓ Buffer type: " .. buftype)

-- Cleanup
vim.api.nvim_buf_delete(bufnr, { force = true })
print("✓ Cleaned up test buffer")

-- Test 6: Sample XML output
print("\nTest 6: Sample output (first 500 chars):")
print(string.rep("-", 60))
print(xml:sub(1, 500))
print(string.rep("-", 60))

print("\n=== All Tests Passed! ===")
print("\nYou can now use :ColorschemeExport in Neovim to export your colorscheme")
print("Example: :ColorschemeExport")
print("Example: :ColorschemeExport nord-nick")
