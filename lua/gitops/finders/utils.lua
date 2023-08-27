local utils = require('gitops.utils')
local strings = require('plenary.strings')

local M = {}
local last_prompt = nil

M.split_query_from_author = function(query)
  local author = nil
  local prompt = nil
  if query ~= nil and query ~= '' then
    -- starts with @
    if query:sub(1, 1) == '@' then
      author = query:sub(2)
      return prompt, author
    end

    local split = utils.split_string(query, '@')
    prompt = split[1]

    -- remove last space from prompt
    if prompt:sub(-1) == ' ' then
      prompt = prompt:sub(1, -2)
    end

    author = split[2]
  end

  return prompt, author
end

local build_widths = function(results)
  local widths = { hash = 0, date = 0, message = 0, author = 0 }
  for _, entry in pairs(results) do
    for key, value in pairs(widths) do
      -- TODO: allow title to be a string or { string, highlight } table
      widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ''))
    end
  end
  return widths
end

local entry_display = require('telescope.pickers.entry_display')
local displayer = entry_display.create({
  separator = ' ',
  items = {
    { width = 9 },
    { width = 12 },
    { remaining = true },
    { width = 20 },
  },
})

local function make_display(entry)
  return displayer({
    {
      -- strings.align_str(entry.hash, widths.name, true),
      entry.value.hash,
      'TelescopeResultsClass',
    },
    {
      entry.value.date,
      'TelescopeResultsComment',
    },
    {
      entry.value.message,
      '@text.title',
    },
    {
      entry.value.author,
      'Comment',
    },
  })
end

M.git_log_entry_maker = function(entry)
  -- local widths = build_widths(entry)
  local split = utils.split_string(entry, '|')
  local hash = split[1]
  local date = string.gsub(split[2], ' ago', '')
  if string.match(date, 'year') then
    date = string.gsub(date, 'years?, ', 'yr ')
    date = string.gsub(date, ' months?%)', ' mo%)')
  end
  local message = split[3]
  local author = split[4]
  return {
    value = {
      hash = hash,
      date = date,
      message = message,
      author = author,
    },
    display = make_display,
    -- display = hash .. " " .. date .. " " .. message .. " - " .. author,
    -- display = hash .. " @ " .. date .. " by " .. author .. " --" .. message,
    ordinal = author .. ' ' .. message,
    preview_title = hash .. ' -- ' .. message,
    opts = {
      commit_hash = hash,
      date = date,
      author = author,
      message = message,
      prompt = last_prompt,
    },
  }
end

M.set_last_prompt = function(prompt)
  last_prompt = prompt
end

return M
