-- Verify dependencies are installed
local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("dirpicker requires telescope.nvim: https://github.com/nvim-telescope/telescope.nvim")
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local opts = {
  prompt_title = function()
    return "dirpicker"
  end,
  dir_command = { "fd", "--type=d", ".", os.getenv("HOME") },
  command_executer = { "bash", "-c" },
  previewer_command = "ls -a",
  entry_value_fn = function(entry_value)
    return '"' .. entry_value .. '"'
  end,
  pager_command = 'bat --plain --paging=always --pager="less -RS"',
  entry_maker = function(line)
    return {
      value = line,
      display = function(entry)
        return "󰉋 " .. line:gsub(os.getenv("HOME") .. "/", ""), { { { 1, 3 }, "Directory" } }
      end,
      ordinal = line,
    }
  end,
  mappings = {
    default = function(directory)
      vim.notify(directory)
    end,
    ["<M-.>"] = nil,
    ["<M-,>"] = nil,
    ["<M-}>"] = nil,
    ["<C-g>"] = function(directory)
      vim.cmd.cd(directory)
    end,
    ["<C-t>"] = function(directory)
      vim.cmd.tcd(directory)
    end,
  },
}

local function mapping(prompt_bufnr, command)
  return function()
    actions.close(prompt_bufnr)
    local directory = action_state.get_selected_entry().value
    if directory ~= nil then
      command(directory)
    end
  end
end

local function resolve_prompt_title(prompt_title)
  local prompt_type = type(prompt_title)
  if prompt_type == "function" then
    return prompt_title()
  else
    return prompt_title
  end
end

local function run(o)
  o = vim.tbl_deep_extend("force", opts, o or {})
  o.prompt_title = resolve_prompt_title(o.prompt_title)
  pickers
    .new(o, {
      prompt_title = o.prompt_title,
      finder = finders.new_oneshot_job(o.dir_command, o),
      previewer = previewers.new_termopen_previewer({
        get_command = function(entry)
          return vim.iter({
            o.command_executer,
            o.previewer_command .. " " .. o.entry_value_fn(entry.value) .. " | " .. o.pager_command,
          }):flatten(math.huge):totable()
        end,
      }),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(mapping(prompt_bufnr, o.mappings.default))
        for key, command in pairs(o.mappings) do
          if key ~= "default" then
            map("i", key, mapping(prompt_bufnr, command))
            map("n", key, mapping(prompt_bufnr, command))
          end
        end
        return true
      end,
    })
    :find()
end

local function setup(o)
  o = o or {}
  opts = vim.tbl_deep_extend("force", opts, o)
end

return telescope.register_extension({
  run = run,
  setup = setup,
})
